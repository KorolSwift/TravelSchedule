//
//  CopyrightYandexSchedulesServices.swift
//  TravelSchedule
//
//  Created by Ди Di on 28/08/25.
//

import OpenAPIRuntime
import OpenAPIURLSession


typealias CopyrightYandexSchedules = Components.Schemas.CopyrightYaSchedules

protocol CopyrightYandexSchedulesServicesProtocol {
    func getCopyrightYandexSchedules(format: String) async throws -> CopyrightYandexSchedules
}

final class CopyrightYandexSchedulesServices: CopyrightYandexSchedulesServicesProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getCopyrightYandexSchedules(format: String) async throws -> CopyrightYandexSchedules {
        let response = try await client.getCopyrightYandexSchedules(query: .init(
            apikey: apikey,
            format: format
        ))
        return try response.ok.body.json
    }
}
