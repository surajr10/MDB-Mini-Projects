//
//  AuthProvider.swift
//  MDB Social
//
//  Created by Michael Lin on 2/25/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FIRAuthProvider {
    
    static let shared = FIRAuthProvider()
    
    let auth = Auth.auth()
    
    enum SignInErrors: Error {
        case wrongPassword
        case userNotFound
        case invalidEmail
        case internalError
        case errorFetchingUserDoc
        case errorDecodingUserDoc
        case unspecified
    }
    
    enum SignUpErrors: Error {
        case emailAlreadyInUse
        case weakPassword
        case missingEmail
        case internalError
        case unspecified
        case errorFetchingUserDoc
        case errorDecodingUserDoc
    }
    
    let db = Firestore.firestore()
    
    var currentUser: User?
    
    private var userListener: ListenerRegistration?
    
    init() {
        guard let user = auth.currentUser else { return }
        
        linkUser(withuid: user.uid, completion: nil)
    }
    
    func signIn(withEmail email: String, password: String,
                completion: ((Result<User, SignInErrors>)->Void)?) {
        
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                let nsError = error as NSError
                let errorCode = FirebaseAuth.AuthErrorCode(rawValue: nsError.code)
                
                switch errorCode {
                case .wrongPassword:
                    completion?(.failure(.wrongPassword))
                case .userNotFound:
                    completion?(.failure(.userNotFound))
                case .invalidEmail:
                    completion?(.failure(.invalidEmail))
                default:
                    completion?(.failure(.unspecified))
                }
                return
            }
            
            guard let authResult = authResult else {
                completion?(.failure(.internalError))
                return
            }
            
            self?.linkUser(withuid: authResult.user.uid, completion: completion)
        }
    }
    
    /* TODO: Firebase sign up handler, add user to firestore */
    
    func signUp(withEmail email: String, withName name: String, withUsername username: String, withPassword password: String, completion: ((Result<User, SignUpErrors>)->Void)?) {
        
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                let nsError = error as NSError
                let errorCode = FirebaseAuth.AuthErrorCode(rawValue: nsError.code)
                
                switch errorCode {
                case .emailAlreadyInUse:
                    completion?(.failure(.emailAlreadyInUse))
                case .weakPassword:
                    completion?(.failure(.weakPassword))
                case .missingEmail:
                    completion?(.failure(.missingEmail))
                default:
                    completion?(.failure(.unspecified))
                }
                return
            }
            
            guard let authResult = authResult else {
                completion?(.failure(.internalError))
                return
            }
            let user: User = User(uid: authResult.user.uid, username: username, email: email, fullname: name, savedEvents: [])
            FIRDatabaseRequest.shared.setUser(user, completion: nil)
            self?.linkUserSignUp(withuid: authResult.user.uid, completion: completion)
        }
    }
    
    func isSignedIn() -> Bool {
        return auth.currentUser != nil
    }
    
    func signOut(completion: (()->Void)? = nil) {
        do {
            try auth.signOut()
            unlinkCurrentUser()
            completion?()
        } catch { }
    }
    
    private func linkUser(withuid uid: String,
                          completion: ((Result<User, SignInErrors>)->Void)?) {
        
        userListener = db.collection("users").document(uid).addSnapshotListener { [weak self] docSnapshot, error in
            guard let document = docSnapshot else {
                completion?(.failure(.errorFetchingUserDoc))
                return
            }
            guard let user = try? document.data(as: User.self) else {
                completion?(.failure(.errorDecodingUserDoc))
                return
            }
            
            self?.currentUser = user
            completion?(.success(user))
        }
    }
    
    private func linkUserSignUp(withuid uid: String,
                          completion: ((Result<User, SignUpErrors>)->Void)?) {
        
        userListener = db.collection("users").document(uid).addSnapshotListener { [weak self] docSnapshot, error in
            guard let document = docSnapshot else {
                completion?(.failure(.errorFetchingUserDoc))
                return
            }
            guard let user = try? document.data(as: User.self) else {
                completion?(.failure(.errorDecodingUserDoc))
                return
            }
            
            self?.currentUser = user
            completion?(.success(user))
        }
    }
    
    
    private func unlinkCurrentUser() {
        userListener?.remove()
        currentUser = nil
    }
}
