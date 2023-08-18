//
//  MatterSupport.swift
//  Runner
//
//  Created by adt-qawi on 18/08/2023.
//

import Foundation
import MatterSupport

class MSupport {
    //for now we only hard coded the thing
    let dH1 = "Default Home 1"
    let dH2 = "Default Home 2"
    let dH3 = "Default Home 3"
    
    var home: String
    var ecosystem = "Qawi Ecosystem"
    
    var homes: [MatterAddDeviceRequest.Home]?
    var topology: MatterAddDeviceRequest.Topology?
    var req: MatterAddDeviceRequest?
    
    init(home: String, ecosystem: String = "Qawi Ecosystem", homes: [MatterAddDeviceRequest.Home]? = nil, topology: MatterAddDeviceRequest.Topology? = nil, req: MatterAddDeviceRequest? = nil) {
        self.home = home
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
        req = MatterAddDeviceRequest(topology: topology!, shouldScanNetworks: false)
        do {
            try await req?.perform()
        } catch {
            print("QAWI0 - failed to perform()")
        }
    }
}

