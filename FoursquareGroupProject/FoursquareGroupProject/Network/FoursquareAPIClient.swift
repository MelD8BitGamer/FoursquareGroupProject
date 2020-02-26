//
//  FoursquareAPIClient.swift
//  FoursquareGroupProject
//
//  Created by Melinda Diaz on 2/21/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import Foundation
import NetworkHelper

struct FourSquareAPICLient {
    static func getResults(city: String, spot: String, completion: @escaping (Result<[Venue], AppError>) -> ()) {
        
        let endpointURL = "https://api.foursquare.com/v2/venues/search?client_id=\(SecretKey.clientID)&client_secret=\(SecretKey.clientSecret)&v=20210102&near=\(city)&intent=browse&radius=100&query=\(spot)&limit=10"
        
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let dataSearch = try JSONDecoder().decode(AllResults.self, from: data)
                    let venuesSearch = dataSearch.response.venues
                    completion(.success(venuesSearch))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    static func getDetails(id: String, completion: @escaping(Result<VenueDetail, AppError>) -> ()) {
        
        let endpointURL = "https://api.foursquare.com/v2/venues/\(id)?&client_id=\(SecretKey.clientID)&client_secret=\(SecretKey.clientSecret)&v=20210102"
        
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let detailSearch = try JSONDecoder().decode(DetailResults.self, from: data)
                    let venueDetail = detailSearch.response.venue
                    completion(.success(venueDetail))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
