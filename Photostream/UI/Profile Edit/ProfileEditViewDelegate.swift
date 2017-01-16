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
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        guard let cell = cell as? ProfileEditTableCell,
            let item = presenter.displayItem(at: index), item.isEditable else {
            return
        }
        
        let style = cellStyle(for: index)
        var text = ""
        
        switch style {
        
        case .default:
            text = cell.infoDetailLabel!.text ?? text
        
        case .lineEdit:
            text = cell.infoTextField!.text ?? text
        }
        
        if !text.isEmpty {
            presenter.updateDisplayItem(with: text, at: index)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectDisplayItem(at: indexPath.row)
    }
}

extension ProfileEditViewController: ProfileEditHeaderViewDelegate {
    
    func didTapToChangeAvatar() {
        presenter.presentPhotoLibrary()
    }
}

extension ProfileEditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cell = textField.superview as? ProfileEditTableCell,
            let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let text = textField.text ?? ""
        presenter.updateDisplayItem(with: text, at: indexPath.row)
    }
}
