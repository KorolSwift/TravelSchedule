//
//  NetworkClient.swift
//  TravelSchedule
//
//  Created by Ди Di on 06/10/25.
//

import OpenAPIURLSession
import Foundation


actor NetworkClient {
    static let shared = NetworkClient()
    private let client: Client
    private let apikey: String
    
    init() {
        let url: URL
        do {
            url = try Servers.Server1.url()
        } catch {
            print("Ошибка получения serverURL, используется дефолтный URL:", error)
            url = URL(string: "https://api.rasp.yandex.net")!
        }
        client = Client(
            serverURL: url,
            transport: URLSessionTransport()
        )
        apikey = ApiKeyProvider.shared.value
    }
    
    func fetchAvailableStationsList() async throws -> AvailableStationsList {
        let response = try await client.getAvailableStationsList(query: .init(apikey: apikey))
        let responseBody = try response.ok.body.html
        let fullData = try await Data(collecting: responseBody, upTo: 50 * 1024 * 1024)
        return try JSONDecoder().decode(AvailableStationsList.self, from: fullData)
    }
    
    func fetchCarrierInformation(code: String, system: String) async throws -> Components.Schemas.CarrierInfo {
        let response = try await client.getCarrierInformation(query: .init(
            apikey: apikey,
            code: code,
            system: system
        ))
        return try response.ok.body.json
    }
    
    func fetchScheduleBTWStations(from: String, to: String, date: String) async throws -> Components.Schemas.ScheduleBTWStations {
        let response = try await client.getScheduleBTWStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            date: date
        ))
        return try response.ok.body.json
    }
    
    func fetchStationsList(uid: String) async throws -> Components.Schemas.ListOfStations {
        let response = try await client.getStationsList(query: .init(
            apikey: apikey,
            uid: uid
        ))
        return try response.ok.body.json
    }
    
    func fetchAllStationsList() async throws -> Data {
        guard let url = URL(string: "https://api.rasp.yandex.net/v3.0/stations_list/?apikey=\(apikey)&format=json&lang=ru_RU") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
