//
//  PhotoShareModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 18/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PhotoShareWireframe {

    class func createViewController() -> PhotoShareViewController {
        let sb = UIStoryboard(name: "PhotoShareModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PhotoShareViewController")
        return vc as! PhotoShareViewController
    }
}
