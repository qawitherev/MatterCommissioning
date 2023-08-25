//
//  RequestHandler.swift
//  MatterExtension
//
//  Created by adt-qawi on 18/08/2023.
//

import MatterSupport
import os

let logger = Logger(subsystem: "com.airdroitech.commissionMtr2", category: "MatterExtension")
let appGroupName = "group.com.airdroitech.commissionMtr2"
let payloadKey = "com.aidroitech.commissionMtr2/payloadKey"

// The extension is launched in response to `MatterAddDeviceRequest.perform()` and this class is the entry point
// for the extension operations.
class RequestHandler: MatterAddDeviceExtensionRequestHandler {
    
    override init() {
        logger.log("QAWI3 - Matter Extension launched")
            super.init()
    }
    
    override func validateDeviceCredential(_ deviceCredential: MatterAddDeviceExtensionRequestHandler.DeviceCredential) async throws {
        // Use this function to perform additional attestation checks if that is useful for your ecosystem.
    }

    override func selectWiFiNetwork(from wifiScanResults: [MatterAddDeviceExtensionRequestHandler.WiFiScanResult]) async throws -> MatterAddDeviceExtensionRequestHandler.WiFiNetworkAssociation {
        // Use this function to select a Wi-Fi network for the device if your ecosystem has special requirements.
        // Or, return `.defaultSystemNetwork` to use the iOS device's current network.
        logger.log("QAWI3 - Returning default system network")
        return .defaultSystemNetwork
    }

    override func selectThreadNetwork(from threadScanResults: [MatterAddDeviceExtensionRequestHandler.ThreadScanResult]) async throws -> MatterAddDeviceExtensionRequestHandler.ThreadNetworkAssociation {
        // Use this function to select a Thread network for the device if your ecosystem has special requirements.
        // Or, return `.defaultSystemNetwork` to use the default Thread network.
        return .defaultSystemNetwork
    }

    //update 24/8 --> we are able to reach this code 🤩
    override func commissionDevice(in home: MatterAddDeviceRequest.Home?, onboardingPayload: String, commissioningID: UUID) async throws {
        // Use this function to commission the device with your Matter stack.
        
        logger.log("QAWI3 - Starting commissioning flow")
        
//        let _ = MHelper(payloadString: onboardingPayload)
        
        //--> to "pass" data between extension and host app, we use app group, for now, there is no simple way to share data
        let sharedDefaults = UserDefaults(suiteName: appGroupName)
        sharedDefaults?.set(onboardingPayload, forKey: payloadKey)
        sharedDefaults?.synchronize()
        
        //TODO: to use the NSExtensionContext
    }

    override func rooms(in home: MatterAddDeviceRequest.Home?) async -> [MatterAddDeviceRequest.Room] {
        // Use this function to return the rooms your ecosystem manages.
        // If your ecosystem manages multiple homes, ensure you are returning rooms that belong to the provided home.
        let rooms: [String] = ["Room1, Room2, Room3"]
        return rooms.map {MatterAddDeviceRequest.Room(displayName: $0)}
    }

    override func configureDevice(named name: String, in room: MatterAddDeviceRequest.Room?) async {
        // Use this function to configure the (now) commissioned device with the given name and room.
    }
}


