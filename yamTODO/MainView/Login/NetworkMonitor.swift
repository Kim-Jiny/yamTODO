//
//  NetworkNonitor.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/30.
//

import SwiftUI
import Network

class NetworkMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    @Published var isConnected = true

    init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
