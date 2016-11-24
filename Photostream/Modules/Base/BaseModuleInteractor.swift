//
//  BaseModuleInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 24/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol BaseModuleInteractor: BaseModuleInteractorInput {

    var output: BaseModuleInteractorOutput? { set get }
}
