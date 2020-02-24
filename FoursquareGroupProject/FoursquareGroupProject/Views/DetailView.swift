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
        return label
    }()
    
    public lazy var priceRange: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public lazy var venueAdress: UILabel = {
        let label = UILabel()
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
        // create safari hyperlink to venue website.
        return label
    }()
    
    public lazy var menuButton: UIButton = {
        let button = UIButton()
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
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
    }
    
    private func setUpScrollView() {
        
    }
    
    private func setupCollectionView() {
        
    }
    
    private func setupVenueName() {
        
    }
    
    private func setupPriceRange() {
        
    }
    
    private func setupVenueAddress() {
        
    }
    
    private func setupRating() {
        
    }
}
