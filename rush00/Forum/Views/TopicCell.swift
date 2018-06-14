//
//  TopicCell.swift
//  Forum
//
//  Created by Alexandra Legent on 05/12/2017.
//  Copyright © 2017 Alexandre Legent. All rights reserved.
//

import UIKit

class TopicCell: UITableViewCell {
    var topic: Topic? {
        didSet {
            guard let topic = topic else { return }
            
            userImage.image = nil
            textView.attributedText = TopicCell.getAttributedText(for: topic)
            ImageService.shared.getImage(at: topic.author.imageUrl) { image in
                self.userImage.image = image
            }
        }
    }
    
    let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 75 / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = .textViewInsets
        textView.font = .futuraBook(ofSize: 20)
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(userImage)
        addSubview(textView)
        setupLayouts()
    }
    
    private func setupLayouts() {
        _ = userImage.constraint(dimension: .height, constant: 75)
        _ = userImage.constraint(.width, to: userImage, .height)
        _ = userImage.constraint(.leading, to: self, constant: 5)
        _ = userImage.constraint(.top, to: self, constant: 5)
        
        _ = textView.constraint(.leading, to: userImage, .trailing, constant: 5)
        _ = textView.constraint(.trailing, to: self, constant: 5)
        _ = textView.center(.verticaly, self)
    }
    
    static func getAttributedText(for topic: Topic) -> NSAttributedString {
        guard let createDate = DateFormatter.iso8601.date(from: topic.createdAt) else { return NSAttributedString() }
        let attributedText = NSMutableAttributedString(string: topic.name, attributes: [.font: UIFont.futuraBook(ofSize: 20)])
        
        let attributedWritten = NSAttributedString(string: "\nWritten by ", attributes: [
            .font: UIFont.futuraBook(ofSize: 20),
            .foregroundColor: UIColor.forumGray
        ])
        
        let attributedUser = NSAttributedString(string: topic.author.login, attributes: [
            .font: UIFont.futuraBook(ofSize: 20),
            .foregroundColor: UIColor.forumBlue
        ])
        
        let attributedDate = NSAttributedString(string: " \(DateFormatter.school.string(from: createDate))", attributes: [
            .font: UIFont.futuraBook(ofSize: 20),
            .foregroundColor: UIColor.forumGray
        ])
        
        attributedText.append(attributedWritten)
        attributedText.append(attributedUser)
        attributedText.append(attributedDate)
        return attributedText
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {}
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
