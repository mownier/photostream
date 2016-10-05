//
//  UserProfileInteractorOutput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 26/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol UserProfileInteractorOutput {

    func userProfileDidFetchOk(_ data: UserProfileData)
    func userProfileDidFetchWithError(_ error: NSError)
    func userProfileDidFetchPostsOk(_ data: UserProfilePostDataList)
    func userProfileDidFetchPostsWithError(_ error: NSError)
}
