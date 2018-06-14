//
//  TopicsController.swift
//  Forum
//
//  Created by Alexandra Legent on 05/12/2017.
//  Copyright © 2017 Alexandre Legent. All rights reserved.
//

import UIKit

class TopicsController: UITableViewController, LoginDelegate, PopupDelegate {
    private let reuseId = "reuseId"
    private let loginController = LoginController()
    private let messagesController = MessagesController()
    private let addController = AddTopicController()
    private var topics = [Topic]() {
        didSet { tableView.reloadData() }
    }
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Topics"
        setupTableView()
        setupNavBar()
        handleLogout()
        LoginService.shared.delegate = self
        addController.delegate = self
    }
    
    // MARK:- Setups
    private func setupTableView() {
        tableView.register(TopicCell.self, forCellReuseIdentifier: reuseId)
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func setupNavBar() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItem = addButton
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! TopicCell
        let topic = topics[indexPath.item]
        cell.topic = topic
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let topic = topics[indexPath.item]
        
        let size = CGSize(width: tableView.frame.width - 90, height: 10000)
        let estimatedFrame = TopicCell.getAttributedText(for: topic).boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
        return estimatedFrame.height > 85 ? estimatedFrame.height : 85
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messagesController.topic = topics[indexPath.item]
        navigationController?.pushViewController(messagesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let topic = topics[indexPath.item]
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, _ in
            guard let index = self.topics.index(where: { $0 == topic }) else { return }
            guard let user = LoginService.shared.user, topic.author.id == user.id else {
                let controller = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    controller.dismiss(animated: true, completion: nil)
                })
                
                controller.title = "Unauthorized"
                controller.message = "Topic doesn't belongs to you."
                controller.addAction(cancel)
                self.navigationController?.present(controller, animated: true, completion: nil)
                return
            }
            
            APIService.shared.remove(topic: topic.id)
            self.topics.remove(at: index)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { [unowned self] _, _, _ in
            guard let user = LoginService.shared.user, topic.author.id == user.id else {
                let controller = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    controller.dismiss(animated: true, completion: nil)
                })
                
                controller.title = "Unauthorized"
                controller.message = "Topic doesn't belongs to you."
                controller.addAction(cancel)
                self.navigationController?.present(controller, animated: true, completion: nil)
                return
            }
            
            let controller = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                controller.dismiss(animated: true, completion: nil)
            })
            
            let save = UIAlertAction(title: "Save", style: .default, handler: { _ in
                guard let textField = controller.textFields?.first else { return }
                guard let text = textField.text, text.count > 0 else { return }
                APIService.shared.update(topic: topic.id, with: text) { [unowned self] in
                    self.handleRefresh()
                }
            })
            
            controller.title = "Edit Topic"
            controller.message = "Set a new title for your topic."
            controller.addAction(cancel)
            controller.addAction(save)
            controller.addTextField(configurationHandler: { textField in
                textField.placeholder = topic.name
            })
            
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
        
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    // MARK:- Buttons handler
    @objc func handleLogout() {
        navigationController?.present(loginController, animated: true, completion: nil)
    }
    
    @objc func handleAdd() {
        guard let window = UIApplication.shared.keyWindow else { return }
        window.addSubview(addController.view)
    }
    
    // MARK:- Refresh handler
    @objc func handleRefresh() {
        APIService.shared.getTopics { [unowned self] topics in
            guard let topics = topics else { return }
            self.topics = topics
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK:- Login Delegate
    func didLogin() {
        navigationController?.dismiss(animated: true, completion: nil)
        handleRefresh()
    }
    
    // MARK:- Popup Delegate
    func add(_ topic: Topic) {
        topics = [topic] + topics
    }
    
    func add(_ message: Message) {}
    
    func refresh() {
        handleRefresh()
    }
}

