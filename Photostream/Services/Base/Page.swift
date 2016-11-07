//
//  Page.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol Constructable {
    
    init()
}

struct Page<O: Constructable, L: Constructable> {
    
    var offset: O = O()
    var limit: L = L()
}
