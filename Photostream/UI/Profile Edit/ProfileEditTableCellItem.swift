//
//  ProfileEditTableCellItem.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol ProfileEditTableCellItem {

    var infoLabelText: String { get }
    var infoEditText: String { get }
}

protocol ProfileEditTableCellConfig {
    
    var dynamicHeight: CGFloat { get }
    func configure(with item: ProfileEditTableCellItem?, isPrototype: Bool)
}

extension ProfileEditTableCell: ProfileEditTableCellConfig {
    
    var dynamicHeight: CGFloat {
        switch style {
        
        case .default:
            return infoDetailLabel!.frame.maxY + (spacing * 2)
        
        case .lineEdit:
            return infoTextField!.frame.maxY + (spacing * 2)
        }
    }
    
    func configure(with item: ProfileEditTableCellItem?, isPrototype: Bool = false) {
        guard let item = item else {
            return
        }
        
        infoLabel.text = item.infoLabelText
        
        switch style {
        
        case .default:
            infoDetailLabel!.text = item.infoEditText
        
        case .lineEdit:
            infoTextField!.text = item.infoEditText
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}
