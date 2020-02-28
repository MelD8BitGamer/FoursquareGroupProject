//
//  DetailViewController.swift
//  FoursquareGroupProject
//
//  Created by Tsering Lama on 2/26/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit
import DataPersistence
class DetailViewController: UIViewController {
    
    private var detailView = detail()
    
    private var dataPersistence: DataPersistence<Collection>
    
    private var venue: Venue
        
    init(_ dataPersistence: DataPersistence<Collection>, venue: Venue) {
        self.dataPersistence = dataPersistence
        self.venue = venue
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        getDetails()
    }
    
    private func getDetails() {
        FourSquareAPICLient.getDetails(id: venue.id) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                print("couldnt get details: \(appError)")
            case .success(let detail):
                DispatchQueue.main.async {
                    let venueName = detail.name
                    self?.detailView.venueName.text = venueName
                    let timeFrame = detail.hours?.timeframes?.first?.open?.first?.renderedTime
                    self?.detailView.hours.text = timeFrame
                    let currency = detail.price?.currency
                    self?.detailView.priceRange.text = "Cost: \(currency ?? "N/A")"
                    let address = detail.location?.formattedAddress?.joined(separator: "")
                    self?.detailView.venueAdress.text = address
                    let days = detail.hours?.timeframes?.first?.days
                    self?.detailView.days.text = days
                    let phoneNumber = detail.contact?.formattedPhone
                    self?.detailView.rating.text = phoneNumber
                    
                    let prefix = detail.bestPhoto?.prefix ?? ""
                    let suffix = detail.bestPhoto?.suffix ?? ""
                    let photoURL = "\(prefix)original\(suffix)"
                    
                    self?.detailView.imageView.getImage(with: photoURL) { (result) in
                        switch result {
                        case .failure(_):
                            print("no detail image")
                        case .success(let image):
                            DispatchQueue.main.async {
                                self?.detailView.imageView.image = image
                            }
                        }
                    }
                }
            }
        }
    }
}
