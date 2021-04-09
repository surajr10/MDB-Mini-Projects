//
//  AddLocationVC.swift
//  WeatherDB
//
//  Created by Suraj Rao on 4/9/21.
//

import Foundation
import UIKit
import GooglePlaces

class AddLocationVC: UIViewController {
    
    var autocompleteController: GMSAutocompleteViewController = GMSAutocompleteViewController()
    
    var mainVC: HomeVC!
    
    var selectedPlaceID: String!
    
    var selectedLoc: CLLocation? {
        didSet {
            mainVC.addLocVC(location: selectedLoc!, placeID: selectedPlaceID)
            dismiss(animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        autocompleteController.delegate = self
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.placeID.rawValue))
        autocompleteController.placeFields = fields
        
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        
        view.addSubview(autocompleteController.view)
    }

}

extension AddLocationVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        selectedPlaceID = place.placeID
        GMSPlaces.shared.setLocFromID(placeID: place.placeID!, addLocVC: self)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error in autocomplete: ", error.localizedDescription)
        return
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}
