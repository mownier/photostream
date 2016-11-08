//
//  Photo.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import Firebase

struct Photo {

    var url: String
    var width: Int
    var height: Int

    init() {
        url = ""
        width = 0
        height = 0
    }
}

extension Photo: SnapshotParser {
    
    init(with snapshot: FIRDataSnapshot, exception: String...) {
        self.init()
        
        if snapshot.hasChild("url") && !exception.contains("url") {
            url = snapshot.childSnapshot(forPath: "url").value as! String
        }
        
        if snapshot.hasChild("width") && !exception.contains("width") {
            width = snapshot.childSnapshot(forPath: "width").value as! Int
        }
        
        if snapshot.hasChild("height") && !exception.contains("height") {
            height = snapshot.childSnapshot(forPath: "height").value as! Int
        }
    }
}
