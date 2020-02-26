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
        sb.backgroundColor = .systemBackground
        sb.placeholder = "Enter a city"
       return sb
    }()
    
    public lazy var spotSearch: UISearchBar = {
       let sb = UISearchBar()
        sb.backgroundColor = .systemBackground
        sb.placeholder = "Search for venue"
       return sb
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
        addSubview(spotSearch)
        spotSearch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spotSearch.topAnchor.constraint(equalTo: citySearch.bottomAnchor),
            spotSearch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            spotSearch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        ])
    }
    
}
