//
//  FileService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

typealias FileServiceCallback = (String?, NSError?) -> Void

protocol FileService: class {

    init(session: AuthSession!)
    func uploadImage(image: UIImage!, callback: FileServiceCallback!)
}
