//
//  BaseModulePresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 24/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol BaseModulePresenter: BaseModuleInteractorOutput, BaseModuleInterface {

    var view: BaseModuleView! { set get }
    var interactor: BaseModuleInteractorInput? { set get }
    var wireframe: BaseModuleWireframe! { set get }
}
