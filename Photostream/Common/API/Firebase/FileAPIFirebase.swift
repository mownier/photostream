//
//  FileAPIFirebase.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class FileAPIFirebase: FileService {

    var session: AuthSession!
    
    required init(session: AuthSession!) {
        self.session = session
    }
    
    func uploadImage(image: UIImage!, callback: FileServiceCallback!) {
        if let error = isOK() {
            callback(nil, error)
        } else {
            let userId = session.user.id
            let storageRef = FIRStorage.storage().reference()
            let key = Int(NSDate.timeIntervalSinceReferenceDate() * 1000)
            let imagePath = "\(userId)/posts/\(key).jpg"
            let imageData = UIImageJPEGRepresentation(image, 1.0)
            
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            storageRef.child(imagePath).putData(imageData!, metadata: metadata, completion: { (metadata, error) in
                if let error = error {
                    callback(nil, error)
                } else {
                    if let imageUrl = metadata?.downloadURL()?.absoluteString {
                        let width = image.size.width
                        let height = image.size.height
                        let databaseRef = FIRDatabase.database().reference()
                        let key = databaseRef.child("photos").childByAutoId().key
                        let path = "photos/\(key)"
                        let data: [String: AnyObject] = ["id": key, "uid": userId, "url": imageUrl, "height": height, "width": width]
                        databaseRef.child(path).setValue(data)
                        callback(key, nil)
                    } else {
                        callback(nil, NSError(domain: "FileAPIFirebase", code: 0, userInfo: ["message": "No download url."]))
                    }
                }
            })
        }
    }
    
    func isOK() -> NSError? {
        if session.isValid() {
            return nil
        } else {
            if session.isValid() {
                return nil
            } else {
                return NSError(domain: "FileAPIFirebase", code: 0, userInfo: ["message": "No authenticated user."])
            }
        }
    }
}
