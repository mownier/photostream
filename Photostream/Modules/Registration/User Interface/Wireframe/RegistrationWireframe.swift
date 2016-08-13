//
//  RegistrationWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class RegistrationWireframe: AnyObject {

    weak var registrationViewController: RegistrationViewController!
    var registrationPresenter: RegistrationPresenter!
    
    init() {
        self.registrationPresenter = RegistrationPresenter()
    }
    
    func navigateRegistrationInterfaceFromViewController(controller: UIViewController) {
        // TODO: Present registration interface
    }
}
