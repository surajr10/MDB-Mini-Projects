//
//  FIRDatabaseRequest.swift
//  MDB Social
//
//  Created by Michael Lin on 2/25/21.
//

import Foundation
import FirebaseFirestore

class FIRDatabaseRequest {
    
    static let shared = FIRDatabaseRequest()
    
    let db = Firestore.firestore()
    
    func setUser(_ user: User, completion: (()->Void)?) {
        guard let uid = user.uid else { return }
        do {
            try db.collection("users").document(uid).setData(from: user)
            completion?()
        }
        catch { }
    }
    
    func setEvent(_ event: Event, completion: (()->Void)?) {
        guard let id = event.id else { return }
        
        do {
            try db.collection("events").document(id).setData(from: event)
            completion?()
        } catch { }
    }
    
    func getEvents(vc: FeedVC)->[Event] {
        var events: [Event] = []
        let listener = db.collection("events").order(by: "startTimeStamp", descending: true).addSnapshotListener{ querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            for document in documents {
                guard let event = try? document.data(as: Event.self) else {
                    print("Document couldn't be converted to event")
                    return
                }
                events.append(event)
            }
            vc.updateEvents(newEvents: events)
        }
        return events
    }
    /* TODO: Events getter */
}
