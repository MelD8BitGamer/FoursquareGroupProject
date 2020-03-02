//
//  SaveCollectionsVC.swift
//  FoursquareGroupProject
//
//  Created by Tsering Lama on 2/28/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit
import DataPersistence
import NetworkHelper

class SaveCollectionsVC: UIViewController {
    
    private var saveCollectionsView = SaveView()
    
    private var createCollection: Collection?
    private var dataPersistence: DataPersistence<VenueDetail>
    private var collectionPersistence: DataPersistence<Collection>
    
    private var allTheCollections = [Collection](){
        didSet {
            saveCollectionsView.collectionView.reloadData()
            
            
            //            if allTheCollections.isEmpty {
            //
            //                // setup background view, in case there are no saved places
            ////                saveCollectionsView.collectionView.backgroundView = EmptyView(title: "Favorites", message: "There are currently no Favorited Collections. Start browsing and add to collection")
            ////                saveCollectionsView.createListButton.addTarget(self, action: #selector(createANewFavoriteCollectionPressed(_:)), for: .touchUpInside)
            //            } else {
            //                saveCollectionsView.collectionView.backgroundView = nil
            //            }
            navigationItem.title = "Favorites(\(allTheCollections.count))"
        }
    }
    
    init(_ dataPersistence: DataPersistence<VenueDetail>, collectionPersistence: DataPersistence<Collection>) {
        self.dataPersistence = dataPersistence
        self.collectionPersistence = collectionPersistence
        super.init(nibName: nil, bundle: nil)
        
        self.collectionPersistence.delegate = self
        self.dataPersistence.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = saveCollectionsView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveCollectionsView.collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        saveCollectionsView.collectionView.delegate = self
        saveCollectionsView.collectionView.dataSource = self
        saveCollectionsView.createListButton.addTarget(self, action: #selector(createANewFavoriteCollectionPressed(_:)), for: .touchUpInside)
        getFavCollection()
        //        view.backgroundColor = .systemBlue
        
    }
    //    public func blur() {
    //        if !UIAccessibility.isReduceTransparencyEnabled {
    //            view.backgroundColor = .clear
    //
    //            let blurEffect = UIBlurEffect(style: .dark)
    //            let blurEffectView = UIVisualEffectView(effect: blurEffect)
    //            //always fill the view
    //            blurEffectView.frame = self.view.bounds
    //            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    //
    //            view.addSubview(blurEffectView)
    //        } else {
    //            view.backgroundColor = .black
    //        }
    //    }
    
    @objc func createANewFavoriteCollectionPressed(_ sender: UIButton) {
        let createVC = CreateNewVC(dataPersistence, collectionPersistence: collectionPersistence)
        createVC.modalPresentationStyle = .overCurrentContext
        createVC.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(createVC, animated: true)
        print("button pressed")
        // blur()
        
    }
    
    private func getFavCollection() {
        do {
            allTheCollections = try collectionPersistence.loadItems()
        } catch {
            print("error while loading collections")
        }
    }
}

extension SaveCollectionsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.4
        let itemHeight: CGFloat = maxSize.height * 0.2
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tableView = DetailTableViewController()
        present(tableView, animated: true)
    }
}

extension SaveCollectionsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allTheCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let saved = allTheCollections[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            fatalError("could not downcast to CollectionViewCell")}
        //MARK: The previous color was horrible
        cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.delegate = self
        cell.configCell(saved)
        return cell
    }
}

extension SaveCollectionsVC: CollectionCellDelegate {
    
    func didSelectMoreButton(_ favoritesCell: CollectionViewCell, cell: Collection) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let editAction = UIAlertAction(title: "Edit Collection", style: .default) { (action) in
            self.editCollection(cell)
        }
        //MARK:This adds an option to go to the tableview so they can add more to their collection
        let addMoreToCollection = UIAlertAction(title: "Add more to this collection", style: .default) { (action) in
            self.addToThisCollection()
        }
        let deleteAction = UIAlertAction(title: "Delete Collection", style: .destructive) { (action) in
            self.deleteCollection(cell)
        }
        alertController.addAction(editAction)
        //MARK:
        alertController.addAction(addMoreToCollection)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func deleteCollection(_ collection: Collection) {
        guard let index = allTheCollections.firstIndex(of: collection) else {
            return
        }
        do {
            // deletes from documents directory
            try collectionPersistence.deleteItem(at: index)
        } catch {
            showAlert(title: "Deleted", message: "This collection is now deleted")
            print("error deleting collection \(error)")
        }
    }
    
    private func editCollection(_ collection: Collection) {
        guard let index = allTheCollections.firstIndex(of: collection) else {
            return
        }
        collectionPersistence.update(collection, at: index)
        //MARK:This is a new function that gets them to the detailtableviewVC so they can edit the collection
            let tableViewVC = DetailTableViewController()
            tableViewVC.modalPresentationStyle = .overCurrentContext
            tableViewVC.modalTransitionStyle = .crossDissolve
            navigationController?.pushViewController(tableViewVC, animated: true)
      
    }
    //MARK:This is a new function that gets them to the tableviewVC so they can add a new favorite to the collection
    private func addToThisCollection() {
        let tableViewVC = TableViewController(collectionPersistence)
        tableViewVC.modalPresentationStyle = .overCurrentContext
        tableViewVC.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(tableViewVC, animated: true)
    }
    
}

extension SaveCollectionsVC: DataPersistenceDelegate {
    func didSaveItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        
        do {
            allTheCollections = try collectionPersistence.loadItems()
            
        } catch {
            showAlert(title: "Error", message: "Could not load items\(error)")
        }
    }
    
    func didDeleteItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        do {
            allTheCollections = try collectionPersistence.loadItems()
            
        } catch {
            showAlert(title: "Error", message: "Could not load items\(error)")
        }
        
    }
    
    
}

