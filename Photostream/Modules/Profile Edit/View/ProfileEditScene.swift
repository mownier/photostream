//
//  ProfileEditScene.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol ProfileEditScene: BaseModuleView {

    var presenter: ProfileEditModuleInterface! { set get }
    
    func didUpdate(with error: String?)
    func didUpload(with error: String?)
    func didUpload(with progress: Progress)
}
