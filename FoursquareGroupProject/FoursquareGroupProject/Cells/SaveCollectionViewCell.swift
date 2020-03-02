//
//  SaveCollectionViewCell.swift
//  FoursquareGroupProject
//
//  Created by Tsering Lama on 2/28/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit
import ImageKit
import DataPersistence

protocol CollectionCellDelegate: AnyObject {
  func didSelectMoreButton(_ favoritesCell: CollectionViewCell, cell: Collection )
}

class CollectionViewCell: UICollectionViewCell {
    
    weak var delegate: CollectionCellDelegate?
    private var currentCollection: Collection!
    
    public lazy var restaurantImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "folder.fill")
        image.layer.cornerRadius = 15
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    public lazy var moreButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemPink
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .black, scale: .large)
        button.setImage(UIImage(systemName: "ellipsis", withConfiguration: imageConfig), for: .normal)
        button.addTarget(self, action: #selector(moreButtonPressed(_:)), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    public lazy var headLabel : UILabel = {
        let label = UILabel()
        label.text = "This is a Title"
        label.numberOfLines = 1
        label.textAlignment = .center
        label.layer.cornerRadius = 20
        //label.backgroundColor = .systemGroupedBackground
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        return label
    }()
    
    public lazy var descriptLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        label.text = "There are THIS many on our list"
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        dropShadow(radius: 15, offsetX: 0, offsetY: 5, color: .gray)
    }
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setUpImageViewConstraints()
        setupMoreButtonConstraints()
        layoutSubviews()
        setUpHeadLabelConstraints()
//        setUpDescriptLabelConstraints()
    }
    
    @objc private func moreButtonPressed(_ sender: UIButton) {
       delegate?.didSelectMoreButton(self, cell: currentCollection)
    }
    
    func configCell(_ collection: Collection) {
        currentCollection = collection
        headLabel.text = collection.name
        descriptLabel.text = collection.description
    }
    
    private func setUpImageViewConstraints() {
        addSubview(restaurantImage)
        restaurantImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            restaurantImage.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            restaurantImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            restaurantImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            restaurantImage.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupMoreButtonConstraints() {
        addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            moreButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    private func setUpHeadLabelConstraints() {
        addSubview(headLabel)
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headLabel.topAnchor.constraint(equalTo: restaurantImage.bottomAnchor, constant: 10),
            headLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            headLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }
    
    private func setUpDescriptLabelConstraints() {
        addSubview(descriptLabel)
        descriptLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptLabel.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 2),
            descriptLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            descriptLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            descriptLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
}
extension UIView {
    func dropShadow(radius: CGFloat, offsetX: CGFloat, offsetY: CGFloat, color: UIColor) {
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        layer.shadowOpacity = 1 // setting this property to 1 makes full relation on color's opacity
        layer.shadowColor = color.cgColor
    }
}

