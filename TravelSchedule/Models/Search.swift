//
//  Search.swift
//  TravelSchedule
//
//  Created by Ди Di on 08/09/25.
//


struct Search: Decodable, Hashable  {
    let segments: [Segment]
}

struct Segment: Decodable, Identifiable, Hashable  {
    let thread: Thread
    let start_date: String
    let departure: String
    let arrival: String
    let duration: Double
    let has_transfers: Bool
    
    var id: String { "\(thread.uid)_\(departure)" }
}

struct Thread: Decodable, Hashable  {
    let uid: String
    let carrier: Carrier
}

struct Carrier: Decodable, Hashable  {
    let title: String
}

enum Nav: Hashable {
    case carriers
    case filtration
    case segment(Segment)
    
    case citiesFrom
    case citiesTo
    case stations(city: String, isFrom: Bool)
}
