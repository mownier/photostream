//
//  PostComposerModuleInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol PostComposerModuleInterface: class {

    func cancelWriting()
    func doneWriting()
}
