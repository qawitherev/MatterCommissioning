//
//  MatterSupport.swift
//  Runner
//
//  Created by adt-qawi on 18/08/2023.
//

import Foundation
import MatterSupport
import MobileCoreServices

let appGroupName = "group.com.airdroitech.commissionMtr2"
let payloadKey = "com.aidroitech.commissionMtr2/payloadKey"

class MSupport {
    //for now we only hard coded the thing
    let dH1 = "Default Home 1"
    let dH2 = "Default Home 2"
    let dH3 = "Default Home 3"
    
    var home: String
    var ecosystem = "Qawi Ecosystem"
    var result: FlutterResult
    
    var homes: [MatterAddDeviceRequest.Home]?
    var topology: MatterAddDeviceRequest.Topology?
    var req: MatterAddDeviceRequest?
    
    init(home: String, result: @escaping FlutterResult, ecosystem: String = "Qawi Ecosystem", homes: [MatterAddDeviceRequest.Home]? = nil, topology: MatterAddDeviceRequest.Topology? = nil, req: MatterAddDeviceRequest? = nil) {
        self.home = home
        self.result = result
        self.ecosystem = ecosystem
        self.homes = homes
        self.topology = topology
        self.req = req
        Task {
            await iR()
        }
    }
    
    func iR() async {
        homes = [MatterAddDeviceRequest.Home(displayName: home),
                 MatterAddDeviceRequest.Home(displayName: dH1),
                 MatterAddDeviceRequest.Home(displayName: dH2),
                 MatterAddDeviceRequest.Home(displayName: dH3)]
        topology = MatterAddDeviceRequest.Topology(ecosystemName: ecosystem, homes: homes!)
        req = MatterAddDeviceRequest(topology: topology!)
        do {
            print("QAWI3 - request.perform()")
            try await req?.perform()
            print("QAWI3 - Extension Complete")
            let exContext = NSExtensionContext()
//            if let item = exContext.inputItems.first as? NSExtensionItem,
//            let itemProvider = item.attachments?.first,
//            itemProvider.hasItemConformingToTypeIdentifier(kUTTypePlainText as String) {
//                itemProvider.loadItem(forTypeIdentifier: kUTTypePlainText as String) { (string, error) in
//                    if let string = string as? String {
//                        print("QAWI1 - Onboarding payload received: \(string)")
//                    } else {
//                        print("QAWI0 - String is null(?)")
//                    }
//                }
//            } else {
//                print("QAWI0 - Failed to get string")
//            }
            
            let sharedDefaults = UserDefaults(suiteName: appGroupName)
            let data = sharedDefaults?.object(forKey: payloadKey) as? String
            print("QAWI3 - onboardingPayload is \(data)")
//            result("OK")
        } catch {
            print("QAWI0 - failed to perform()")
        }
    }
}

