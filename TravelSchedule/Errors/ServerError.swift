//
//  ServerError.swift
//  TravelSchedule
//
//  Created by Ди Di on 12/09/25.
//

import Foundation


extension Notification.Name {
    static let serverErrorOccurred = Notification.Name("ServerErrorOccurred")
    static let serverErrorCleared  = Notification.Name("ServerErrorCleared")
}

func showServerError(_ message: String? = nil) {
    NotificationCenter.default.post(
        name: .serverErrorOccurred,
        object: nil,
        userInfo: ["message": message ?? ""]
    )
}

func hideServerError() {
    NotificationCenter.default.post(name: .serverErrorCleared, object: nil)
}
