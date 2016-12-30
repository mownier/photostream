//
//  FileService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol FileService {

    init(session: AuthSession)
    
    func uploadJPEGImage(data: FileServiceImageUploadData, track: ((Progress?) -> Void)?, callback: ((FileServiceResult) -> Void)?)
    
    func uploadAvatarImage(data: FileServiceImageUploadData, track: ((Progress?) -> Void)?, callback: ((FileServiceResult) -> Void)?)
}

protocol FileServiceUploadData {
    
    var id: String? { set get }
    var data: Data? { set get }
}

struct FileServiceImageUploadData: FileServiceUploadData {
    
    var id: String?
    var data: Data?
    var width: Float = 0
    var height: Float = 0
}

struct FileServiceResult {
    
    var uploadId: String?
    var fileId: String?
    var fileUrl: String?
    var error: FileServiceError?
}

enum FileServiceError: Error {
    
    case authenticationNotFound(message: String)
    case failedToUpload(message: String)
    case noDataToUpload(message: String)
    
    var message: String {
        switch self {
        case .authenticationNotFound(let message),
             .failedToUpload(let message),
             .noDataToUpload(let message):
            return message
        }
    }
}
