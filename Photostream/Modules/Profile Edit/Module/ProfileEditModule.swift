//
//  ProfileEditModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol ProfileEditModuleInterface: BaseModuleInterface {
    
    var displayItemCount: Int { get }
    var updateData: ProfileEditData! { get }
    
    func viewDidLoad()
    
    func uploadAvatar(with image: UIImage)
    func updateProfile()
    
    func displayItem(at index: Int) -> ProfileEditDisplayItem?
    func updateDisplayItem(with text: String, at index: Int)
}

protocol ProfileEditDelegate: BaseModuleDelegate {
    
    func profileEditDidUpdate(data: ProfileEditData)
}

protocol ProfileEditBuilder: BaseModuleBuilder {
    
    func build(root: RootWireframe?, data: ProfileEditData, delegate: ProfileEditDelegate?)
}

class ProfileEditModule: BaseModule, BaseModuleInteractable {
    
    typealias ModuleView = ProfileEditScene
    typealias ModuleInteractor = ProfileEditInteractor
    typealias ModulePresenter = ProfileEditPresenter
    typealias ModuleWireframe = ProfileEditWireframe
    
    var view: ModuleView!
    var interactor: ModuleInteractor!
    var presenter: ModulePresenter!
    var wireframe: ModuleWireframe!
    
    required init(view: ModuleView) {
        self.view = view
    }
}

extension ProfileEditModule: ProfileEditBuilder {
    
    func build(root: RootWireframe?) {
        let auth = AuthSession()
        let userService = UserServiceProvider(session: auth)
        let fileService = FileServiceProvider(session: auth)
        
        interactor = ProfileEditInteractor(userService: userService, fileService: fileService)
        presenter = ProfileEditPresenter()
        wireframe = ProfileEditWireframe(root: root)
        
        view.presenter = presenter
        interactor.output = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = wireframe
    }
    
    func build(root: RootWireframe?, data: ProfileEditData, delegate: ProfileEditDelegate? = nil) {
        build(root: root)
        presenter.updateData = data
        presenter.delegate = delegate
    }
}
