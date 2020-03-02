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
    
    public var allCollections = [Collection]() {
        didSet {
            detailView.collectionView.reloadData()
        }
    }
    
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
        detailView.collectionView.dataSource = self
        detailView.collectionView.delegate = self
        detailView.collectionView.register(AddCell.self, forCellWithReuseIdentifier: "addCell")
        getDetails()
        getFavCollection()
        detailView.saveButton.addTarget(self, action: #selector(saveVenue), for: .touchUpInside)
    }
    
    private func getFavCollection() {
        do {
            allCollections = try dataPersistence.loadItems()
        } catch {
            print("error while loading collections")
        }
    }
    
    @objc private func saveVenue() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.detailView.popUpView.transform = CGAffineTransform(translationX: 0, y: -900)
        }, completion: nil)
        
    }
    
//    private func addVenue(collection: Collection) {
//        guard let index = allCollections.firstIndex(of: collection) else {
//            return
//        }
//        let newVenue = Collection(name: venue.name, description: venue.id, venue: [])
//        do {
//            try dataPersistence.update(newVenue, at: index)
//        } catch {
//            print("couldnt save")
//        }
//    }
    
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
                    
                    self?.detailView.imageView.getImage(with: photoURL, writeTo: .cachesDirectory) { (result) in
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

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as? AddCell else {
            fatalError()
        }
        let aCollection = allCollections[indexPath.row]
        cell.collectionLabel.text = aCollection.name
        cell.backgroundColor = .systemBlue
        return cell
    }
    
    
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.6
        let itemHeight: CGFloat = maxSize.height * 0.2
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selected = allCollections[indexPath.row]
        selected.venue.append(venue)
        try dataPersistence.update(selected, at: indexPath.row)
}
    
}
