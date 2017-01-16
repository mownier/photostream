//
//  ProfileEditScene.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol ProfileEditScene: BaseModuleView {

    var presenter: ProfileEditModuleInterface! { set get }
    var isSavingViewHidden: Bool { set get }
    
    func didUpdate(with error: String?)
    func didUpload(with error: String?)
    func didUploadWith(progress: Progress)
    
    func willUpload(image: UIImage)
    
    func showProfile(with data: ProfileEditData)
    
    func reloadDisplayItem(at index: Int)
}
