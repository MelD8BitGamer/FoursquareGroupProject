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
    private var currentCollection: Collection!
    
    public var venues = [Venue]() {
        didSet{
            tableView.tableView.reloadData()
        }
    }
   
    private func loadVenue() {
        venues = currentCollection.venue
    }
    
    init(_ collectionPersistence: DataPersistence<Collection>, collection: Collection) {
           self.collectionPersistence = collectionPersistence
           self.currentCollection = collection
           super.init(nibName: nil, bundle: nil)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView = DetailTableView2()
    
    override func loadView() {
        view = tableView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        tableView.tableView.delegate = self
        tableView.tableView.dataSource = self
        loadVenue()
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
