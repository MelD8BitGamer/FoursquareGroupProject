//
//  FoursquareModel.swift
//  FoursquareGroupProject
//
//  Created by Melinda Diaz on 2/21/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import Foundation

struct AllResults: Codable {
    let response: Response
}

struct Response: Codable {
    let venues: [Venue]
    let geocode: Geocode?
}

struct Geocode: Codable {
    let feature: Feature
}

struct Feature: Codable {
    let geometry: Geometry
}

struct Geometry: Codable {
    let center: Center
    let bounds: Bounds?
}

struct Bounds: Codable {
    let ne: Center
    let sw: Center
}

struct Center: Codable {
    let lat : Double
    let lng: Double
}

struct Venue: Codable {
    let id: String
    let name: String
    let location: Location
}

struct Location: Codable {
    let lat: Double
    let lng: Double
    let formattedAddress: [String]
}
