//
//  ScheduleByStationsServices.swift
//  TravelSchedule
//
//  Created by Ди Di on 27/08/25.
//

import OpenAPIRuntime
import OpenAPIURLSession


typealias ScheduleByStations = Components.Schemas.ScheduleByStations

protocol ScheduleByStationsProtocol {
    func getScheduleByStations(station: String) async throws -> ScheduleByStations
}

class ScheduleByStationsServices: ScheduleByStationsProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getScheduleByStations(station: String) async throws -> ScheduleByStations {
        let response = try await client.getScheduleByStations(query: .init(
            apikey: apikey,
            station: station
        ))
        return try response.ok.body.json
    }
}
