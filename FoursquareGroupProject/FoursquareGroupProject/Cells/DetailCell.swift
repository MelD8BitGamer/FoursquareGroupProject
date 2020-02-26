//
//  DetailCell.swift
//  FoursquareGroupProject
//
//  Created by Tsering Lama on 2/26/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import Foundation
import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    public lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "turtoise")
        image.contentMode = .scaleAspectFill
        return image
    }()
}

