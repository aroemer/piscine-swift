//
//  TableViewCell.swift
//  d05
//
//  Created by Audrey ROEMER on 4/2/18.
//  Copyright © 2018 Audrey ROEMER. All rights reserved.
//

import UIKit

class TableViewCell : UITableViewCell {
    
    @IBOutlet weak var PlaceLabel: UILabel!
    
    var place: Place? {
        didSet {
            PlaceLabel.text = place?.locationName
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
