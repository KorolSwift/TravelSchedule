//
//  StationsListService.swift
//  TravelSchedule
//
//  Created by Ди Di on 27/08/25.
//

import OpenAPIRuntime
import OpenAPIURLSession


typealias StationsList = Components.Schemas.ListOfStations

protocol StationsListProtocol {
    func getStationsList(uid: String) async throws -> StationsList
}

class StationsListServices: StationsListProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getStationsList(uid: String) async throws -> StationsList {
        let response = try await client.getStationsList(query: .init(
            apikey: apikey,
            uid: uid
        ))
        return try response.ok.body.json
    }
}
