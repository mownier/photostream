//
//  ProfileEditModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

extension ProfileEditModule {
    
    convenience init() {
        self.init(view: ProfileEditViewController())
    }
}

extension ProfileEditDataItem: ProfileEditHeaderViewItem {
    
    var displayNameInitial: String {
        if !username.isEmpty {
            return username[0]
        
        } else if !firstName.isEmpty {
            return firstName[0]
            
        } else {
            return "U"
        }
    }
}

extension ProfileEditDisplayItem: ProfileEditTableCellItem {
    
    var infoLabelText: String {
        return type.labelText
    }
}

extension ProfileEditModuleInterface {
    
    func presentPhotoLibrary() {
        guard let presenter = self as? ProfileEditPresenter else {
            return
        }
        
        let controller = presenter.view.controller
        presenter.wireframe.showPhotoLibrary(parent: controller, delegate: presenter)
    }
}

extension ProfileEditWireframeInterface {
    
    func showPhotoLibrary(parent: UIViewController?, delegate: PhotoLibraryModuleDelegate) {
        let nav = PhotoLibraryWireframe.createNavigationController()
        let view = nav.topViewController as! PhotoLibraryViewController
        view.style = .style2
        let wireframe = PhotoLibraryWireframe(root: root as? RootWireframeInterface, delegate: delegate, view: view)
        wireframe.present(with: nav, from: parent, animated: true, completion: nil)
    }
}

extension ProfileEditPresenter: PhotoLibraryModuleDelegate {
    
    func photoLibraryDidPick(with image: UIImage?) {
        
    }
    
    func photoLibraryDidCancel() {
        
    }
}


