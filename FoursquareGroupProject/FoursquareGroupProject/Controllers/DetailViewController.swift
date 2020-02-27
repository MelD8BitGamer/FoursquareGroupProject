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
    
    private var venue: Venue!
        
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
        detailView.collectionView.register(detailCell.self, forCellWithReuseIdentifier: "detailCell")
        getDetails()
    }
    
    private func getDetails() {
        FourSquareAPICLient.getDetails(id: venue.id) { [weak self](result) in
            switch result {
            case .failure(let appError):
                print("couldnt get details: \(appError)")
            case .success(let detail):
                DispatchQueue.main.async {
                    self?.detailView.priceRange.text = detail.name
                    self?.detailView.hours.text = detail.hours?.timeframes?.description
                    self?.detailView.priceRange.text = detail.price?.currency
                    self?.detailView.hyperlink.text = detail.location?.formattedAddress?.description
                    print(detail.name)
//                    self?.detailView.hours.text =
//                    print("\(detail.hours.timeframes.description)")
                }
            }
        }
    }
}
