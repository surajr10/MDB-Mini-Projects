//
//  EventDetailsVC.swift
//  MDB Social
//
//  Created by Suraj Rao on 4/7/21.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage

class EventDetailsVC: UIViewController {
    
    
    private let stack: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 25
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    
    var currEvent: Event? {
        didSet {
//            guard let event = event else {return}
            let gsReference: StorageReference = Storage.storage().reference(forURL: currEvent!.photoURL)
                        gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if let error = error {
                                print("Photo error occurred: \(error)")
                              } else {
                                self.imageView.image = UIImage(data: data!)
                              }
                        }
            nameLabel.text = currEvent!.name
            let docRef = FIRDatabaseRequest.shared.db.collection("users").document(currEvent!.creator)
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
            creatorLabel.text = currEvent!.creator
            rsvpLabel.text = String(currEvent!.rsvpUsers.count)
            descLabel.text = currEvent!.description
//            dateLabel.text = String(currEvent!.startDate)
            
            if (currEvent!.creator == currUser) {
                isCreator = true
            }
            
            for id in currEvent!.rsvpUsers {
                if (id == currUser) {
                    isRsvpd = true
                }
            }
            
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
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let rsvpButton: UIButton = {
        let btn = UIButton()
//        btn.setTitle("RSVP", for: .normal)
        btn.backgroundColor = .red
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private let deleteButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Delete event", for: .normal)
        btn.backgroundColor = .red
        btn.isHidden = true
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    
    private let contentEdgeInset = UIEdgeInsets(top: 80, left: 25, bottom: 30, right: 25)
    
    private let currUser = FIRAuthProvider.shared.currentUser!.uid
    
    
    private var isCreator: Bool = false
    private var isRsvpd: Bool = false
    
    
    
    
    override func viewDidLoad() {
        
        
        view.backgroundColor = .background
        
        if (isRsvpd) {
            rsvpButton.setTitle("Cancel RSVP", for: .normal)
        } else {
            rsvpButton.setTitle("RSVP", for: .normal)
        }
        
        if (isCreator) {
            deleteButton.isHidden = false
        }
        
        deleteButton.addTarget(self, action: #selector(didTapDelete(_:)), for: .touchUpInside)
        
        rsvpButton.addTarget(self, action: #selector(didTapRSVP(_:)), for: .touchUpInside)
        
        view.addSubview(stack)
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(creatorLabel)
        stack.addArrangedSubview(descLabel)
//        stack.addArrangedSubview(dateLabel)
        stack.addArrangedSubview(rsvpLabel)
        stack.addArrangedSubview(rsvpButton)
        stack.addArrangedSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: contentEdgeInset.left),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: -contentEdgeInset.right),
            stack.topAnchor.constraint(equalTo: view.topAnchor,
                                       constant: contentEdgeInset.top),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        
        
        
        
    }
    
    
    
    @objc func didTapRSVP(_ sender: UIButton) {
        let event = FIRDatabaseRequest.shared.db.collection("events").document(currEvent!.id!)
        let currUser = FIRAuthProvider.shared.currentUser!.uid
        
        if (isRsvpd) {
            isRsvpd = false
            for i in 0..<currEvent!.rsvpUsers.count {
                if currEvent!.rsvpUsers[i] == currUser {
                    event.updateData([
                        "rsvpUsers": FieldValue.arrayRemove([currEvent!.rsvpUsers[i]])
                    ]) {err in
                        if let err = err {
                            print("Error updating event: \(err)")
                        } else {
                            print("Event successfully updated")
                        }
                    }
                    currEvent!.rsvpUsers.remove(at: i)
                    break
                }
            }
            rsvpButton.setTitle("RSVP", for: .normal)
        } else {
            
            isRsvpd = true
            event.updateData([
                "rsvpUsers": FieldValue.arrayUnion([currUser])
            ]) {err in
                if let err = err {
                    print("Error updating event: \(err)")
                } else {
                    print("Event successfully updated")
                }
            }
            
            currEvent!.rsvpUsers.append(currUser!)
            rsvpButton.setTitle("Cancel RSVP", for: .normal)
        }
        
        
        
    }
    
    @objc func didTapDelete(_ sender: UIButton) {
        
        let delEvent = FIRDatabaseRequest.shared.db.collection("events").document(currEvent!.id!)
        delEvent.delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed")
            }
        }
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
}
