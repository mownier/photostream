//
//  SnapshotParser.swift
//  Photostream
//
//  Created by Mounir Ybanez on 08/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import Firebase

protocol SnapshotParser {
    
    init(with snapshot: FIRDataSnapshot, exception: String...)
}
