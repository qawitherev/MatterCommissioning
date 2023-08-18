//
//  CommissionHelper.swift
//  Runner
//
//  Created by adt-qawi on 17/08/2023.
//
// for now just use hardcoded wifi credentials 

import Foundation

class CommissionHelper {
    var c: MTRDeviceController?
    var qrString: String?
    var fr: FlutterResult
    let callbackQueue = DispatchQueue(label: "com.csa.matter.qrcodevc.callback")
    init(qrString: String, fr: @escaping FlutterResult) {
        self.fr = fr
        c = InitializeMTR()
        c?.setDeviceControllerDelegate(ControllerDelegate(fr: fr), queue: callbackQueue)
        setupPayload(plString: qrString)
    }
    
    /*
     setupPayload
     rendezvous
     rendezvousDefault
     */
    
    func setupPayload(plString: String) {
        let pl: MTRSetupPayload
        do {
            pl = try MTRSetupPayload(onboardingPayload: plString)
            handleRendezvous(pl: pl)
        } catch {
            print("QAWI0 - setupPayload()")
        }
    }
    
    func handleRendezvous(pl: MTRSetupPayload) {
        //ala ala handle rendezvous sini
        setupCommSession(pl: pl)
    }
    
    func setupCommSession(pl: MTRSetupPayload) {
        do {
            /*
             setupCmmSession will try to connect to device (through BLE???)
             given the payload
             and notify the controller's delegate
             */
            try c?.setupCommissioningSession(with: pl, newNodeID: 12)
        } catch {
            print("QAWI0 - rendezvousDefault() failed")
        }
    }
}

class ControllerDelegate: NSObject, MTRDeviceControllerDelegate {
    var fr: FlutterResult
    
    init(fr: @escaping FlutterResult) {
        self.fr = fr
    }
    
    func controller(_ controller: MTRDeviceController, statusUpdate status: MTRCommissioningStatus) {
        let status = status
        print("QAWI3 - ControllerDelegate status is \(status)")
    }
    
    func controller(_ controller: MTRDeviceController, commissioningSessionEstablishmentDone error: Error?) {
        print("QAWI3 - commissioningSessionEstablishmentDone")
        if (error != nil) {
            return
        }
        /*
         1. dapatkan controller?
         2. dapatkan deviceId
         3. dapatkan base device pakai controller and deviceId
         4. if basedevice.transporttype == BLE, retrieve and send wifi credentials
         5. not not BLE, create commissioning param,
         6. param.deviceattestationdelegate = ciptoolattestationdelegate prt
         7. params.failsafeexpirytimoutsecs = 600
         8. buat error,
         9. commission device with error
         */
        
        let c = InitializeMTR()
        let dId = MTRGetLastPairedDeviceId()
        do {
            let d = try c?.deviceBeingCommissioned(withNodeID: 12)
            if (d?.sessionTransportType == .BLE) {
                print("QAWI3 - transport type is BLE")
                let ssid = "airdroitech"
                let pwd = "airdroitech@uoa"
                commissionWithSSID(ssid: ssid, pwd: pwd)
            } else {
                //what happened here???
            }
        } catch {
            print("QAWI0 - cannot get device being commissioned")
        }
    }
    
    func controller(_ controller: MTRDeviceController, commissioningComplete error: Error?) {
        let cId = controller.controllerNodeID
        do {
            let d = try controller.deviceBeingCommissioned(withNodeID: 12)
            print("QAWI3 - commissioningComplete, controller node id is \(String(describing: cId))")
            print("QAWI3 - Base device session transport type \(d.sessionTransportType)")
        } catch {
            print("QAWI0 - Failed to get device being commissioned")
        }
    }

    func commissionWithSSID(ssid: String, pwd: String) {
        /*
         1. need controller
         2. commission param
         3. param.ssid, param.credential(pwd)
         4. param.deviceAttestDelegate --> prt
         5. fail safe expiry
         6. deviceid = getnextid - 1
         7. controller.commissionDevice (the param)
         */
        let c = InitializeMTR()
        let prm = MTRCommissioningParameters()
//        prm.wifiSSID = ssid.data(using: .utf8)
//        prm.wifiCredentials = pwd.data(using: .utf8)
        prm.deviceAttestationDelegate = AttestDelegate()
        prm.failSafeTimeout = 60
        let dId = MTRGetNextAvailableDeviceID() - 1
        do {
            try c?.commissionDevice(12, commissioningParams: prm)
        } catch {
            print("QAWI0 - Failed commission device")
        }
    }
}

class AttestDelegate: NSObject, MTRDeviceAttestationDelegate {
    
//    Notify the delegate when device attestation fails.  If this callback is implemented,
//    [continueCommissioningDevice] on MTRDeviceController is expected to be called if commisioning
//    should continue.
    
    func deviceAttestationFailed(for controller: MTRDeviceController, opaqueDeviceHandle: UnsafeMutableRawPointer, error: Error) {
        print("QAWI - Device attestation failed with error: \(error)")
        let mController = InitializeMTR()
        var shouldContinue = true //--> get from user, prolly a prompt
        if (shouldContinue) {
            do {
                try mController?.continueCommissioningDevice(opaqueDeviceHandle, ignoreAttestationFailure: true)
            } catch {
                print("QAWI - deviceAttestationFailed(): error when continueCommissioningDevice")
            }
        }
    }
}
