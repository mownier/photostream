//
//  UserProfileInteractorOutput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 26/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol UserProfileInteractorOutput {

    func userProfileDidFetchOk(data: UserProfileData)
    func userProfileDidFetchWithError(error: NSError)
    func userProfileDidFetchPostsOk(data: UserProfilePostDataList)
    func userProfileDidFetchPostsWithError(error: NSError)
}
