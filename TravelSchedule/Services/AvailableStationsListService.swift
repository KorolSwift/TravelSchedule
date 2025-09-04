//
//  AvailableStationsListService.swift
//  TravelSchedule
//
//  Created by Ди Di on 28/08/25.
//

import OpenAPIRuntime
import OpenAPIURLSession
import Foundation



typealias AvailableStationsList = Components.Schemas.AvailableStations

protocol AvailableStationsListServicesProtocol {
    func getAvailableStationsList() async throws -> AvailableStationsList
}

final class AvailableStationsListServices: AvailableStationsListServicesProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getAvailableStationsList() async throws -> AvailableStationsList {
        let response = try await client.getAvailableStationsList(query: .init(apikey: apikey))
        
        let responseBody = try response.ok.body.html
        
        let limit = 50 * 1024 * 1024
        let fullData = try await Data(collecting: responseBody, upTo: limit)
        
        let stationsList = try JSONDecoder().decode(AvailableStationsList.self, from: fullData)
        return stationsList
    }
}



