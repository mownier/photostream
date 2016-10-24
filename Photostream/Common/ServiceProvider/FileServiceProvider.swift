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

class FileServiceProvider: FileService {

    var session: AuthSession

    required init(session: AuthSession) {
        self.session = session
    }
    
    func uploadJPEGImage(data: FileServiceUploadData, width: Float, height: Float, callback: ((FileServiceResult) -> Void)?) {
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
        let key = Int(Date.timeIntervalSinceReferenceDate * 1000)
        let imagePath = "\(userId)/posts/\(key).jpg"
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.child(imagePath).put(imageData, metadata: metadata, completion: { (metadata, error) in
            guard error != nil else {
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
                "height": height as AnyObject,
                "width": width as AnyObject ]
            databaseRef.child(path).setValue(data)
            
            result.fileId = key
            result.fileUrl = imageUrl
            callback?(result)
        })
    }
}
