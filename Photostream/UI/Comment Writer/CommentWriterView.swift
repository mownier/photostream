//
//  CommentWriterView.swift
//  Photostream
//
//  Created by Mounir Ybanez on 01/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol CommentWriterViewDelegate: class {
    
    func willSend(with content: String?, view: CommentWriterView)
}

class CommentWriterView: UIView {
    
    fileprivate let spacing: CGFloat = 4
    fileprivate let textColor: UIColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
    fileprivate let contentFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    weak var delegate: CommentWriterViewDelegate?
    
    var contentTextView: UITextView!
    var sendButton: UIButton!
    var topBorder: UIView!
    var placeholderLabel: UILabel!
    var loadingView: UIActivityIndicatorView!
    
    var isSending: Bool = false {
        didSet {
            guard isSending != oldValue else {
                return
            }
            
            sendButton.isHidden = isSending
            
            if isSending {
                loadingView.isHidden = false
                loadingView.startAnimating()
                
                let content = contentTextView.text
                delegate?.willSend(with: content, view: self)
                set(content: "")
                contentTextView.resignFirstResponder()
            } else {
                loadingView.stopAnimating()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    deinit {
        removeContentObserver()
    }

    override func layoutSubviews() {
        var rect: CGRect = .zero
        
        rect.size.width = 64
        rect.size.height = 32
        rect.origin.y = spacing
        rect.origin.x = frame.size.width - rect.size.width - spacing
        sendButton.frame = rect
        
        rect.size.width = rect.origin.x - (spacing * 2)
        rect.size.height = frame.size.height - (spacing * 2)
        rect.origin.x = spacing
        rect.origin.y = spacing
        contentTextView.frame = rect
        
        rect.size = placeholderLabel.sizeThatFits(rect.size)
        rect.origin.x += contentTextView.textContainerInset.left
        rect.origin.x += contentTextView.textContainer.lineFragmentPadding
        rect.origin.y += contentTextView.textContainerInset.top
        placeholderLabel.frame = rect
        
        rect.size.width = frame.size.width
        rect.size.height = 1
        rect.origin = .zero
        topBorder.frame = rect
        
        loadingView.frame = sendButton.frame
    }
    
    func initSetup() {
        backgroundColor = UIColor.white
        
        contentTextView = UITextView()
        contentTextView.textColor = textColor
        contentTextView.tintColor = textColor
        contentTextView.backgroundColor = UIColor.clear
        contentTextView.font = contentFont
        
        sendButton = UIButton(type: .system)
        sendButton.addTarget(self, action: #selector(self.didTapSend), for: .touchUpInside)
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(textColor, for: .normal)
        sendButton.titleLabel?.font = contentFont
        
        topBorder = UIView()
        topBorder.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "Write a comment"
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.font = contentFont
        placeholderLabel.isUserInteractionEnabled = true
        
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.hidesWhenStopped = true
        
        addPlaceholderTap()
        addContentObserver()
        
        addSubview(contentTextView)
        addSubview(sendButton)
        addSubview(topBorder)
        addSubview(placeholderLabel)
        addSubview(loadingView)
    }
    
    func set(content: String) {
        contentTextView.text = content
        NotificationCenter.default.post(
            name: NSNotification.Name.UITextViewTextDidChange,
            object: contentTextView)
    }
}

extension CommentWriterView {
    
    func didTapSend() {
        isSending = true
    }
    
    func didTapPlaceholder() {
        contentTextView.becomeFirstResponder()
    }
}

extension CommentWriterView {
    
    func addContentObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.contentDidChangeText),
            name: NSNotification.Name.UITextViewTextDidChange,
            object: nil)
    }
    
    func removeContentObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.UITextViewTextDidChange,
            object: nil)
    }
    
    func contentDidChangeText(notif: NSNotification) {
        guard let textView = notif.object as? UITextView,
            textView == contentTextView, contentTextView.isFirstResponder else {
                return
        }
        
        placeholderLabel.isHidden = !contentTextView.text.isEmpty
    }
}

extension CommentWriterView {
    
    func addPlaceholderTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapPlaceholder))
        tap.numberOfTapsRequired = 1
        placeholderLabel.addGestureRecognizer(tap)
    }
}
