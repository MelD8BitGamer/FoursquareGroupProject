//
//  EmptyView.swift
//  FoursquareGroupProject
//
//  Created by Tsering Lama on 2/26/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import Foundation
import UIKit

class EmptyView: UIView {
    
    // title and a messege
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Empty State"
        return label
        
    }()
    
    public lazy var messegeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 4
        label.textAlignment = .center
        label.text = "t"
        return label
    }()
    
    public lazy var createListButton: UIButton = {
           let button = UIButton()
           button.setImage(UIImage(named: "addDatabase"), for: .normal)
        button.backgroundColor = .systemRed
           // button.addTarget(self, action: #selector(createFoodButtonPressed(_:)), for: .touchUpInside)
           return button
       }()
    
    init(title:String, message: String) {
        super.init(frame: UIScreen.main.bounds)
        titleLabel.text = title
        messegeLabel.text = message
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setUpMessegeLabelConstraints()
        setUpTitleLabelConstraints()
        setUpCreateListButtonConstraints()
    }
    
    private func setUpMessegeLabelConstraints() {
        addSubview(messegeLabel)
        messegeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messegeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messegeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messegeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            messegeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    private func setUpTitleLabelConstraints() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: messegeLabel.topAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
            
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


}
