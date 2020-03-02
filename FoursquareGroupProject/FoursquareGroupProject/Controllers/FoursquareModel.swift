//
//  FoursquareModel.swift
//  FoursquareGroupProject
//
//  Created by Melinda Diaz on 2/21/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import Foundation

struct AllResults: Codable & Equatable {
    let response: Response
}

struct Response: Codable & Equatable {
    let venues: [Venue]
    let geocode: Geocode?
}

struct Geocode: Codable & Equatable {
    let feature: Feature
}

struct Feature: Codable & Equatable {
    let geometry: Geometry
}

struct Geometry: Codable & Equatable {
    let center: Center
    let bounds: Bounds?
}

struct Bounds: Codable & Equatable {
    let ne: Center
    let sw: Center
}

struct Center: Codable & Equatable {
    let lat : Double
    let lng: Double
}

struct Venue: Codable & Equatable {
    let id: String
    let name: String
    let location: Location
}

struct Location: Codable & Equatable {
    let lat: Double
    let lng: Double
    let formattedAddress: [String]
}
