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
    
    func uploadJPEGImage(data: FileServiceUploadData, width: Float, height: Float, callback: ((FileServiceResult) -> Void)?)
}

struct FileServiceUploadData {
    
    var id: String = ""
    var data: Data?
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
    
    var messsage: String {
        switch self {
        case .authenticationNotFound(let message),
             .failedToUpload(let message),
             .noDataToUpload(let message):
            return message
        }
    }
}
