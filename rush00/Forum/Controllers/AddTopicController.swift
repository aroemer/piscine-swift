//
//  AddTopicController.swift
//  Forum
//
//  Created by Émilie Legent on 21/03/2018.
//  Copyright © 2018 Alexandre Legent. All rights reserved.
//

import UIKit

final class AddTopicController: PopupController {
    override var fields: [String] { return ["Topic Name", "Message"] }
    
    // MARK:- Setups
    override func setupCell(_ cell: FieldCell, at indexPath: IndexPath) {
        super.setupCell(cell, at: indexPath)
        cell.textView.isScrollEnabled = indexPath.item != 0
    }
    
    // MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.item > 0 else { return 44 }
        return 10000
    }
    
    // MARK:- Button Handler
    override func add() {
        super.add()
        guard let topicCell = popupView.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? FieldCell else { return }
        guard let messageCell = popupView.tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? FieldCell else { return }
        guard let topic = topicCell.textView.text, topic.count > 0, topic != "" else { return }
        guard let message = messageCell.textView.text, message.count > 0, message != "" else { return }
        APIService.shared.add(topic: topic, message: message) { [unowned self] topic in
            guard let topic = topic else { return }
            self.delegate?.add(topic)
        }
        cancel()
    }
}
