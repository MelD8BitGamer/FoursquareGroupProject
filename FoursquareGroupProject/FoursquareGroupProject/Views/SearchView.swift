//
//  SearchView.swift
//  FoursquareGroupProject
//
//  Created by Melinda Diaz on 2/21/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit


class SearchView: UIView {
    
    public lazy var citySearch: UISearchBar = {
       let sb = UISearchBar()
        sb.backgroundImage = UIImage()
        sb.backgroundColor = .systemBackground
        sb.layer.cornerRadius = 9 
        sb.placeholder = "Search for venue"
       return sb
    }()
    
    public lazy var venueSearchTextField: UITextField = {
       let tf = UITextField()
        tf.backgroundColor = .systemBackground
        tf.placeholder = "  Search for city"
        tf.layer.cornerRadius = 9
       return tf
    }()
    
    public lazy var photoCV: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: frame.width / 3, height: frame.height / 10)
       let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
       cv.backgroundColor = .clear
       return cv
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
        setupSearch1()
        setupSearch2()
        setupCV()
    }
    
    private func setupSearch1() {
        addSubview(citySearch)
        citySearch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            citySearch.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            citySearch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            citySearch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        ])
    }
    
    private func setupSearch2() {
        addSubview(venueSearchTextField)
        venueSearchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            venueSearchTextField.topAnchor.constraint(equalTo: citySearch.bottomAnchor, constant: 5),
            venueSearchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            venueSearchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            venueSearchTextField.heightAnchor.constraint(equalTo: citySearch.heightAnchor, multiplier: 0.70)
        ])
    }
    
    private func setupCV() {
        addSubview(photoCV)
        photoCV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCV.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoCV.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoCV.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -60),
            photoCV.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.10)
        ])
    }
    
}
