//
//  CreateNewVC.swift
//  FoursquareGroupProject
//
//  Created by Tsering Lama on 2/28/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit
import DataPersistence

class CreateNewVC: UIViewController {
    var textFieldString = ""
    var textFieldDescription = ""
    public var dataPersistence: DataPersistence<VenueDetail>!
    public var collectionPersistence: DataPersistence<Collection>!
    let createdView = CreateNewView()

    public var createdCollection: Collection!
   
    override func loadView() {
        view = createdView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        createdView.nameOfCollectionTF.delegate = self
        createdView.createButton.addTarget(self, action: #selector(createButtonPressed(_:)), for: .touchUpInside)
    
    }
    
    init(_ dataPersistence: DataPersistence<VenueDetail>, collectionPersistence: DataPersistence<Collection>) {
           self.dataPersistence = dataPersistence
           self.collectionPersistence = collectionPersistence
           super.init(nibName: nil, bundle: nil)

       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        @objc public func createButtonPressed(_ sender: UIButton) {
            createdCollection = Collection(name: textFieldString, description: textFieldDescription)
            //TODO: if the collection name has already been made
            if collectionPersistence.hasItemBeenSaved(createdCollection) {
                     showAlert(title: "Wait!!", message: "This collection has already been saved to your favorites")
                 } else {
            do {
           try collectionPersistence.createItem(createdCollection)
                //MARK: The wording was off
                showAlert(title: "Success", message: "You created a new collection. Now you can add venues to this list")
            } catch {
                showAlert(title: "Error", message: "Cannot create anything")
            }
    
}
//    public func blur() {
//           if !UIAccessibility.isReduceTransparencyEnabled {
//               view.backgroundColor = .clear
//
//               let blurEffect = UIBlurEffect(style: .dark)
//               let blurEffectView = UIVisualEffectView(effect: blurEffect)
//               //always fill the view
//               blurEffectView.frame = self.view.bounds
//               blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//               view.addSubview(blurEffectView)
//           } else {
//               view.backgroundColor = .black
//           }
//       }
}
}
extension CreateNewVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldString = createdView.nameOfCollectionTF.text ?? "NO"
        textFieldDescription = createdView.descriptionTF.text ?? "Hell NO"
    }
}

