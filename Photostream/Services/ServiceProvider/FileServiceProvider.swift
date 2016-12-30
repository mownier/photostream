//
//  FileServiceProvider.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

struct FileServiceProvider: FileService {

    var session: AuthSession

    init(session: AuthSession) {
        self.session = session
    }
    
    func uploadJPEGImage(data: FileServiceImageUploadData, track: ((Progress?) -> Void)?, callback: ((FileServiceResult) -> Void)?) {
        var result = FileServiceResult()
        result.uploadId = data.id
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found.")
            callback?(result)
            return
        }
        
        guard let imageData = data.data else {
            result.error = .noDataToUpload(message: "No data to upload.")
            callback?(result)
            return
        }
        
        let userId = session.user.id
        let storageRef = FIRStorage.storage().reference()
        let key = Date.timeIntervalSinceReferenceDate * 1000
        let imagePath = "\(userId)/posts/\(key).jpg"
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let task = storageRef.child(imagePath).put(imageData, metadata: metadata, completion: { (metadata, error) in
            guard error == nil else {
                result.error = .failedToUpload(message: "Failed upload JPEG image.")
                callback?(result)
                return
            }
            
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else {
                result.error = .failedToUpload(message: "Image URL does not exist.")
                callback?(result)
                return
            }
            
            let databaseRef = FIRDatabase.database().reference()
            let key = databaseRef.child("photos").childByAutoId().key
            let path = "photos/\(key)"
            let data: [String: AnyObject] = [
                "id": key as AnyObject,
                "uid": userId as AnyObject,
                "url": imageUrl as AnyObject,
                "height": data.height as AnyObject,
                "width": data.width as AnyObject ]
            databaseRef.child(path).setValue(data)
            
            result.fileId = key
            result.fileUrl = imageUrl
            callback?(result)
        })
        
        guard track != nil else {
            return
        }
        
        task.observe(.progress) { (snapshot) in
            track!(snapshot.progress)
        }
    }
    
    func uploadAvatarImage(data: FileServiceImageUploadData, track: ((Progress?) -> Void)?, callback: ((FileServiceResult) -> Void)?) {
        var result = FileServiceResult()
        result.uploadId = data.id
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found")
            callback?(result)
            return
        }
        
        guard let imageData = data.data else {
            result.error = .noDataToUpload(message: "No data to upload")
            callback?(result)
            return
        }
        
        let uid = session.user.id
        let storageRef = FIRStorage.storage().reference()
        
        let key = Date.timeIntervalSinceReferenceDate * 1000
        let imagePath = "\(uid)/avatar/\(key).jpg"
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let task = storageRef.child(imagePath).put(imageData, metadata: metadata, completion: { metadata, error in
            guard error == nil else {
                result.error = .failedToUpload(message: "Failed upload avatar image")
                callback?(result)
                return
            }
            
            guard let avatarUrl = metadata?.downloadURL()?.absoluteString else {
                result.error = .failedToUpload(message: "Avatar URL does not exist")
                callback?(result)
                return
            }
            
            result.fileUrl = avatarUrl
            callback?(result)
        })
        
        guard track != nil else {
            return
        }
        
        task.observe(.progress) { (snapshot) in
            track!(snapshot.progress)
        }
    }
}
