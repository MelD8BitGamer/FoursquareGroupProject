//
//  FourSquareImage.swift
//  FoursquareGroupProject
//
//  Created by Tsering Lama on 2/24/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import Foundation

struct APhoto: Codable {
    let response: PhotosData
}

struct PhotosData: Codable {
    let photos: Photos
}

struct Photos: Codable {
    let items: [Item]
}

struct Item: Codable {
    let prefix: String
    let suffix: String
    let width: Int 
}
