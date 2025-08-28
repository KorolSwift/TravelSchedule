//
//  ScheduleBTWStationsService.swift
//  TravelSchedule
//
//  Created by Ди Di on 27/08/25.
//

import OpenAPIRuntime
import OpenAPIURLSession


typealias ScheduleBTWStations = Components.Schemas.ScheduleBTWStations

protocol ScheduleBTWStationsServiceProtocol {
    func getScheduleBTWStations(from: String, to: String, date: String) async throws -> ScheduleBTWStations
}

final class ScheduleBTWStationsService: ScheduleBTWStationsServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getScheduleBTWStations(from: String, to: String, date: String) async throws -> ScheduleBTWStations {
        let response = try await client.getScheduleBTWStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            date: date
        ))
        return try response.ok.body.json
    }
}
