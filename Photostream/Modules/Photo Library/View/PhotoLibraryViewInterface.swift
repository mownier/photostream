//
//  PhotoLibraryViewInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PhotoLibraryViewInterface: class {

    var controller: UIViewController? { get }
    var presenter: PhotoLibraryModuleInterface! { set get }
    
    func reloadView()
    func didFetchPhotos()
    func showSelectedPhoto(with image: UIImage?)
    func showSelectedPhotoInFillMode(animated: Bool)
    func showSelectedPhotoInFitMode(animated: Bool)
}
