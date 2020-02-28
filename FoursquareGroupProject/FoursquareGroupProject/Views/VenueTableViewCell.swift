//
//  VenueTableViewCell.swift
//  FoursquareGroupProject
//
//  Created by Howard Chang on 2/26/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//
import UIKit

final class VenueTableViewCell: UITableViewCell {
    public lazy var venueImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.clipsToBounds = true
        imageV.layer.cornerRadius = 10
        imageV.contentMode = .scaleToFill
        imageV.image = UIImage(systemName: "person.fill")
        return imageV
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    lazy var venueAddress: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .boldSystemFont(ofSize: 15)
        descriptionLabel.textAlignment = .center
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func commonInit() {
        backgroundColor = .systemBackground
        venueImageViewConstraints()
        titleLabelConstraints()
        venueAddressLabelConstraints()
    }
    
    private func venueImageViewConstraints() {
        addSubview(venueImageView)
        venueImageView.translatesAutoresizingMaskIntoConstraints = false
        venueImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        venueImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        venueImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        venueImageView.widthAnchor.constraint(equalTo: venueImageView.heightAnchor, multiplier: 16/9).isActive = true
    }
    
    private func titleLabelConstraints() {
        addSubview(titleLabel)
//        titleLabel.anchor(top: topAnchor, left: venueImageView.rightAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 8)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: venueImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: venueImageView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 20)
        ])
    }
    
    private func venueAddressLabelConstraints() {
        addSubview(venueAddress)
//        venueAddress.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, right: titleLabel.rightAnchor, paddingTop: 8, paddingBottom: -8)
        venueAddress.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            venueAddress.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            venueAddress.leadingAnchor.constraint(equalTo: venueImageView.trailingAnchor, constant: 8),
            venueAddress.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 8)
        ])
    }
    
    func configureCell(venue: Venue) {
        titleLabel.text = venue.name
        venueAddress.text = venue.location.formattedAddress.joined(separator: "")
    }
}
