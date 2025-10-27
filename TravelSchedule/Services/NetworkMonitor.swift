//
//  NetworkMonitor.swift
//  TravelSchedule
//
//  Created by Ди Di on 08/09/25.
//

import Network
import Combine
import SwiftUI


@Observable
final class NetworkMonitor {
    private var monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    var isConnected: Bool = true
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    deinit {
        monitor.cancel()
    }
}
