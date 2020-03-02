//
//  SaveView.swift
//  FoursquareGroupProject
//
//  Created by Tsering Lama on 2/28/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit
import DataPersistence

class SaveView: UIView {
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 600, height: 600)
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.backgroundView?.alpha = 0.3
        return cv
    }()
    
    public lazy var createListButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addDatabase"), for: .normal)
        // button.addTarget(self, action: #selector(createFoodButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    public lazy var mybackgroundColor: UIImageView = {
        var view = UIImageView()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.4736866355, blue: 0.4620078206, alpha: 1)
        view = UIImageView(image: UIImage(named: "food"))
        view.alpha = 0.4
        return view
    }()
    
//    public lazy var editFoodCollection: UIAlertController = {
//        let popUp = UIAlertController(title: "Create New Collection", message: nil, preferredStyle: .alert)
//        popUp.addTextField { (textfield) in
//            textfield.placeholder = "Create Collection Name"
//        }
//        popUp.addTextField { (textfield) in
//            textfield.placeholder = "Description of Collection"
//        }
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        //TODO: create a function that create, and delete
//        let create = UIAlertAction(title: "Create", style: .default, handler: nil)
//        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
//        popUp.addAction(create)
//        popUp.addAction(cancel)
//        return popUp
//    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setUpBackgroundConstraints()
        setUpCreateListButtonConstraints()
        setUpCollectionViewConstraints()
    }
    
    private func setUpCollectionViewConstraints() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        ])
    }
    
    private func setUpCreateListButtonConstraints() {
        addSubview(createListButton)
        createListButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createListButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            createListButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            createListButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 300)
        ])
    }
    private func setUpBackgroundConstraints() {
        addSubview(mybackgroundColor)
        mybackgroundColor.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mybackgroundColor.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            mybackgroundColor.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            mybackgroundColor.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            mybackgroundColor.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}

