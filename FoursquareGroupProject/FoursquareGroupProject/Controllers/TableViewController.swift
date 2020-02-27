//
//  TableViewController.swift
//  FoursquareGroupProject
//
//  Created by Howard Chang on 2/26/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit

final class TableViewController: UIViewController {

    private var venues = [Venue]() {
            didSet {
                venueTableView.tableView.reloadData()
            }
        }
        
        let venueTableView = tableViewView()
        
    override func loadView() {
        view = venueTableView
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            venueTableView.tableView.delegate = self
            venueTableView.tableView.dataSource = self
        }
        
}

    extension TableViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            venues.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let selectedCell = venues[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: "VenueTableViewCell", for: indexPath) as? VenueTableViewCell {
                cell.configureCell(venue: selectedCell)
                return cell
            }
            return UITableViewCell()
        }
        
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            let selectedCell = venues[indexPath.row]
//           
//            
//        }
    }

    

