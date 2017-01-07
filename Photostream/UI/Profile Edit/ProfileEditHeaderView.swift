//
//  ProfileEditHeaderView.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol ProfileEditHeaderViewDelegate: class {
    
    func didTapToChangeAvatar()
}

class ProfileEditHeaderView: UIView {
    
    weak var delegate: ProfileEditHeaderViewDelegate?
    
    var avatarImageView: UIImageView!
    var avatarButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    func initSetup() {
        frame.size.height = 128
        
        avatarImageView = UIImageView()
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.cornerRadius = avatarDimension / 2
        
        avatarButton = UIButton(type: .system)
        avatarButton.addTarget(self, action: #selector(self.didTapAvatarButton), for: .touchUpInside)
        avatarButton.setTitle("Change Avatar", for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapAvatarButton))
        tap.numberOfTapsRequired = 1
        avatarImageView.addGestureRecognizer(tap)
        
        addSubview(avatarImageView)
        addSubview(avatarButton)
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        
        avatarButton.sizeToFit()
        
        rect.origin.x = (frame.width - avatarDimension) / 2
        rect.origin.y = (frame.height - avatarDimension) / 2
        rect.origin.y -= avatarButton.frame.height
        rect.size.width = avatarDimension
        rect.size.height = avatarDimension
        avatarImageView.frame = rect
        
        rect.size = avatarButton.frame.size
        rect.origin.x = (frame.width - rect.size.width) / 2
        rect.origin.y = rect.maxY
        avatarButton.frame = rect
    }
    
    func didTapAvatarButton() {
        delegate?.didTapToChangeAvatar()
    }
}

extension ProfileEditHeaderView {
    
    var fixHeight: CGFloat {
        return 128
    }
    
    var avatarDimension: CGFloat {
        return 64
    }
}


