//
//  SearchVCCell.swift
//  FoursquareGroupProject
//
//  Created by Melinda Diaz on 2/21/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit
import ImageKit

class SearchVCCell: UICollectionViewCell {
    
    var allItems = [Item]()
    
    public lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "turtoise")
        image.contentMode = .scaleToFill
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupCell()
    }
    
    private func setupCell() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func configreCell(venue: Venue) {
        FourSquareAPICLient.getPhotoInfo(id: venue.id) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let appError):
                    print("couldnt load photos: \(appError)")
                case .success(let items):
                    self?.allItems = items
                }
            }
            DispatchQueue.main.async {
                let prefix = self?.allItems.first?.prefix ?? ""
                let suffix = self?.allItems.first?.suffix ?? ""
                let photoURL = "\(prefix)original\(suffix)"
                self?.imageView.getImage(with: photoURL) { (result) in
                    switch result {
                    case .failure(_):
                        DispatchQueue.main.async {
                            self?.imageView.image = UIImage(systemName: "person.fill")
                        }
                    case .success(let photo):
                        DispatchQueue.main.async {
                            self?.imageView.image = photo
                        }
                    }
                }
            }
        }
     }
}
