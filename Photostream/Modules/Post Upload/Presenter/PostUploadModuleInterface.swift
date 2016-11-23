//
//  PostUploadModuleInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol PostUploadModuleInterface: class {
    
    func upload()
    
    func willShowImage()
    
    func detach()
}
