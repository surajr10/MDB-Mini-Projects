//
//  FIRStorage.swift
//  MDB Social
//
//  Created by Suraj Rao on 4/7/21.
//

import Foundation
import FirebaseStorage

class FIRStorage {
    
    static let shared = FIRStorage()
    
    let storage = Storage.storage()
    
    let metadata: StorageMetadata = {
            let newMetadata = StorageMetadata()
            newMetadata.contentType = "image/jpeg"
            return newMetadata
        }()
    
    
}
