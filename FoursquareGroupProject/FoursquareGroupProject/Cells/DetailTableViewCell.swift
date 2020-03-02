//
//  DetailTableViewCell.swift
//  FoursquareGroupProject
//
//  Created by Tsering Lama on 2/28/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    public lazy var venueNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "test"
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    public lazy var venueAddressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "address"
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      commonInit()
    }
     
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        venueNameLabelConstraints()
        venueAddressLabelConstraints()
        backgroundColor = .systemBackground
    }
    
    private func venueNameLabelConstraints() {
        addSubview(venueNameLabel)
        //        titleLabel.anchor(top: topAnchor, left: venueImageView.rightAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 8)
        venueNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            venueNameLabel.topAnchor.constraint(equalTo:topAnchor),
            venueNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            venueNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func venueAddressLabelConstraints() {
        addSubview(venueAddressLabel)
        //        venueAddress.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, right: titleLabel.rightAnchor, paddingTop: 8, paddingBottom: -8)
        venueAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            venueAddressLabel.topAnchor.constraint(equalTo: venueNameLabel.bottomAnchor, constant: 1),
            venueAddressLabel.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 8),
            venueAddressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
        
}
    
    func configureCell(venue: Venue) {
        venueNameLabel.text = venue.name
        venueAddressLabel.text = venue.location.formattedAddress.joined(separator: "")
    }
}
