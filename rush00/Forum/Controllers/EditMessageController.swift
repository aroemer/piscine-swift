//
//  EditMessageController.swift
//  Forum
//
//  Created by Émilie Legent on 21/03/2018.
//  Copyright © 2018 Alexandre Legent. All rights reserved.
//

import UIKit

final class EditMessageController: PopupController {
    override var fields: [String] { return [""] }
    var message: Message?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let cell = popupView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FieldCell else { return }
        cell.textView.textColor = .black
        cell.textView.text = message?.content
    }
    
    // MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
    
    override func add() {
        super.add()
        guard let cell = popupView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FieldCell else { return }
        guard let content = cell.textView.text, content.count > 0 else { return }
        guard let message = message else { return }
        APIService.shared.update(message: message.id, with: content) {
            self.delegate?.refresh()
        }
        
        cancel()
    }
}
