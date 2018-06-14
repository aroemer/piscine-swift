//
//  MessagesController.swift
//  Forum
//
//  Created by Alexandra Legent on 14/12/2017.
//  Copyright © 2017 Alexandre Legent. All rights reserved.
//

import UIKit

final class MessagesController: UITableViewController, PopupDelegate {
    private let reuseId = "reusId"
    private let addController = AddMessageController()
    private let editController = EditMessageController()
    var messages = [Message]() {
        didSet { tableView.reloadData() }
    }
    
    var topic: Topic? {
        willSet { messages = [] }
        didSet {
            guard let topic = topic else { return }
            title = topic.name
            addController.topic = topic
            handleRefresh()
        }
    }
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(MessageCell.self, forCellReuseIdentifier: reuseId)
        
        /* Refresh Control */
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        /* Adding add button */
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        navigationItem.rightBarButtonItem = addButton
        
        addController.delegate = self
        editController.delegate = self
    }
    
    // MARK:- Controller logics
    /* Will look for all reply and will integrate it into one array */
    func setMessages(_ messages: [Message]) {
        var final = [Message]()
        
        messages.forEach {
            final.append($0)
            
            $0.replies.forEach {
                let reply = Message(id: $0.id, author: $0.author, content: $0.content, createdAt: $0.createdAt, replies: $0.replies, votes: $0.votes, isReply: true)
                final.append(reply)
            }
        }
        
        self.messages = final
    }
    
    @objc func handleRefresh() {
        guard let topic = topic else { return }
        APIService.shared.getMessage(for: topic) { [unowned self] messages in
            guard let messages = messages else { return }
            self.setMessages(messages)
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc func handleAdd() {
        guard let window = UIApplication.shared.keyWindow else { return }
        window.addSubview(addController.view)
    }
    
    // MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! MessageCell
        let message = messages[indexPath.item]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messages[indexPath.item]
        let size = CGSize(width: tableView.frame.width - 65, height: 10000)
        let attributedContent = NSAttributedString(string: message.content, attributes: [.font: UIFont.futuraBook(ofSize: 20)])
        let estimatedFrame = attributedContent.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
        let estimatedHeight = estimatedFrame.height + 40
        
        return estimatedHeight > 60 ? estimatedHeight : 60
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let message = messages[indexPath.item]
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, _ in
            guard let index = self.messages.index(where: { $0 == message }) else { return }
            guard let user = LoginService.shared.user, message.author.id == user.id else {
                let controller = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    controller.dismiss(animated: true, completion: nil)
                })
                
                controller.title = "Unauthorized"
                controller.message = "Message doesn't belongs to you."
                controller.addAction(cancel)
                self.navigationController?.present(controller, animated: true, completion: nil)
                return
            }
            
            APIService.shared.remove(message: message.id)
            self.messages.remove(at: index)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { [unowned self] _, _, _ in
            guard let window = UIApplication.shared.keyWindow else { return }
            guard let user = LoginService.shared.user, message.author.id == user.id else {
                let controller = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    controller.dismiss(animated: true, completion: nil)
                })
                
                controller.title = "Unauthorized"
                controller.message = "Message doesn't belongs to you."
                controller.addAction(cancel)
                self.navigationController?.present(controller, animated: true, completion: nil)
                return
            }
            
            self.editController.message = message
            window.addSubview(self.editController.view)
        }
        
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    // MARK:- Popup Delegate
    func add(_ topic: Topic) {}
    
    func add(_ message: Message) {
        setMessages(messages + [message])
    }
    
    func refresh() {
        handleRefresh()
    }
}
