//
//  HomeViewInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol HomeViewInterface: class {

    var controller: UIViewController? { get }
    var presenter: HomePresenterInterface! { set get }
}
