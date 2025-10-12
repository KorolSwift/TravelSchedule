//
//  Search.swift
//  TravelSchedule
//
//  Created by Ди Di on 08/09/25.
//

import Foundation


struct Search: Decodable, Hashable, Sendable  {
    let segments: [Segment]
}

struct Segment: Decodable, Identifiable, Hashable, Sendable  {
    let thread: Thread
    let start_date: Date?
    let departure: Date?
    let arrival: Date?
    let duration: Double
    let has_transfers: Bool
    
    var id: String {
        "\(thread.uid)_\(departure?.timeIntervalSince1970 ?? 0)"
    }
}

struct Thread: Decodable, Hashable, Sendable  {
    let uid: String
    let carrier: Carrier
}

struct Carrier: Decodable, Hashable, Sendable {
    let title: String
    let code: Int?
    let codes: CarrierCodes?
    let logo: String?
    let logo_svg: String?
    
    struct CarrierCodes: Decodable, Hashable, Sendable {
        let iata: String?
        let sirena: String?
        let icao: String?
    }
}

enum Nav: Hashable {
    case carriers
    case filtration
    case segment(Segment)
    
    case citiesFrom
    case citiesTo
    case stations(city: String, isFrom: Bool)
}

enum FilterTimeRange {
    static let morning = "Утро 06:00 - 12:00"
    static let day = "День 12:00 - 18:00"
    static let evening = "Вечер 18:00 - 00:00"
    static let night = "Ночь 00:00 - 06:00"
    static let allOptions = [morning, day, evening, night]
}

struct StationItem: Hashable, Identifiable {
    let code: String
    let title: String
    var id: String { code }
}

struct AvailableStationsResponse: Decodable, Sendable {
    let countries: [Country]?
}

struct Country: Decodable, Sendable {
    let title: String?
    let regions: [Region]?
}

struct Region: Decodable, Sendable {
    let title: String?
    let settlements: [Settlement]?
}

struct Settlement: Decodable, Sendable {
    let title: String?
    let codes: SettlementCodes?
    let stations: [Station]?
}

struct SettlementCodes: Decodable, Sendable {
    let yandex_code: String?
    let esr_code: String?
}

struct Station: Decodable, Sendable {
    let title: String?
    let codes: StationCodes?
}

struct StationCodes: Decodable, Sendable {
    let yandex_code: String?
    let esr_code: String?
}
