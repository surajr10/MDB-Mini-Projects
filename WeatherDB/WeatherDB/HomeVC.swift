//
//  HomeVC.swift
//  WeatherDB
//
//  Created by Suraj Rao on 4/9/21.
//

import Foundation
import UIKit
import GooglePlaces



class HomeVC: UIViewController {
    
    static var initialCurrDone = 0
    static var currLocFailed = false
    var starting = 0
    var currVCInd = 0
    
    var locationIDs = UserDefaults.standard.array(forKey: "locations") as? [String] ?? []
    
    var currPlaceID: String? {
            didSet {
                if (HomeVC.initialCurrDone == 0) {
                    configureVCs()
                } else {
                    print("calling changeCurrLocVC from didSet of ucrrplace ID")
                    changeCurrLocVC()
                }
            }
        }
    
    
    var addLocation: UIButton = {
            let btn = UIButton()
            btn.setImage(UIImage(systemName: "plus"), for: .normal)
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 25, weight: .regular))
            btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
            btn.layer.cornerRadius = 41 / 2
            btn.layer.borderWidth = 3
            btn.layer.borderColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
            btn.tintColor = .white
            btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
        }()
    
//    let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 30
//        layout.minimumInteritemSpacing = 20
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(LocationCell.self, forCellWithReuseIdentifier: LocationCell.reuseIdentifier)
//
//        return collectionView
//    }()
    var pageController: UIPageViewController!
    var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .black
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPage = 0
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    
    var weathers: [Weather] = [] {
            didSet {
                if (weathers.count == locationIDs.count && starting == 0) {
                    createVCs()
                }
            }
        }
    
    var locations: [CLLocation] = []
    
    
    var controllers : [WeatherVC] = [WeatherVC]() {
        didSet {
            if controllers.count == locationIDs.count && starting == 0 {
                            pageController.setViewControllers([controllers[0]], direction: .forward, animated: false)
                            pageController.reloadInputViews()
                            starting = 1
                            HomeVC.initialCurrDone = 1
                        }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        
        addChild(pageController)
        view.addSubview(pageController.view)
        view.addSubview(pageControl)
        
        let views = ["pageController": pageController.view] as [String: AnyObject]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageController]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pageController]|", options: [], metrics: nil, views: views))
        
        
        
        
        view.addSubview(addLocation)
        addLocation.addTarget(self, action: #selector(didTapAddLoc(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
                    addLocation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
                    addLocation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
                    pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
                    pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
                ])
        
        GMSPlaces.shared.setCurrentLocationID(vc: self)
        
//        view.addSubview(collectionView)
//        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 50, left: 10, bottom: 100, right: 10))
//        collectionView.backgroundColor = .clear
//        collectionView.dataSource = self
//        collectionView.delegate = self
    }
    
    @objc func didTapAddLoc(_ sender: UIButton) {
        let vc = AddLocationVC()
        vc.mainVC = self
        present(vc, animated: true, completion: nil)
        
    }
    
    func addLocVC(location: CLLocation, placeID: String) {
            print("adding new location")
            let vc = WeatherVC()
            vc.loc = location
            vc.homeVC = self
            WeatherRequest.shared.weather(at: location) { weatherResult in
                switch weatherResult {
                case .success(let weather):
                    DispatchQueue.main.async {
                        vc.weather = weather
                    }
                    self.weathers.append(weather)
                case .failure:
                    print("Error with a weather request at added location \(location.description)")
                    return
                }
            }
        controllers.append(vc)
                locationIDs.append(placeID)
                var temp = locationIDs
                temp.removeFirst()
                if (!HomeVC.currLocFailed) {
                    //don't save the current location if contains curr location
                    UserDefaults.standard.set(temp, forKey: "locations")
                } else {
                    UserDefaults.standard.setValue(locationIDs, forKey: "locations")
                }
                
                locations.append(location) //unused
                pageControl.numberOfPages += 1
                if (HomeVC.currLocFailed) {
                    pageController.setViewControllers([controllers[0]], direction: .forward, animated: false)
                    pageControl.reloadInputViews()
                }
            }
    
    func configureVCs() {
            //add current location and place at front of pages if curr location is set
            print("curr loc failed: \(HomeVC.currLocFailed)")
            if (!HomeVC.currLocFailed) {
                locationIDs.append(currPlaceID!)
                locationIDs.swapAt(0, locationIDs.count - 1)
            }
            pageControl.numberOfPages = locationIDs.count
            GMSPlaces.shared.getLocationVCs(locIDs: locationIDs, vc: self)
        }
        
        func createVCs() {
            print("creating the VCs")
            for i in 0..<weathers.count {
                print("adding \(weathers[i].name)")
                DispatchQueue.main.async {
                    let vc = WeatherVC()
                    vc.homeVC = self
                    vc.loc = self.locations[i]
                    vc.weather = self.weathers[i]
                    self.controllers.append(vc)
                    if (i == 0 && !HomeVC.currLocFailed) {
                        vc.isCurrent = true
                    }
                }
            }
        }
    
    
    func currLocFailed() {
            configureVCs()
        }
    
    func changeCurrLocVC() {
            DispatchQueue.main.async { [weak self] in
                let newVC = WeatherVC()
                newVC.weather = self!.weathers[0]
                newVC.loc = self!.locations[0]
                newVC.homeVC = self!
                if (HomeVC.currLocFailed && self!.controllers[0].isCurrent == false) {
                    self!.controllers.append(newVC)
                    self!.controllers.swapAt(0, self!.controllers.count - 1)
                    self!.pageControl.numberOfPages += 1
                } else {
                    self!.controllers[0] = newVC
                }
                newVC.isCurrent = true
                //DEBUGGING STUFF
    //            var cities: [String] = []
    //            for c in self!.controllers {
    //                cities.append(c.cityName.text!)
    //            }
    //            print("controllers now: \(cities)")
                
                self!.pageController.setViewControllers([self!.controllers[0]], direction: .forward, animated: false)
                self!.pageControl.reloadInputViews()
            }
        }
        
        func deleteLoc(location: CLLocation) {
            let i = locations.firstIndex(of: location)
            //print("deleting location at index \(i)")
            locations.remove(at: i!)
            locationIDs.remove(at: i!)
            weathers.remove(at: i!)
            controllers.remove(at: i!)
            UserDefaults.standard.setValue(locationIDs, forKey: "locations")
            pageControl.numberOfPages -= 1
            if (controllers.count == 0) {
                addLocation.tintColor = .black
            } else {
                pageController.setViewControllers([controllers[0]], direction: .forward, animated: false)
                pageControl.reloadInputViews()
            }
            pageControl.currentPage = 0
            currVCInd = 0 //useless
        }
    
    
}

extension HomeVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController as! WeatherVC) {
            if index > 0 {
                return controllers[index-1]
            } else {
                return nil
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController as! WeatherVC) {
            if index < controllers.count - 1 {
                return controllers[index+1]
            } else {
                return nil
            }
        }
        return nil
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let viewControllers = pageViewController.viewControllers {
                if let viewControllerIndex = self.controllers.firstIndex(of: viewControllers[0] as! WeatherVC) {
                    self.pageControl.currentPage = viewControllerIndex
                }
            }
        }
    }
    
}


//extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let events = events else {return 0}
//        return events.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.reuseIdentifier, for: indexPath) as! EventCell
//        let event = events?[indexPath.item]
//        cell.event = event
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            return CGSize(width: view.frame.width * (1/3), height: 150)
//        }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let event = events?[indexPath.item]
//        let vc = EventDetailsVC()
//        vc.currEvent = event
//        present(vc, animated: true, completion: nil)
//    }
//}


//class LocationCell: UICollectionViewCell {
//    static let reuseIdentifier = "locationCell"
//
//
//    var location:
//}
