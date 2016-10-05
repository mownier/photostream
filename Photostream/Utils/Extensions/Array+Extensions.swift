//
//  Array+Extensions.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension Array {

    func isValid(_ index: Int) -> Bool {
        return index >= 0 && index < count
    }
}
