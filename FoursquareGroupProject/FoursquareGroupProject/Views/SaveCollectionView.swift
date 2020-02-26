//
//  SaveCollectionView.swift
//  FoursquareGroupProject
//
//  Created by Melinda Diaz on 2/21/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit

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
     
    public lazy var mybackgroundColor: UIImageView = {
        var view = UIImageView()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.4736866355, blue: 0.4620078206, alpha: 1)
        view = UIImageView(image: UIImage(named: "Food"))
        view.alpha = 0.4
        return view
    }()
   
    public lazy var createFoodCollection: UIAlertController = {
        let popUp = UIAlertController(title: "Create New Collection", message: nil, preferredStyle: .alert)
        popUp.addTextField { (textfield) in
            textfield.placeholder = "Create Collection Name"
        }
        popUp.addTextField { (textfield) in
            textfield.placeholder = "Description of Collection"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //TODO: create a function that create, and delete
        let create = UIAlertAction(title: "Create", style: .default, handler: nil)
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        popUp.addAction(create)
        popUp.addAction(cancel)
        return popUp
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
        setUpBackgroundConstraints()
        setUpCollectionViewConstraints()
    }

private func setUpCollectionViewConstraints() {
    addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
        collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
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

