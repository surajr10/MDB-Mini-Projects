//
//  FeedVC.swift
//  MDB Social
//
//  Created by Michael Lin on 2/25/21.
//

import UIKit
import Firebase

class FeedVC: UIViewController {
    
//    var feedTableView: UITableView!
    var events: [Event]?
    
    
//    let eventsRef = FIRDatabaseRequest.shared.db.collection("events").getDocuments() { (QuerySnapshot, err) in
//        if let err = err {
//            print("Error getting documents: \(err)")
//            return
//        }
//    }
    func updateEvents(newEvents: [Event]) {
            print("in updatingEvents")
            events = newEvents
            collectionView.reloadData()
    }
    
    let newEventButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Add Event", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        
        return btn
    }()
    
    private let signOutButton: UIButton = {
//        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let btn = UIButton()
        btn.backgroundColor = .primary
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .medium))
        btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 30
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.reuseIdentifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        
        events = FIRDatabaseRequest.shared.getEvents(vc: self)
        
        view.addSubview(signOutButton)
        
//        signOutButton.center = view.center
        signOutButton.addTarget(self, action: #selector(didTapSignOut(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            signOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
//        feedTableView = UITableView(frame: CGREct)
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 50, left: 10, bottom: 100, right: 10))
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc func didTapSignOut(_ sender: UIButton) {
        FIRAuthProvider.shared.signOut {
            guard let window = UIApplication.shared
                    .windows.filter({ $0.isKeyWindow }).first else { return }
            let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController()
            window.rootViewController = vc
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.3
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
        }
    }
}

extension FeedVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let events = events else {return 0}
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.reuseIdentifier, for: indexPath) as! EventCell
        let event = events?[indexPath.item]
        cell.event = event
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: view.frame.width * (1/3), height: 150)
        }
}

class EventCell: UICollectionViewCell {
    static let reuseIdentifier = "eventCell"
    
    var event: Event? {
        didSet {
            guard let event = event else {return}
            let gsReference: StorageReference = Storage.storage().reference(forURL: event.photoURL)
                        gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if let error = error {
                                print("Photo error occurred: \(error)")
                              } else {
                                self.imageView.image = UIImage(data: data!)
                              }
                        }
            nameLabel.text = event.name
            let docRef = FIRDatabaseRequest.shared.db.collection("users").document(event.creator)
                        docRef.getDocument(completion: { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting docuemnt of event creator: \(err)")
                            } else {
                                guard let user = try? querySnapshot?.data(as: User.self) else {
                                    print("error in getting user of creator")
                                    return
                                }
                                self.creatorLabel.text = user.fullname
                            }
                        })
            creatorLabel.text = event.creator
            rsvpLabel.text = String(event.rsvpUsers.count)
            
            
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit

        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let creatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let rsvpLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(creatorLabel)
        contentView.addSubview(rsvpLabel)
        
//        self.layer.borderWidth = 5.0
//        self.layer.borderColor = UIColor.clear.cgColor
//        self.layer.masksToBounds = true
//        self.contentView.layer.cornerRadius = 15.0
//        self.contentView.layer.borderWidth = 5.0
//        self.contentView.layer.borderColor = UIColor.clear.cgColor
//        self.contentView.layer.masksToBounds = true
//        self.layer.shadowColor = UIColor.white.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 0.0)
//        self.layer.shadowRadius = 6.0
//        self.layer.shadowOpacity = 0.6
//        self.layer.cornerRadius = 15.0
//        self.layer.masksToBounds = false
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
//            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalToConstant: 90),
            imageView.widthAnchor.constraint(equalToConstant: 90),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            creatorLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            creatorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            creatorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            rsvpLabel.topAnchor.constraint(equalTo: creatorLabel.bottomAnchor, constant: 10),
            rsvpLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            rsvpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

