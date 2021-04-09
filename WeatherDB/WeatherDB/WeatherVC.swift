//
//  WeatherVC.swift
//  WeatherDB
//
//  Created by Suraj Rao on 4/9/21.
//

import Foundation
import UIKit
import GooglePlaces

class WeatherVC: UIViewController {
        
    var loc: CLLocation? {
        didSet {
            print("set location in weatherpagevc: \(loc!.description)")
        }
    }
    
    var homeVC: HomeVC?
    
//    var mainVC: MainVC?
    
    var isCurrent = false
    
    var weather: Weather? {
        didSet {
            guard let weather = weather else { return }
            cityName.text = weather.name
            currTemp.text = weather.main.temperature.description + "°"
            currCondition.text = weather.condition.first!.description
            let url: URL = URL(string: "http://openweathermap.org/img/wn/\(weather.condition.first!.icon)@2x.png")!
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    self.icon.image = image
                }
            }
            feelsLikeLabel.text = "Feels like: " + weather.main.heatIndex.description + "°"
//            feelsLike.setInfo(info: weather.main.heatIndex.description + "°")
            pressureLabel.text = "Pressure: " + weather.main.pressure.description
//            pressure.setInfo(info: weather.main.pressure.description)
            humidityLabel.text = "Humidity: " + weather.main.humidity.description
//            humidity.setInfo(info: weather.main.humidity.description
            
        }
    }
    
    var cityName: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 35, weight: .medium)
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var currTemp: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 50, weight: .medium)
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var icon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var currCondition: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 22, weight: .regular)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var feelsLikeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.textAlignment = .left
        return lbl
    }()
    
//    var feelsLike: WeatherInfo = {
//        let fl = WeatherInfo(title: "Feels Like", info: "")
//        fl.translatesAutoresizingMaskIntoConstraints = false
//        return fl
//    }()
    
    var pressureLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.textAlignment = .left
        return lbl
    }()
    
//    var pressure: WeatherInfo = {
//        let p = WeatherInfo(title: "Pressure", info: "")
//        p.translatesAutoresizingMaskIntoConstraints = false
//        return p
//    }()
    
    var humidityLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.textAlignment = .left
        return lbl
    }()
    
//    var humidity: WeatherInfo = {
//        let h = WeatherInfo(title: "Humidity", info: "")
//        h.translatesAutoresizingMaskIntoConstraints = false
//        return h
//    }()
    
    var deleteLoc: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "minus"), for: .normal)
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
    
//    var lightButton: UIButton = {
//        let btn = UIButton()
//        btn.setTitle("Dark", for: .normal)
//
//        return btn
//    }()
    
//    var isDark: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if (isDark) {
//            overrideUserInterfaceStyle = .dark
//        }
        
        let isDark = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        
        if (isCurrent) { //can't delete current controller
            deleteLoc.isHidden = true
        }
        view.addSubview(deleteLoc)
        deleteLoc.addTarget(self, action: #selector(didTapDeleteLoc(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            deleteLoc.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            deleteLoc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
        ])
        
        view.addSubview(cityName)
        view.addSubview(icon)
        view.addSubview(currCondition)
        view.addSubview(currTemp)
        
        infoStack.addArrangedSubview(feelsLikeLabel)
        infoStack.addArrangedSubview(pressureLabel)
        infoStack.addArrangedSubview(humidityLabel)
        view.addSubview(infoStack)
        
//        view.addSubview(lightButton)
//        lightButton.addTarget(self, action: #selector(didTapLight(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            cityName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            cityName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: 10),
            icon.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            currCondition.topAnchor.constraint(equalTo: currTemp.bottomAnchor, constant: 35),
            currCondition.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            currTemp.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20),
            currTemp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoStack.topAnchor.constraint(equalTo: currCondition.bottomAnchor, constant: 35),
            infoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            infoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
//            lightButton.topAnchor.constraint(equalTo: infoStack.bottomAnchor, constant: 20),
//            lightButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let orangeColor = UIColor(red: 255/255, green: 183/255, blue: 3/255, alpha: 1)
        let darkColor = UIColor(red: 52/255, green: 58/255, blue: 64/255, alpha: 1)
        let cond = weather!.condition.first!.name
        var iconID = weather!.condition.first!.icon
        if (isDark) { //light mode: day icon, bg color and text depend on condition
            if (iconID.contains("n")) {
                let i = iconID.firstIndex(of: "n")
                iconID = iconID[..<i!] + "d"
            }
            let url: URL = URL(string: "http://openweathermap.org/img/wn/\(iconID)@2x.png")!
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    self.icon.image = image
                }
            }
            if (cond == "Thunderstorm") {
                view.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
            } else if (cond == "Drizzle") {
                view.backgroundColor = UIColor(red: 119/255, green: 141/255, blue: 169/255, alpha: 1)
            } else if (cond == "Rain") {
                view.backgroundColor = UIColor(red: 65/255, green: 90/255, blue: 119/255, alpha: 1)
                feelsLikeLabel.textColor = darkColor
                pressureLabel.textColor = darkColor
                humidityLabel.textColor = darkColor
//                feelsLikeLabel.setTextColor(titleColor: darkColor)
//                pressureLabel.setTextColor(titleColor: darkColor)
//                humidityLabel.setTextColor(titleColor: darkColor)
            } else if (cond == "Snow") {
                view.backgroundColor = UIColor(red: 248/255, green: 249/255, blue: 250/255, alpha: 1)
                let blueColor = UIColor(red: 193/255, green: 211/255, blue: 254/255, alpha: 1)
                cityName.textColor = blueColor
                currTemp.textColor = blueColor
                currCondition.textColor = blueColor
                feelsLikeLabel.textColor = blueColor
                pressureLabel.textColor = blueColor
                humidityLabel.textColor = blueColor
            } else if (cond == "Atmosphere") {
                view.backgroundColor = UIColor(red: 206/255, green: 212/255, blue: 218/255, alpha: 1)
                cityName.textColor = darkColor
                currTemp.textColor = darkColor
                currCondition.textColor = darkColor
                feelsLikeLabel.textColor = UIColor(red: 33/255, green: 37/255, blue: 41/255, alpha: 1)
                pressureLabel.textColor = UIColor(red: 33/255, green: 37/255, blue: 41/255, alpha: 1)
                humidityLabel.textColor = UIColor(red: 33/255, green: 37/255, blue: 41/255, alpha: 1)
//                feelsLikeLabel.text.setTextColor(titleColor: UIColor(red: 33/255, green: 37/255, blue: 41/255, alpha: 1), infoColor: darkColor)
//                pressureLabel.setTextColor(titleColor: UIColor(red: 33/255, green: 37/255, blue: 41/255, alpha: 1), infoColor: darkColor)
//                humidityLabel.setTextColor(titleColor: UIColor(red: 33/255, green: 37/255, blue: 41/255, alpha: 1), infoColor: darkColor)
            } else if (cond == "Clear") {
                view.backgroundColor = UIColor(red: 33/255, green: 158/255, blue: 188/255, alpha: 1)
                currCondition.textColor = orangeColor
                feelsLikeLabel.textColor = darkColor
                pressureLabel.textColor = darkColor
                humidityLabel.textColor = darkColor
                
            } else if (cond == "Clouds") {
                view.backgroundColor = UIColor(red: 167/255, green: 194/255, blue: 211/255, alpha: 1)
                cityName.textColor = darkColor
                currTemp.textColor = darkColor
                currCondition.textColor = darkColor
                feelsLikeLabel.textColor = UIColor(red: 33/255, green: 37/255, blue: 41/255, alpha: 1)
                pressureLabel.textColor = UIColor(red: 33/255, green: 37/255, blue: 41/255, alpha: 1)
                humidityLabel.textColor = UIColor(red: 33/255, green: 37/255, blue: 41/255, alpha: 1)
//                feelsLike.setTextColor(titleColor: UIColor(red: 33/255, green: 37/255, blue: 41/255, alpha: 1), infoColor: darkColor)
//                pressure.setTextColor(titleColor: UIColor(red: 33/255, green: 37/255, blue: 41/255, alpha: 1), infoColor: darkColor)
//                humidity.setTextColor(titleColor: UIColor(red: 33/255, green: 37/255, blue: 41/255, alpha: 1), infoColor: darkColor)
            } else {
                view.backgroundColor = .black
            }
//            view.backgroundColor = .black
        } else { //dark mode: icon to night version, bg color + text, and pc tint colors
            
            if (iconID.contains("d")) {
                let i = iconID.firstIndex(of: "d")
                iconID = iconID[..<i!] + "n"
            }
            let url: URL = URL(string: "http://openweathermap.org/img/wn/\(iconID)@2x.png")!
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    self.icon.image = image
                }
            }
            
            let text = UIColor(red: 224/255, green: 225/255, blue: 221/255, alpha: 1)
            view.backgroundColor = UIColor(red: 13/255, green: 27/255, blue: 42/255, alpha: 1)
            cityName.textColor = text
            currTemp.textColor = text
            currCondition.textColor = text
//            feelsLike.setTextColor(infoColor: text)
//            pressure.setTextColor(infoColor: text)
//            humidity.setTextColor(infoColor: text)
            
//            mainVC?.pageControl.currentPageIndicatorTintColor = .white
//            mainVC?.pageControl.pageIndicatorTintColor = .darkGray
        }
        
        
    }
    
    @objc func didTapDeleteLoc(_ sender: UIButton) {
        guard let homeVC = homeVC else { return }
        homeVC.deleteLoc(location: loc!)
    }
    
//    @objc func didTapLight(_ sender: UIButton) {
//        lightButton.setTitle("Light", for: .normal)
//        isDark = true
//
//    }

}
