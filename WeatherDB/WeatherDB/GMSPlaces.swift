//
//  GMSPlaces.swift
//  WeatherDB
//
//  Created by Suraj Rao on 4/9/21.
//

import Foundation
import GooglePlaces
import UIKit

class GMSPlaces {
    
    static let client = GMSPlacesClient.shared()
        
        static let shared = GMSPlaces()
        
        var currID: String?
        
        var mainRef: HomeVC?
        
        func setCurrentLocationID(vc: HomeVC) {
            print("setting the currPlaceID")
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.placeID.rawValue))
            GMSPlaces.client.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: {
                (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
                if let error = error {
                    HomeVC.currLocFailed = true
                    vc.currLocFailed()
                  print("An error occurred: \(error.localizedDescription)")
                  return
                }
                if let placeLikelihoodList = placeLikelihoodList {
                  for likelihood in placeLikelihoodList {
                    let place = likelihood.place
                    self.currID = place.placeID //unused
                    vc.currPlaceID = place.placeID
                    break
                  }
                }
            })
        }
        
        
        func getLocation(place: GMSPlace) -> CLLocation {
            return CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        }
        
        func setLocFromID(placeID: String, addLocVC: AddLocationVC) {
            GMSPlaces.client.lookUpPlaceID(placeID, callback: { (result: GMSPlace?, error: Error?) in
                if let error = error {
                    print("An error occurred in setLocFromID: \(error.localizedDescription)")
                    return
                }
                if let result = result {
                    let loc: CLLocation = CLLocation(latitude: result.coordinate.latitude, longitude: result.coordinate.longitude)
                    addLocVC.selectedLoc = loc
                }
            })
        }
        
        func getLocationVCs(locIDs: [String], vc: HomeVC) {
            mainRef = vc
            for id in locIDs {
                GMSPlaces.client.lookUpPlaceID(id, callback: { (result: GMSPlace?, error: Error?) in
                    if let error = error {
                        print("An error occurred: \(error.localizedDescription)")
                        return
                    }
                    if let result = result {
                        let loc: CLLocation = CLLocation(latitude: result.coordinate.latitude, longitude: result.coordinate.longitude)
                        WeatherRequest.shared.weather(at: loc) { weatherResult in
                            switch weatherResult {
                            case .success(let weather):
                                vc.locations.append(loc) //unused
                                vc.weathers.append(weather)
                            case .failure:
                                print("Error with a weather request at location \(loc.description)")
                                return
                            }
                        }
                    }
                })
            }
        }
        
        func updateCurrLocation() {
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.placeID.rawValue))
            GMSPlaces.client.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: {
                (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
                if let error = error {
                    HomeVC.currLocFailed = true
                  print("An error occurred: \(error.localizedDescription)")
                  return
                }
                if let placeLikelihoodList = placeLikelihoodList {
                  for likelihood in placeLikelihoodList {
                    let place = likelihood.place
                    self.currID = place.placeID //unused
                    let loc: CLLocation = LocationManager.shared.location!
                    //self.mainRef?.locations[0] = loc
                    WeatherRequest.shared.weather(at: loc) { weatherResult in
                        switch weatherResult {
                        case .success(let weather):
                            if (HomeVC.currLocFailed) {
                                //MainVC.currLocFailed = false //FIX: can't change settings to get curr location before app starts
                                print("adding a new current location to locations and weathers list: \(weather.name)")
                                self.mainRef?.locations.append(loc)
                                self.mainRef?.weathers.append(weather)
                                self.mainRef?.locations.swapAt(0, (self.mainRef?.locations.count)! - 1)
                                self.mainRef?.weathers.swapAt(0, (self.mainRef?.weathers.count)! - 1)
                                self.mainRef!.currPlaceID = place.placeID
                            } else {
                                print("modifying first item of locations and weathers list")
                                self.mainRef?.locations[0] = loc
                                self.mainRef?.weathers[0] = weather
                                self.mainRef!.currPlaceID = place.placeID
                            }
                        case .failure:
                            print("Error with a weather request at location \(loc.description)")
                            return
                        }
                    }
                    break
                  }
                }
            })
        }
    }
    
    
    
    
    
    
    

