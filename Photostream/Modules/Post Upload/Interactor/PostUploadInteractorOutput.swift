//
//  PostUploadInteractorOutput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol PostUploadInteractorOutput: class {

    func didSucceed(with post: Post, and user: User)
    func didFail(with message: String)
    func didUpdate(with progress: Progress)
}
