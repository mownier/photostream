//
//  PostComposerModuleDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PostComposerModuleDelegate: class {
    
    func postComposerDidFinishWriting(with image: UIImage, content: String)
    func postComposerDidCancelWriting()
}
