//
//  UserPostModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

enum UserPostSceneType {
    case grid
    case list
}

extension UserPostModule {
    
    convenience init(sceneType: UserPostSceneType) {
        switch sceneType {
        case .grid:
            self.init(view: UserPostGridViewController())
        case .list:
            self.init(view: UserPostListViewController())
        }
    }
}

extension UserPostDataItem: PostGridCollectionCellItem { }
