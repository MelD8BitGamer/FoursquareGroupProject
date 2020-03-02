//
//  SearchView.swift
//  FoursquareGroupProject
//
//  Created by Melinda Diaz on 2/21/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit
import Mapbox
import MapboxNavigation

final class SearchView: UIView {
    
    let url = URL(string: "mapbox://styles/howc/ck5gy6ex70k441iw1gqtnehf5")
    
    public lazy var mapView: NavigationMapView = {
        let map = NavigationMapView(frame: bounds, styleURL: url)
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        map.showsUserLocation = true
        map.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        return map
    }()
    
    public lazy var venueSearch: UISearchBar = {
        let sb = UISearchBar()
        sb.backgroundImage = UIImage()
        sb.backgroundColor = .clear
        sb.searchTextField.backgroundColor = .systemBackground
        sb.searchTextField.layer.cornerRadius = 15
        sb.searchTextField.layer.masksToBounds = true
        sb.tintColor = .red
        sb.searchBarStyle = .minimal
        sb.layer.cornerRadius = 20
        sb.layer.masksToBounds = true
        sb.placeholder = "Search for venue"
        sb.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return sb
    }()
    
    public lazy var citySearch: UITextField = {
        let tf = UITextField()
        tf.setLeftPadding(10)
        tf.setRightPadding(10)
        tf.layer.masksToBounds = true
        tf.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tf.font = UIFont(name: "AvenirNext-Regular", size: 15)
        tf.layer.cornerRadius = 15
        tf.backgroundColor = .systemBackground
        tf.placeholder = "  Search for city"
        return tf
    }()
    
    public lazy var photoCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: frame.width / 3, height: frame.height / 10)
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    public lazy var navigateVC: UIButton = {
        let navigateButton = UIButton(frame: CGRect(x: 350, y: 440, width: 50, height: 50))
        navigateButton.setTitle("GO", for: .normal)
        navigateButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        navigateButton.layer.cornerRadius = 25
        navigateButton.layer.masksToBounds = true
        navigateButton.setTitleColor(UIColor.black, for: .normal)
        navigateButton.backgroundColor = .green
        navigateButton.layer.shadowColor = UIColor.lightGray.cgColor
        navigateButton.layer.shadowPath = UIBezierPath(roundedRect: navigateButton.bounds, cornerRadius: 25).cgPath
        navigateButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        navigateButton.layer.shadowOpacity = 0.7
        navigateButton.layer.shadowRadius = 5
        navigateButton.layer.cornerRadius = 25
        navigateButton.layer.borderColor = UIColor.clear.cgColor
        navigateButton.layer.borderWidth = 1.5
        navigateButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        navigateButton.layer.masksToBounds = true
        navigateButton.clipsToBounds = false
        navigateButton.isHidden = true
        return navigateButton
    }()
    
    public lazy var zoomToUser: UIButton = {
        let zoomToUserButton = UIButton(frame: CGRect(x: 350, y: 520, width: 50, height: 50))
        zoomToUserButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        zoomToUserButton.layer.cornerRadius = 25
        zoomToUserButton.layer.masksToBounds = false
        zoomToUserButton.tintColor = .blue
        zoomToUserButton.backgroundColor = .white
        zoomToUserButton.layer.shadowColor = UIColor.lightGray.cgColor
        zoomToUserButton.layer.shadowPath = UIBezierPath(roundedRect: zoomToUserButton.bounds, cornerRadius: 25).cgPath
        zoomToUserButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        zoomToUserButton.layer.shadowOpacity = 0.7
        zoomToUserButton.layer.shadowRadius = 5
        zoomToUserButton.layer.cornerRadius = 25
        zoomToUserButton.layer.borderColor = UIColor.clear.cgColor
        zoomToUserButton.layer.borderWidth = 1.5
        //zoomToUserButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        zoomToUserButton.layer.masksToBounds = true
        zoomToUserButton.clipsToBounds = false
        return zoomToUserButton
    }()
    
    public lazy var changeMapButton: UIButton = {
        let changeMapStyleButton = UIButton(frame: CGRect(x: 350, y: 590, width: 50, height: 50))
        changeMapStyleButton.setBackgroundImage(UIImage(named: "changeMap"), for: .normal)
        changeMapStyleButton.layer.cornerRadius = 15
        changeMapStyleButton.layer.masksToBounds = false
        changeMapStyleButton.tintColor = .black
        changeMapStyleButton.backgroundColor = .green
        changeMapStyleButton.layer.shadowColor = UIColor.lightGray.cgColor
        changeMapStyleButton.layer.shadowPath = UIBezierPath(roundedRect: changeMapStyleButton.bounds, cornerRadius: 15).cgPath
        changeMapStyleButton.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        changeMapStyleButton.layer.shadowOpacity = 0.7
        changeMapStyleButton.layer.shadowRadius = 5
        changeMapStyleButton.layer.cornerRadius = 15
        changeMapStyleButton.layer.borderColor = UIColor.clear.cgColor
        changeMapStyleButton.layer.borderWidth = 1.5
        //changeMapStyleButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        changeMapStyleButton.layer.masksToBounds = true
        changeMapStyleButton.clipsToBounds = false
        return changeMapStyleButton
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
        addSubview(mapView)
        setupSearch1()
        setupSearch2()
        setupCV()
        setupChangeMapButton()
        setupZoomToUser()
        setupNavigateVC()
    }
    
    private func setupSearch1() {
        addSubview(venueSearch)
        venueSearch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            venueSearch.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            venueSearch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            venueSearch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    private func setupSearch2() {
        addSubview(citySearch)
        citySearch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            citySearch.topAnchor.constraint(equalTo: venueSearch.bottomAnchor),
            citySearch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            citySearch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            citySearch.heightAnchor.constraint(equalTo: venueSearch.heightAnchor, multiplier: 0.70)
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
    
    private func setupNavigateVC() {
        addSubview(navigateVC)
        navigateVC.anchor(bottom: zoomToUser.topAnchor, right: zoomToUser.rightAnchor, paddingBottom: 15, width: 50, height: 50)
    }
    
    private func setupChangeMapButton() {
        addSubview(changeMapButton)
        changeMapButton.anchor(bottom: photoCV.topAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingBottom: 20, paddingRight: 20, width: 50, height: 50)
    }
    
    private func setupZoomToUser() {
        addSubview(zoomToUser)
        zoomToUser.anchor(bottom: changeMapButton.topAnchor, right: changeMapButton.rightAnchor, paddingBottom: 15, width: 50, height: 50)
    }
    
}
