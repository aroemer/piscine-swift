//
//  FieldCell.swift
//  Forum
//
//  Created by Émilie Legent on 03/01/2018.
//  Copyright © 2018 Alexandre Legent. All rights reserved.
//

import UIKit

class FieldCell: UITableViewCell, UITextViewDelegate {
    var placeholder: String? {
        didSet { textView.text = placeholder }
    }
    
    lazy var textView: UITextView = {
        let text = UITextView()
        text.font = .futura(ofSize: 20)
        text.delegate = self
        text.textColor = .lightGray
        return text
    }()

    // MARK:- Inits
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textView)
        _ = textView.fill(self, constant: 5)
    }
    
    // MARK:- Text View Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.text == placeholder else { return }
        textView.text = ""
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        
        guard textView.text == "" else { return }
        textView.text = placeholder
        textView.textColor = .lightGray
    }
    
    // MARK:- Table View Cell Delegate
    /* Shutting down this two function */
    override func setSelected(_ selected: Bool, animated: Bool) {}
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
}
