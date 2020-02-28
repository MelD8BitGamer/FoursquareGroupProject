//
//  tableViewView.swift
//  FoursquareGroupProject
//
//  Created by Howard Chang on 2/26/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit

final class tableViewView: UIView {
    
    lazy var tableView: UITableView = {
        let tableV = UITableView()
        tableV.rowHeight = 100
        tableV.backgroundColor = .white
        return tableV
    }()
    
    lazy var topView: UILabel = {
        let button = UILabel()
        button.isUserInteractionEnabled = true
        button.backgroundColor = UIColor.gray
        return button
    }()
    
    
    private func buttonConstraints() {
        addSubview(topView)
        topView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 25)
    }
    
    private func tableViewConstraints() {
        addSubview(tableView)
        tableView.anchor(top: topView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = .blue
        layer.cornerRadius = 20
        layer.masksToBounds = true
        buttonConstraints()
        tableViewConstraints()
        tableView.register(VenueTableViewCell.self, forCellReuseIdentifier: "VenueTableViewCell")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
