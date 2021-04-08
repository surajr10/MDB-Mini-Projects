//
//  NewEventVC.swift
//  MDB Social
//
//  Created by Suraj Rao on 4/6/21.
//

import Foundation
import FirebaseFirestore

import UIKit
import NotificationBannerSwift

class NewEventVC: UIViewController, UINavigationControllerDelegate {
    
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
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    private let datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    
    private let imagePicker: UIImagePickerController = {
        let image = UIImagePickerController()
        return image
    }()
    
    private let imagePickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Pick an image", for: .normal)
        button.setTitleColor(.red, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let contentEdgeInset = UIEdgeInsets(top: 120, left: 40, bottom: 30, right: 40)
    
    
    private var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)
    
    
    private var date: Date?
    private var imageMeta: Any?
    private var pickedImage: UIImage?
    private var pickedImageURL: URL?
    private var pickedImageData: Data?
    
    
    
    
    
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
        stack.addArrangedSubview(imagePickerButton)
        
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: contentEdgeInset.left),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: -contentEdgeInset.right),
            stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                       constant: 60)
        ])
        
        view.addSubview(createEventButton)
        NSLayoutConstraint.activate([
            createEventButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            createEventButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30),
            createEventButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            createEventButton.heightAnchor.constraint(equalToConstant: 44.0)
        ])
        
        createEventButton.layer.cornerRadius = 22
        
        createEventButton.addTarget(self, action: #selector(didTapCreateEvent(_:)), for: .touchUpInside)
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minuteInterval = 1
        
        imagePicker.delegate = self
        imagePickerButton.addTarget(self, action: #selector(didTapChooseImage(_:)), for: .touchUpInside)
        
        
        
    }
    
    @objc func didTapCreateEvent(_ sender: UIButton) {
        guard let eventName = eventNameTextField.text, eventName != "" else {
            showErrorBanner(withTitle: "Missing event name", subtitle: "Please provide an event name")
            return
        }
        
        guard let eventDesc = eventDescriptionTextField.text, eventDesc != "" else {
            showErrorBanner(withTitle: "Missing event description", subtitle: "Please provide an event description")
            return
        }
        
        if (eventDesc.count > 140) {
            showErrorBanner(withTitle: "Missing event description", subtitle: "Please provide an event description")
        }
        
        if (pickedImage == nil) {
            showErrorBanner(withTitle: "Missing event image", subtitle: "Please provide an event image")
        }
        
        if (datePicker.date == nil) {
            showErrorBanner(withTitle: "Missing event date", subtitle: "Please provide an event date")
        }
        
        if (pickedImageData == nil) {
            return
        }
        
        
        let currID: UserID = FIRAuthProvider.shared.currentUser!.uid!
        
        let storageRef = FIRStorage.shared.storage.reference().child("images/" + UUID().uuidString + ".jpeg")
        
        
        
        
        _ = storageRef.putData(pickedImageData!, metadata: FIRStorage.shared.metadata) { (metadata, error) in storageRef.downloadURL { (url, error) in guard let downloadURL = url else {
                print("ummm" + error!.localizedDescription)
                return
            }
            
        let event: Event = Event(name: eventName, description: eventDesc, photoURL: downloadURL.relativeString, startTimeStamp: Timestamp(date: self.datePicker.date), creator: currID, rsvpUsers: [] )
        FIRDatabaseRequest.shared.setEvent(event, completion: {})
        }
        }
        
//        let ref = FIRStorage.shared.storage.reference().child("images/" + UUID().uuidString + ".jpeg")
//        uploadTask = ref.putData(pickedImageData!, metadata: FIRStorage.shared.metadata) { (metadata, error) in ref.downloadURL { (url, error) in
//            guar
//        }}
//
//        let ref =FIRStorage.shared.storage.reference().child(UUID().uuidString + ".jpeg")
//                _ = ref.putData(pickedImageData!, metadata: FIRStorage.shared.metadata) { (metadata, error) in
//                  ref.downloadURL { (url, error) in
//                    guard let downloadURL = url else {
//                        print("ERROR OCCURED WHILE DOWNLOADING URL - error: \(String(describing: error))")
//                      return
//                    }
//                    let event: Event = Event(name: name1, description: desc, photoURL: downloadURL.relativeString, startTimeStamp: Timestamp(date: self.pickedDate!), creator: currID, rsvpUsers: [])
//                    //create document on firestore and set data
//                    FIRDatabaseRequest.shared.db.collection("events").document(event.id!)
//                    FIRDatabaseRequest.shared.setEvent(event, completion: {})
//                  }
//                }
//
        
        
        
//
//        func upload(_ image: UIImage,
//                          completion: @escaping (_ hasFinished: Bool, _ url: String) -> Void) {
//        let data: Data = UIImageJPEGRepresentation(image, 1.0)!
//
//        // ref should be like this
//        let ref = FIRStorage.storage().reference(withPath: "media/" + userId + "/" + unicIdGeneratedLikeYouWant)
//        ref.put(data, metadata: nil,
//                           completion: { (meta , error) in
//                            if error == nil {
//                               // return url
//                               completion(true, (meta?.downloadURL()?.absoluteString)!)
//                            } else {
//                               completion(false, "")
//                            }
//          })
        
        
        
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    @objc func didTapChooseImage(_ sender: UIButton) {
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))

            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallery()
            }))

            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            alert.view.addSubview(UIView())
            present(alert, animated: false, completion: nil)
        }
        
        private func openCamera() {
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                present(imagePicker, animated: true, completion: nil)
            } else {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.view.addSubview(UIView())
                present(alert, animated: false, completion: nil)
            }
        }
        
        private func openGallery() {
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)) {
                imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                present(imagePicker, animated: true, completion: nil)
            } else {
                let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: false, completion: nil)
            }
        }
    
    
    private func showErrorBanner(withTitle title: String, subtitle: String? = nil) {
        guard bannerQueue.numberOfBanners == 0 else { return }
        let banner = FloatingNotificationBanner(title: title, subtitle: subtitle,
                                                titleFont: .systemFont(ofSize: 17, weight: .medium),
                                                subtitleFont: subtitle != nil ?
                                                    .systemFont(ofSize: 14, weight: .regular) : nil,
                                                style: .warning)
        
        banner.show(bannerPosition: .top,
                    queue: bannerQueue,
                    edgeInsets: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15),
                    cornerRadius: 10,
                    shadowColor: .primaryText,
                    shadowOpacity: 0.3,
                    shadowBlurRadius: 10)
    }
    
    
}


extension NewEventVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            pickedImage = image.resize(withPercentage: 0.1)
            pickedImageData = pickedImage?.jpegData(compressionQuality: 0.1)
            
        }
        
        if let imageURL = info[.imageURL] as? URL {
            pickedImageURL = imageURL
        }
        
//        if let imageMetadata = info[.mediaMetadata] as? NSDictionary {
//            imageMeta = imageMetadata
//        }
        imageMeta = info[.mediaMetadata]
        
        
        
        
        picker.dismiss(animated: true, completion: nil)
            
    }
        
        
}

extension UIImage {
    
    func resize(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
           
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
                let format = imageRendererFormat
                format.opaque = isOpaque
                return UIGraphicsImageRenderer(size: canvas, format: format).image {
                    _ in draw(in: CGRect(origin: .zero, size: canvas))
                }
        
        
//        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
//
//        imageView.contentMode = .scaleAspectFill
//        imageView.image = self
//        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
//        guard let context = UIGraphicsGetCurrentContext() else {return nil}
//        imageView.layer.renderIn(context)
//        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
//        UIGraphicsEndImageContext()
//        return result
        
        

//        let format = imageRendererFormat
//        format.opaque = isOpaque
//        return UIGraphicsImageRenderer(size: canvas, format: format).image {
//            _ in draw(in: CGRect(origin: .zero, size: canvas))
//            }
    }
    
}
    
    
    
    
    
    
    

