//
//  ProfileEditPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol ProfileEditPresenterInterface: BaseModulePresenter, BaseModuleInteractable, BaseModuleDelegatable {
    
    var newAvatarUrl: String! { set get }
    var updateData: ProfileEditData! { set get }
    var displayItems: [ProfileEditDisplayItem] { set get }
}

class ProfileEditPresenter: ProfileEditPresenterInterface {

    typealias ModuleView = ProfileEditScene
    typealias ModuleInteractor = ProfileEditInteractorInput
    typealias ModuleWireframe = ProfileEditWireframeInterface
    typealias ModuleDelegate = ProfileEditDelegate
    
    weak var delegate: ModuleDelegate?
    weak var view: ModuleView!
    var interactor: ModuleInteractor!
    var wireframe: ModuleWireframe!
    
    var newAvatarUrl: String! = ""
    var displayItems = [ProfileEditDisplayItem]()
    var updateData: ProfileEditData! = ProfileEditDataItem() {
        didSet {
            displayItems.removeAll()
            
            var item = ProfileEditDisplayItem()
            
            item.type = .username
            item.infoEditText = updateData.username
            item.isEditable = true
            displayItems.append(item)
            
            item.type = .firstName
            item.infoEditText = updateData.firstName
            item.isEditable = true
            displayItems.append(item)
            
            item.type = .lastName
            item.infoEditText = updateData.lastName
            item.isEditable = true
            displayItems.append(item)
            
            item.type = .bio
            item.infoEditText = updateData.bio
            item.isEditable = false
            displayItems.append(item)
        }
    }
}

extension ProfileEditPresenter: ProfileEditModuleInterface {
    
    var displayItemCount: Int {
        return displayItems.count
    }
    
    func exit() {
        var property = WireframeExitProperty()
        property.controller = view.controller
        wireframe.exit(with: property)
    }
    
    func viewDidLoad() {
        view.showProfile(with: updateData)
    }
    
    func uploadAvatar(with image: UIImage) {
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        var uploadData = FileServiceImageUploadData()
        uploadData.data = imageData
        interactor.uploadAvatar(data: uploadData)
    }
    
    func updateProfile() {
        var editData = UserServiceProfileEditData()
        
        if !newAvatarUrl.isEmpty, newAvatarUrl != updateData.avatarUrl {
            editData.avatarUrl = newAvatarUrl
        }
        
        for item in displayItems {
            guard !item.infoEditText.isEmpty else {
                continue
            }
            
            let text = item.infoEditText
            
            switch item.type {
            
            case .username:
                if text != updateData.username {
                    editData.username = text
                }
                
            case .firstName:
                if text != updateData.firstName {
                    editData.firstName = text
                }
                
            case .lastName:
                if text != updateData.lastName {
                    editData.lastName = text
                }
                
            case .bio:
                if text != updateData.bio {
                    editData.bio = text
                }
            
            default:
                break
            }
        }
        
        view.isSavingViewHidden = false
        interactor.updateProfile(data: editData)
    }

    func displayItem(at index: Int) -> ProfileEditDisplayItem? {
        guard displayItems.isValid(index) else {
            return nil
        }
        
        return displayItems[index]
    }
    
    func updateDisplayItem(with text: String, at index: Int) {
        guard var item = displayItem(at: index) else {
            return
        }
        
        item.infoEditText = text
        displayItems[index] = item
    }
}

extension ProfileEditPresenter: ProfileEditInteractorOutput {
    
    func didUpdate(data: ProfileEditData) {
        view.isSavingViewHidden = true
        updateData = data
        view.didUpdate(with: nil)
        delegate?.profileEditDidUpdate(data: updateData)
    }
    
    func didUpdate(error: UserServiceError) {
        view.isSavingViewHidden = true
        view.didUpdate(with: error.message)
    }
    
    func didUplaodAvatar(url: String) {
        newAvatarUrl = url
        view.didUpload(with: nil)
    }
    
    func didUploadAvatar(progress: Progress) {
        view.didUploadWith(progress: progress)
    }
    
    func didUplaodAvatar(error: FileServiceError) {
        view.didUpload(with: error.message)
    }
}
