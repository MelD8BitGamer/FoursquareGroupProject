//
//  CreateNewView.swift
//  FoursquareGroupProject
//
//  Created by Tsering Lama on 2/28/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit
import DataPersistence

class CreateNewView: UIView {
    
  //because I am creating an array of collections and I want to add the array to the matrix in the SaveVC
    public var dataPersistence: DataPersistence<[Collection]>!
    
    
    public lazy var createView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.layer.cornerRadius = 9
        return view
    }()
    
    public lazy var nameOfCollectionTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name of Collection: Ex:Coffee"
        textField.layer.cornerRadius = 7
        textField.textAlignment = .center
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "Name of Collection: Ex:Coffee", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        textField.font = UIFont.preferredFont(forTextStyle: .headline)
        textField.placeholder = "Name of Collection: (ex: Coffee, Pizza)"
        textField.layer.cornerRadius = 7
        textField.textAlignment = .center
        textField.backgroundColor = .white
        return textField
    }()
    public lazy var descriptionTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Description Ex: Where I go for coffee "
        textField.font = UIFont.preferredFont(forTextStyle: .headline)
        textField.placeholder = "Description: (ex: Where I go for coffee)"
        textField.layer.cornerRadius = 7
        textField.textColor = .black
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(string: "Description Ex: Where I go for coffee", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        textField.backgroundColor = .white
        return textField
    }()
    public lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create", for: .normal)
        button.layer.cornerRadius = 9
        button.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
       // button.addTarget(self, action: #selector(createButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    public lazy var mybackgroundColor: UIImageView = {
        var view = UIImageView()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.4736866355, blue: 0.4620078206, alpha: 1)
        view = UIImageView(image: UIImage(named: "food"))
        view.alpha = 0.4
        return view
    }()
    
   // let visualEffectsView = UIVisualEffectView(effect: nil)
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        commonInit()
    }
   
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
       
        setUpViewConstraints()
        setUpNameOfCollectionTFConstraints()
        setUpDescriptionTFConstraints()
        setUpCreateButtonConstraints()
        //setUpBackgroundConstraints()
        // blurEffect()
        
    }
    
  //fileprivate func blurEffect() {
  //  addSubview(visualEffectsView)
  //  visualEffectsView.frame = frame
  //}
   
    private func setUpViewConstraints() {
        addSubview(createView)
        createView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            createView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 4),
            createView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            createView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    private func setUpNameOfCollectionTFConstraints() {
        createView.addSubview(nameOfCollectionTF)
        nameOfCollectionTF.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameOfCollectionTF.topAnchor.constraint(equalTo: createView.topAnchor, constant: 8),
            nameOfCollectionTF.heightAnchor.constraint(equalToConstant: 25),
            nameOfCollectionTF.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameOfCollectionTF.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    private func setUpDescriptionTFConstraints() {
        addSubview(descriptionTF)
        descriptionTF.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionTF.topAnchor.constraint(equalTo: nameOfCollectionTF.bottomAnchor, constant: 10),
            descriptionTF.heightAnchor.constraint(equalToConstant: 25),
            descriptionTF.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionTF.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    private func setUpCreateButtonConstraints() {
        addSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: descriptionTF.bottomAnchor, constant: 40),
            createButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
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


