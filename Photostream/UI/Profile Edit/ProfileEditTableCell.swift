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
    
    convenience init(style: ProfileEditTableCellStyle) {
        self.init(style: .default, reuseIdentifier: style.reuseId)
        self.style = style
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    func initSetup() {
        infoLabel = UILabel()
        infoLabel.textColor = UIColor.lightGray
        infoLabel.font = UIFont.systemFont(ofSize: 8)
        addSubview(infoLabel)
        
        switch style {
            
        case .default:
            infoDetailLabel = UILabel()
            infoDetailLabel!.font = UIFont.systemFont(ofSize: 14)
            addSubview(infoDetailLabel!)
            
        case .lineEdit:
            infoTextField = UITextField()
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
            rect.origin.y = rect.maxY + spacing
            rect.size.height = infoDetailLabel!.frame.height
            infoLabel.frame = rect
            
        case .lineEdit:
            rect.origin.y = rect.maxY + spacing
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
        let cell = tableView.dequeueReusableCell(withIdentifier: style.reuseId)
        return cell as? ProfileEditTableCell
    }
    
    class func register(in tableView: UITableView, style: ProfileEditTableCellStyle) {
        tableView.register(self, forCellReuseIdentifier: style.reuseId)
    }
}
