//
//  NewEventVC.swift
//  MDB Social
//
//  Created by Suraj Rao on 4/6/21.
//

import Foundation

import UIKit
import NotificationBannerSwift

class NewEventVC: UIViewController {
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 25
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Create New Event"
        lbl.textColor = .primaryText
        lbl.font = .systemFont(ofSize: 30, weight: .semibold)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let eventNameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Name:")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let eventDescriptionTextField: AuthTextField = {
        let tf = AuthTextField(title: "Description:")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    private let createEventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create event", for: .normal)
        button.backgroundColor = .yellow
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    private let datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    private var date: Date?
    
    private let imagePicker: UIImagePickerController = {
        let image = UIImagePickerController()
        return image
    }()
    
    private let contentEdgeInset = UIEdgeInsets(top: 120, left: 40, bottom: 30, right: 40)
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: contentEdgeInset.top),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: contentEdgeInset.left),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: contentEdgeInset.right)
        ])
        
        
        view.addSubview(stack)
        stack.addArrangedSubview(eventNameTextField)
        stack.addArrangedSubview(eventDescriptionTextField)
        stack.addArrangedSubview(datePicker)
        stack.addArrangedSubview(<#T##view: UIView##UIView#>)
        
        
        
    }
    
    
}
