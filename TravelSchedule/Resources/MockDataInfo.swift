//
//  MockDataInfo.swift
//  TravelSchedule
//
//  Created by Ди Di on 23/09/25.
//

import Foundation


struct MockDataInfo {
    static func loadCarrierInfo() -> CarrierInfo {
        guard let url = Bundle.main.url(forResource: "carrier", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(CarrierInfo.self, from: data) else {
            fatalError("Не удалось загрузить carrier.json")
        }
        return decoded
    }
}
