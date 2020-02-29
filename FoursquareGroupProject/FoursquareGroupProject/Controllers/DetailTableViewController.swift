//
//  DetailTableViewController.swift
//  FoursquareGroupProject
//
//  Created by Tsering Lama on 2/28/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit
import DataPersistence

class DetailTableViewController: UIViewController {

    private var collectionPersistence: DataPersistence<Collection>!
    private var dataPersistence: DataPersistence<VenueDetail>!
    
    public var venues = [Venue]() {
        didSet{
            tableView.tableView.reloadData()
        }
    }
    
    private let tableView = DetailTableView2()
    
    override func loadView() {
        view = tableView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
    }
}

extension DetailTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedCell = venues[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell {
            
            cell.configureCell(venue: selectedCell)
            return cell
        }
          return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = venues[indexPath.row]
        let detailedVC = DetailViewController(collectionPersistence, venue: selectedCell)
        present(detailedVC, animated: true, completion: nil)
    }
    
}
