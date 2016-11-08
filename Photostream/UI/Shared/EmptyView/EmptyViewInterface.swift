//
//  EmptyViewInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 08/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol EmptyViewInterface: class {

    var titleLabel: UILabel? { set get }
    var subtitleLabel: UILabel? { set get }
    var imageView: UIImageView? { set get }
    var actionButton: UIButton? { set get }
    var actionHandler: (EmptyViewInterface)? { set get }
}
