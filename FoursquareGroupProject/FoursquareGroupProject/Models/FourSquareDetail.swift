//
//  FourSquareDetail.swift
//  FoursquareGroupProject
//
//  Created by Tsering Lama on 2/24/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import Foundation

struct DetailResults: Codable & Equatable {
    let response: Response2
}

struct Response2: Codable & Equatable {
    let venue: VenueDetail
}

struct VenueDetail: Codable & Equatable {
    let location: Location2?
    let hours: Hours?
    let name: String?
    let contact: Contact?
    let price: Price?
}

struct Contact: Codable & Equatable {
    let formattedPhone: String?
}

struct Location2: Codable & Equatable {
    let formattedAddress: [String]?
}

struct Price: Codable & Equatable {
    let currency: String?
}

struct Hours: Codable & Equatable {
    let timeframes: [Timeframe]?
}

struct Timeframe: Codable & Equatable {
    let days: String?
    let open: [Open]?
}

struct Open: Codable & Equatable {
    let renderedTime: String?
}
