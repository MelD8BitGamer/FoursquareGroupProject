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
    static func getResults(city: String, venue: String, completion: @escaping (Result<[Venue], AppError>) -> ()) {
        
        let queryCity = city.lowercased().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let queryVenue = venue.lowercased().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let endpointURL = "https://api.foursquare.com/v2/venues/search?client_id=\(SecretKey.clientID)&client_secret=\(SecretKey.clientSecret)&v=20210102&near=\(queryCity)&intent=browse&radius=1000&query=\(queryVenue)&limit=10"
        
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request, maxCacheDays: 2) { (result) in
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
    
    static func getPhotoInfo(id: String, completion: @escaping (Result<[Item], AppError>) -> ()) {
        
        let endpointURL = "https://api.foursquare.com/v2/venues/\(id)/photos?&client_id=\(SecretKey.clientID)&client_secret=\(SecretKey.clientSecret)&v=20210102"
        
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request, maxCacheDays: 2) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let allPhoto = try JSONDecoder().decode(APhoto.self, from: data)
                    completion(.success(allPhoto.response.photos.items))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    static func getDetails(id: String, completion: @escaping(Result<VenueDetail, AppError>) -> ()) {
        
        let endpointURL = "https://api.foursquare.com/v2/venues/\(id)?client_id=\(SecretKey.clientID)&client_secret=\(SecretKey.clientSecret)&v=20210102"
                
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request, maxCacheDays: 2) { (result) in
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
