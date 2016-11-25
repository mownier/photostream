//
//  PhotoLibraryInteractorInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol PhotoLibraryInteractorInterface: class {

    var output: PhotoLibraryInteractorOutput? { set get }
    var service: AssetService! { set get }
    
    init(service: AssetService)
}
