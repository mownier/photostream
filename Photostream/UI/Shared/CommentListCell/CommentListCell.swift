//
//  CommentListCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Kingfisher

protocol CommentListCellDelegate: class {
    
    func didTapAuthor(cell: CommentListCell)
}

class CommentListCell: UITableViewCell {

    weak var delegate: CommentListCellDelegate?
    
    var authorPhoto: UIImageView!
    var authorLabel: UILabel!
    var contentLabel: UILabel!
    var timeLabel: UILabel!
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: "CommentListCell")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CommentListCell.reuseId)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    func initSetup() {
        authorPhoto = UIImageView()
        authorLabel = UILabel()
        contentLabel = UILabel()
        timeLabel = UILabel()
        
        authorPhoto.cornerRadius = photoLength / 2
        authorPhoto.clipsToBounds = true
        
        authorLabel.numberOfLines = 0
        contentLabel.numberOfLines = 0
        
        timeLabel.font = UIFont.systemFont(ofSize: 8)
        timeLabel.textColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1)
        
        authorLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)
        authorLabel.textColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        
        contentLabel.font = UIFont.systemFont(ofSize: 12)
        contentLabel.textColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapAuthor))
        tap.numberOfTapsRequired = 1
        authorLabel.isUserInteractionEnabled = true
        authorLabel.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapAuthor))
        tap.numberOfTapsRequired = 1
        authorPhoto.isUserInteractionEnabled = true
        authorPhoto.addGestureRecognizer(tap)
        
        contentView.addSubview(authorPhoto)
        contentView.addSubview(authorLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(timeLabel)
    }
    
    override func layoutSubviews() {
        var frame = CGRect(x: spacing, y: spacing, width: photoLength, height: photoLength)
        authorPhoto.frame = frame
        
        frame.origin.x = photoLength + (spacing * 2)
        frame.origin.y = spacing
        frame.size.width = contentSize.width - frame.origin.x - spacing
        frame.size.height = authorLabel.sizeThatFits(frame.size).height
        authorLabel.frame = frame
        
        frame.origin.y += frame.size.height + spacing
        frame.size.height = contentLabel.sizeThatFits(frame.size).height
        contentLabel.frame = frame
        
        frame.origin.y += frame.size.height + spacing
        frame.size.height = timeLabel.intrinsicContentSize.height
        timeLabel.frame = frame
    }
    
    func didTapAuthor() {
        delegate?.didTapAuthor(cell: self)
    }
}

extension CommentListCell {
    
    static var reuseId: String {
        return "CommentListCell"
    }
    
    var spacing: CGFloat {
        return 4
    }
    
    var photoLength: CGFloat {
        return 28
    }
    
    var contentSize: CGSize {
        return contentView.bounds.size
    }
}

extension CommentListCell {
    
    class func dequeue(from view: UITableView) -> CommentListCell? {
        return view.dequeueReusableCell(withIdentifier: CommentListCell.reuseId) as? CommentListCell
    }
    
    class func register(in view: UITableView) {
        view.register(CommentListCell.self, forCellReuseIdentifier: CommentListCell.reuseId)
    }
}
