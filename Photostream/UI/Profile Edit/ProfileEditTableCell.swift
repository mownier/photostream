//
//  ProfileEditTableCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

enum ProfileEditTableCellStyle {
    case `default`
    case lineEdit
    
    var reuseId: String {
        switch self {
            
        case .default:
            return "ProfileEditTableCellDefault"
            
        case .lineEdit:
            return "ProfileEditTableCellLineEdit"
        }
    }
}

class ProfileEditTableCell: UITableViewCell {

    var style: ProfileEditTableCellStyle = .default
    
    var infoLabel: UILabel!
    var infoDetailLabel: UILabel?
    var infoTextField: UITextField?
    
    init(style: ProfileEditTableCellStyle) {
        super.init(style: .default, reuseIdentifier: style.reuseId)
        self.style = style
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    func initSetup() {
        infoLabel = UILabel()
        infoLabel.textColor = UIColor.lightGray
        infoLabel.font = UIFont.systemFont(ofSize: 10)
        addSubview(infoLabel)
        
        switch style {
            
        case .default:
            infoDetailLabel = UILabel()
            infoDetailLabel!.font = UIFont.systemFont(ofSize: 14)
            infoDetailLabel!.numberOfLines = 0
            addSubview(infoDetailLabel!)
            
        case .lineEdit:
            infoTextField = UITextField()
            infoTextField!.font = UIFont.systemFont(ofSize: 14)
            addSubview(infoTextField!)
        }
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        
        infoLabel.sizeToFit()
        rect.origin.x = spacing * 2
        rect.origin.y = spacing * 2
        rect.size.width = frame.width - (spacing * 4)
        rect.size.height = infoLabel.frame.height
        infoLabel.frame = rect
        
        switch style {
        
        case .default:
            infoDetailLabel!.sizeToFit()
            rect.origin.y = rect.maxY
            
            if infoDetailLabel!.text == nil || infoDetailLabel!.text!.isEmpty {
                rect.size.height = infoDetailLabel!.font!.pointSize
                rect.size.height += (spacing * 2)
                
            } else {
                rect.size.height = infoDetailLabel!.frame.height
            }
            
            infoDetailLabel!.frame = rect
            
        case .lineEdit:
            rect.origin.y = rect.maxY
            rect.size.height = infoTextField!.font!.pointSize + (spacing * 2)
            infoTextField!.frame = rect
        }
    }
}

extension ProfileEditTableCell {
    
    var spacing: CGFloat {
        return 4.0
    }
}

extension ProfileEditTableCell {
    
    class func dequeue(from tableView: UITableView, style: ProfileEditTableCellStyle) -> ProfileEditTableCell? {
        var cell = tableView.dequeueReusableCell(withIdentifier: style.reuseId)
        if cell == nil {
            cell = ProfileEditTableCell(style: style)
        }
        return cell as? ProfileEditTableCell
    }
}
