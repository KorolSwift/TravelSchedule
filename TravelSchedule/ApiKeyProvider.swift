//
//  ApiKeyProvider.swift
//  TravelSchedule
//
//  Created by Ди Di on 04/09/25.
//

import Foundation


final class ApiKeyProvider {
    static let shared = ApiKeyProvider()
    let value: String = "ec6bb700-04b7-4330-911a-ed7b5bd146dd"
    private init() {}
}
