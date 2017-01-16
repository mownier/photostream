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
    
    func presentBioEditor(defaultText: String) {
        guard let presenter = self as? ProfileEditPresenter else {
            return
        }
        
        let controller = presenter.view.controller
        presenter.wireframe.showBioEditor(parent: controller, defaultText: defaultText, delegate: presenter)
    }
    
    func selectDisplayItem(at index: Int) {
        guard let item = displayItem(at: index), !item.isEditable else {
            return
        }
        
        switch item.type {
        
        case .bio:
            presentBioEditor(defaultText: item.infoEditText)
        
        default:
            break
        }
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
    
    func showBioEditor(parent: UIViewController?, defaultText: String, delegate: MultilineEditorDelegate) {
        let module = MultilineEditorModule()
        module.build(root: root, defaultText: defaultText, delegate: delegate)
        
        var property = WireframeEntryProperty()
        property.controller = module.view.controller
        property.parent = parent
        
        module.wireframe.style = .push
        module.wireframe.enter(with: property)
    }
}

extension ProfileEditPresenter: PhotoLibraryModuleDelegate {
    
    func photoLibraryDidPick(with image: UIImage?) {
        guard let avatarImage = image else {
            return
        }
        
        view.willUpload(image: avatarImage)
        uploadAvatar(with: avatarImage)
    }
    
    func photoLibraryDidCancel() {
        
    }
}

extension ProfileEditPresenter: MultilineEditorDelegate {
    
    func multilineEditorDidCancel() {
        
    }
    
    func multilineEditorDidSave(text: String) {
        guard let index = displayItems.index(where: { item -> Bool in
            return item.type == .bio
        }), var item = displayItem(at: index) else {
            return
        }
    
        item.infoEditText = text
        displayItems[index] = item
        
        view.reloadDisplayItem(at: index)
    }
}
