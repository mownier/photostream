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
    var progressView: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    func initSetup() {
        frame.size.height = fixHeight
        
        avatarImageView = UIImageView()
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.cornerRadius = avatarDimension / 2
        
        avatarButton = UIButton(type: .system)
        avatarButton.addTarget(self, action: #selector(self.didTapAvatarButton), for: .touchUpInside)
        avatarButton.setTitle("Change Avatar", for: .normal)
        
        progressView = UILabel()
        progressView.textColor = UIColor.white
        progressView.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold)
        progressView.textAlignment = .center
        progressView.baselineAdjustment = .alignCenters
        progressView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        progressView.isHidden = true
        progressView.cornerRadius = avatarImageView.cornerRadius
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapAvatarButton))
        tap.numberOfTapsRequired = 1
        avatarImageView.addGestureRecognizer(tap)
        
        addSubview(avatarImageView)
        addSubview(avatarButton)
        addSubview(progressView)
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        
        avatarButton.sizeToFit()
        
        rect.origin.x = (frame.width - avatarDimension) / 2
        rect.origin.y = (frame.height - (avatarDimension + avatarButton.frame.height)) / 2
        rect.size.width = avatarDimension
        rect.size.height = avatarDimension
        avatarImageView.frame = rect
        progressView.frame = rect
        
        rect.origin.x = (frame.width - avatarButton.frame.width) / 2
        rect.origin.y = rect.maxY
        rect.size = avatarButton.frame.size
        avatarButton.frame = rect
    }
    
    func didTapAvatarButton() {
        delegate?.didTapToChangeAvatar()
    }
}

extension ProfileEditHeaderView {
    
    var fixHeight: CGFloat {
        return 144
    }
    
    var avatarDimension: CGFloat {
        return 72
    }
}


