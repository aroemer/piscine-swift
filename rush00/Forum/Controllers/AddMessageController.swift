//
//  AddMessageController.swift
//  Forum
//
//  Created by Émilie Legent on 21/03/2018.
//  Copyright © 2018 Alexandre Legent. All rights reserved.
//

import UIKit

final class AddMessageController: PopupController {
    override var fields: [String] { return ["Message"] }
    var topic: Topic?
    
    // MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
    
    // MARK:- Popup Logic
    override func add() {
        super.add()
        guard let field = popupView.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? FieldCell else { return }
        guard let message = field.textView.text, message.count > 0, message != "" else { return }
        guard let topic = topic else { return }
        APIService.shared.add(message: message, to: topic.id) { response in
            guard let response = response else { return }
            self.delegate?.add(response)
        }
        
        cancel()
    }
}
