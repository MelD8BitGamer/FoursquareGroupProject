//
//  FourSquareDetail.swift
//  FoursquareGroupProject
//
//  Created by Tsering Lama on 2/24/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import Foundation

struct DetailResults: Codable {
    let response: Response2
}

struct Response2: Codable {
    let venue: VenueDetail
}

struct VenueDetail: Codable {
    let location: Location2
    let hours: Hours
    let name: String
    let contact: Contact
    let price: Price
}

struct Contact: Codable {
    let formattedPhone: String
}

struct Location2: Codable {
    let formattedAddress: [String]
}

struct Price: Codable {
    let currency: String
}

struct Hours: Codable {
    let timeframes: [Timeframe]
}

struct Timeframe: Codable {
    let days: String
    let open: Open
}

struct Open: Codable {
    let renderedTime: String
}
