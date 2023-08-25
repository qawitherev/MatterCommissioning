//
//  CommissionHelperNoWifi.swift
//  Runner
//
//  Created by adt-qawi on 23/08/2023.
//

import Foundation
import Matter

class SupportCommissionHelper {
    var payloadString: String
    var payload: MTRSetupPayload?
    var c = InitializeMTR()
    var fr: FlutterResult
    
    init(payloadString: String, fr: @escaping FlutterResult) {
        self.payloadString = payloadString
        self.fr = fr
        payload = try! MTRSetupPayload(onboardingPayload: payloadString)
        c?.setDeviceControllerDelegate(ControllerDelegateSupport(fr: fr), queue: callbackQueue)
        startCommission()
    }
    
    func startCommission() {
        do {
            try c?.setupCommissioningSession(with: payload!, newNodeID: newNodeId)
        } catch {
            fr(FlutterError(code: failedCode, message: failedResult, details: nil))
            print("QAWI0 - Failed setup session")
        }
    }
}

class ControllerDelegateSupport: NSObject, MTRDeviceControllerDelegate {
    var fr: FlutterResult
    let c = InitializeMTR()
    
    init(fr: @escaping FlutterResult) {
        self.fr = fr
    }
    
    func controller(_ controller: MTRDeviceController, statusUpdate status: MTRCommissioningStatus) {
        //status update goes here
        print("QAWI3 - Status update is \(status.self)")
    }
    
    func controller(_ controller: MTRDeviceController, commissioningComplete error: Error?) {
        print("QAWI1 - Commissioning complete")
        fr("OK")
    }
    
    func controller(_ controller: MTRDeviceController, commissioningSessionEstablishmentDone error: Error?) {
        if (error != nil) {
            print("QAWI0 - Session has error")
            return
        }
        let param = MTRCommissioningParameters()
        param.failSafeTimeout = 60 // --> timeout 1 minute
        do {
            //no need to check whether is BLE or not, because already on the network
            try c?.commissionNode(withID: newNodeId, commissioningParams: param)
        } catch {
            print("QAWI0 - commissionNode() failed")
        }
    }
}
