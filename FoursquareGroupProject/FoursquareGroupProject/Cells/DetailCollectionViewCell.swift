//
//  DetailCollectionViewCell.swift
//  FoursquareGroupProject
//
//  Created by Brendon Cecilio on 2/24/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    public lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "turtoise")
        image.contentMode = .scaleAspectFill
        return image
    }()
}
