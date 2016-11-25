//
//  PostUploadItem.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

struct PostUploadItem {
    
    var image: UIImage!
    var content: String!
    
    var imageData: FileServiceImageUploadData {
        var data = FileServiceImageUploadData()
        data.data = UIImageJPEGRepresentation(image, 1.0)
        data.width = Float(image.size.width)
        data.height = Float(image.size.height)
        return data
    }
}
