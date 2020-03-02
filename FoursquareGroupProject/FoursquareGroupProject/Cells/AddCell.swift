//
//  AddCell.swift
//  FoursquareGroupProject
//
//  Created by Tsering Lama on 3/1/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit

class AddCell: UICollectionViewCell {
    
    public lazy var collectionLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .systemGray
       return label
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
        setUpLabel()
    }
    
    private func setUpLabel() {
        addSubview(collectionLabel)
        collectionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            collectionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
        
}
