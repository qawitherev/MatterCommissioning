//
//  MatterHelper.swift
//  MatterExtension
//
//  Created by adt-qawi on 18/08/2023.
//

import Foundation
import Matter

let callbackQueue = DispatchQueue(label: "com.csa.matter.qrcodevc.callback")
let newNodeId: NSNumber = 12

/*
 setup controller delegate
 setup session
 session established done
 maybe controller delegate status
 commission complete completion handler
 */

class MHelper {
    var payloadString: String
    var payload: MTRSetupPayload?
    var c: MTRDeviceController?
    
    init(payloadString: String) {
        self.payloadString = payloadString
        payload = try! MTRSetupPayload(onboardingPayload: payloadString) // --> lazy to handle error, not likely to have error
        c = InitializeMTR()
        c?.setDeviceControllerDelegate(ControllerDelegate(), queue: callbackQueue)
        startCommission()
    }
    
    func startCommission() {
        c?.setDeviceControllerDelegate(ControllerDelegate(), queue: callbackQueue)
        do {
            try c?.setupCommissioningSession(with: payload!, newNodeID: newNodeId)
            logger.log("QAWI1 - session setup success")
        } catch {
            print("QAWI0 - session setup failed")
        }
    }
}

class ControllerDelegate: NSObject, MTRDeviceControllerDelegate {
    
    let c = InitializeMTR()
    
    func controller(_ controller: MTRDeviceController, commissioningSessionEstablishmentDone error: Error?) {
        logger.log("QAWI3 - Reached commissioningSessionEstablishmentDone")
        do {
            let d = try c?.deviceBeingCommissioned(withNodeID: newNodeId)
            if (d?.sessionTransportType == .BLE) {
                logger.log("QAWI3 - Transport type is BLE, thus go default commission")
                startCommissionWithParams()
            } else {
                logger.log("QAWI3 - Transport type is not BLE, try go default")
                startCommissionWithParams()
            }
        } catch {
            logger.log("QAWI0 - Failed to get device being commissioned")
        }
    }
    
//    MTRCommissioningStatusUnknown = 0,
//    MTRCommissioningStatusSuccess = 1,
//    MTRCommissioningStatusFailed = 2,
//    MTRCommissioningStatusDiscoveringMoreDevices = 3
    func controller(_ controller: MTRDeviceController, statusUpdate status: MTRCommissioningStatus) {
        logger.log("QAWI3 - Status update is \(status.rawValue)")
    }
    
    func controller(_ controller: MTRDeviceController, commissioningComplete error: Error?) {
        print("QAWI3 - Commissioning Complete")
        let _ = MTRBaseDevice(nodeID: newNodeId, controller: c!)
        let extensionCtx = NSExtensionContext()
        extensionCtx.completeRequest(returningItems: [])
    }
    
    func startCommissionWithParams() {
        logger.log("QAWI3 - Starting commission with params")
        let prm = MTRCommissioningParameters()
        prm.failSafeTimeout = 60
        do {
            try c?.commissionNode(withID: newNodeId, commissioningParams: prm)
            logger.log("QAWI1 - Commissioning complete")
        } catch {
            logger.log("QAWI0 - Failed to commission node")
        }
    }
}
