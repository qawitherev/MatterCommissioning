//
//  CommissionHelperNoWifi.swift
//  Runner
//
//  Created by adt-qawi on 23/08/2023.
//

import Foundation
import Matter

class CommissionHelperNoWifi {
    var c: MTRDeviceController?
    var fr: FlutterResult
    var qrString: String
    let callbackQueue = DispatchQueue(label: "com.csa.matter.qrcodevc.callback")
    init(qrString: String, fr: @escaping FlutterResult) {
        self.fr = fr
        self.qrString = qrString
        c = InitializeMTR()
        c?.setDeviceControllerDelegate(DCD(fr: fr), queue: callbackQueue)
        startCmmWoCred()
    }
    
    func startCmmWoCred() {
        let c = InitializeMTR()
        let param = MTRCommissioningParameters()
        param.failSafeTimeout = 60
        do {
            try c?.commissionNode(withID: 12, commissioningParams: param)
        } catch {
            print("QAWI0 - Failed to commissionNode()")
        }
    }
    
    func setupPayload() {
        let pl: MTRSetupPayload
        do {
            pl = try MTRSetupPayload(onboardingPayload: qrString)
            print("QAWI3 - payload setup")
            setupSession(pl: pl)
        } catch {
            print("QAWI0 - Failed to setup payload")
        }
    }
    
    func setupSession(pl: MTRSetupPayload) {
        do {
            try c?.setupCommissioningSession(with: pl, newNodeID: 12)
            print("QAWI3 - setup commissioning session")
        } catch {
            print("QAWI0 - setup session failed")
        }
    }
}

class DCD: NSObject, MTRDeviceControllerDelegate {
    var fr: FlutterResult
    
    init(fr: @escaping FlutterResult) {
        self.fr = fr
    }
    
    func controller(_ controller: MTRDeviceController, statusUpdate status: MTRCommissioningStatus) {
        print("QAWI3 - Controller delegate status is \(status)")
    }
    
    func controller(_ controller: MTRDeviceController, commissioningSessionEstablishmentDone error: Error?) {
        print("QAWI3 - session establishment done")
        let c = InitializeMTR()
        do {
            let d = try c?.deviceBeingCommissioned(withNodeID: 12)
            if (d?.sessionTransportType == .BLE) {
                startCmmWoCred()
            }
        } catch {
            print("QAWI0 - Failed to get device being commissioned")
        }
    }
    
    func controller(_ controller: MTRDeviceController, commissioningComplete error: Error?) {
        fr("OK")
        print("Commissioning is complete")
    }
    
    func startCmmWoCred() {
        let c = InitializeMTR()
        let param = MTRCommissioningParameters()
        param.failSafeTimeout = 60
        do {
            try c?.commissionNode(withID: 12, commissioningParams: param)
        } catch {
            print("QAWI0 - Failed to commissionNode()")
        }
    }
}
