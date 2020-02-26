//
//  DetailView.swift
//  FoursquareGroupProject
//
//  Created by Brendon Cecilio on 2/24/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit

class DetailView: UIView {

    public lazy var scrollView: UIScrollView = {
        let SCV = UIScrollView()
        return SCV
    }()
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemGroupedBackground
        return collection
    }()
    
    public lazy var venueName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        return label
    }()
    
    public lazy var priceRange: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public lazy var venueAdress: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        return label
    }()
    
    public lazy var hours: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        return label
    }()
    
    public lazy var rating: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public lazy var directionsButton: UIButton = {
        let button = UIButton()
        // segue to mapViewController
        return button
    }()
    
    public lazy var hyperlink: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        // create safari hyperlink to venue website.
        return label
    }()
    
    public lazy var menuButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(animateButtons), for: .touchUpInside)
        return button
    }()
    
    public lazy var saveButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    public lazy var shareButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    public lazy var rateButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let visualEffectView = UIVisualEffectView(effect: nil)
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        blurEffect()
        setUpScrollView()
        setupCollectionView()
        setupVenueName()
        setupPriceRange()
        setupVenueAddress()
        setupRating()
    }
    
    fileprivate func blurEffect() {
        addSubview(visualEffectView)
        visualEffectView.frame = frame
    }
    
    private func setUpScrollView() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3.5)
        ])
    }
    
    private func setupVenueName() {
        addSubview(venueName)
        venueName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            venueName.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            venueName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    private func setupPriceRange() {
        addSubview(priceRange)
        priceRange.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceRange.leadingAnchor.constraint(equalTo: venueName.trailingAnchor, constant: 8),
            priceRange.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
        ])
    }
    
    private func setupVenueAddress() {
        addSubview(venueAdress)
        venueAdress.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            venueAdress.topAnchor.constraint(equalTo: venueName.bottomAnchor, constant: 20),
            venueAdress.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    private func setupRating() {
        addSubview(rating)
        rating.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rating.topAnchor.constraint(equalTo: venueAdress.bottomAnchor, constant: 20),
            rating.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    @objc private func animateButtons() {
        
    }
}
