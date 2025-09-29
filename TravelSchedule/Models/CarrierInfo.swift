//
//  CarrierInfo.swift
//  TravelSchedule
//
//  Created by Ди Di on 22/09/25.
//


struct CarrierInfo: Decodable, Hashable {
    let carrier: CarrierDetails
}

struct CarrierDetails: Decodable, Hashable {
    let code: Int
    let logo: String?
    let title: String
    let email: String?
    let phone: String?
}
