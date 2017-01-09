//
//  ProfileEditViewDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

extension ProfileEditViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let style = cellStyle(for: indexPath.row)
        
        switch style {
            
        case .default:
            let item = presenter.displayItem(at: indexPath.row) as? ProfileEditTableCellItem
            styleDefaultPrototype.configure(with: item, isPrototype: true)
            return styleDefaultPrototype.dynamicHeight
            
        case .lineEdit:
            let item = presenter.displayItem(at: indexPath.row) as? ProfileEditTableCellItem
            styleLineEditPrototype.configure(with: item, isPrototype: true)
            return styleLineEditPrototype.dynamicHeight
        }
    }
}

extension ProfileEditViewController: ProfileEditHeaderViewDelegate {
    
    func didTapToChangeAvatar() {
        
    }
}

extension ProfileEditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
