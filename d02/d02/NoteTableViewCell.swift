//
//  NoteTableViewCell.swift
//  d02
//
//  Created by Audrey ROEMER on 3/29/18.
//  Copyright © 2018 Audrey ROEMER. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var note: Note? {
        didSet {
            nameLabel.text = note?.name
            dateLabel.text = note?.date
            descriptionLabel.text = note?.description
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
