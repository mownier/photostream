//
//  ProfileEditInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol ProfileEditInteractorOutput: BaseModuleInteractorOutput {
    
    func didUpdate(data: ProfileEditData)
    func didUpdate(error: UserServiceError)
    
    func didUploadAvatar(progress: Progress)
    func didUplaodAvatar(url: String)
    func didUplaodAvatar(error: FileServiceError)
}

protocol ProfileEditInteractorInput: BaseModuleInteractorInput {
    
    func updateProfile(data: UserServiceProfileEditData)
    func uploadAvatar(data: FileServiceImageUploadData)
}

protocol ProfileEditInteractorInterface: BaseModuleInteractor {
    
    var userService: UserService! { set get }
    var fileService: FileService! { set get }
    
    init(userService: UserService, fileService: FileService)
}

class ProfileEditInteractor: ProfileEditInteractorInterface {

    typealias Output = ProfileEditInteractorOutput
    
    weak var output: ProfileEditInteractorOutput?
    
    var userService: UserService!
    var fileService: FileService!
    
    required init(userService: UserService, fileService: FileService) {
        self.userService = userService
        self.fileService = fileService
    }
}

extension ProfileEditInteractor: ProfileEditInteractorInput {
    
    func updateProfile(data: UserServiceProfileEditData) {
        userService.editProfile(data: data) { [weak self] result in
            guard result.error == nil else {
                self?.output?.didUpdate(error: result.error!)
                return
            }
            
            guard let editData = result.editData else {
                let error: UserServiceError = .failedToEditProfile(message: "Result data not found")
                self?.output?.didUpdate(error: error)
                return
            }
            
            var data = ProfileEditDataItem()
            data.avatarUrl = editData.avatarUrl
            data.bio = editData.bio
            data.firstName = editData.firstName
            data.lastName = editData.lastName
            data.username = editData.username
            
            self?.output?.didUpdate(data: data)
        }
    }
    
    func uploadAvatar(data: FileServiceImageUploadData) {
        fileService.uploadAvatarImage(data: data, track: { [weak self] progress in
            guard progress != nil else {
                return
            }
            
            self?.output?.didUploadAvatar(progress: progress!)
            
        }) { [weak self] result in
            guard result.error == nil else {
                self?.output?.didUplaodAvatar(error: result.error!)
                return
            }
            
            guard result.fileUrl != nil else {
                let error: FileServiceError = .failedToUpload(message: "Uploaded avatar url not found")
                self?.output?.didUplaodAvatar(error: error)
                return
            }
            
            self?.output?.didUplaodAvatar(url: result.fileUrl!)
        }
    }
}
