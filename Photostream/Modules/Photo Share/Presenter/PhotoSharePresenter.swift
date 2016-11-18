//
//  PhotoSharePresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 18/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PhotoSharePresenter: PhotoSharePresenterInterface {

    weak var view: PhotoShareViewInterface!
    var wireframe: PhotoShareWireframeInterface!
}

extension PhotoSharePresenter: PhotoShareModuleInterface {
    
}
