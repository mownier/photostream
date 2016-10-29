//
//  HomePresenterInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol HomePresenterInterface {

    var view: HomeViewInterface! { set get }
    var interactor: HomeInteractorInput? { set get }
    var wireframe: HomeWireframeInterface! { set get }
}
