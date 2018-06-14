//
//  PopupController.swift
//  Forum
//
//  Created by Émilie Legent on 02/01/2018.
//  Copyright © 2018 Alexandre Legent. All rights reserved.
//

import UIKit

protocol PopupDelegate: class {
    func add(_ topic: Topic)
    func add(_ message: Message)
    func refresh()
}

class PopupController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let animationDuration = 0.5
    private let reuseId = "reuseId"
    weak var delegate: PopupDelegate?
    private var constraints = [NSLayoutAttribute: NSLayoutConstraint]()
    let popupView = PopupView()
    var fields: [String] { return [] }
    
    enum ButtonEmplacement {
        case left
        case right
    }
    
    private let background: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(background)
        view.addSubview(popupView)
        setupLayouts()
        setupPopupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        constraints[.top]?.isActive = false
        constraints[.bottom]?.isActive = true
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.background.alpha = 0.4
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        /* Setup keyboard observer */
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /* Remove observer */
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    // MARK:- Setups
    private func setupLayouts() {
        _ = background.fill(view)
        _ = popupView.fill(.horizontaly, view.safeAreaLayoutGuide)
        _ = popupView.constraint(.height, to: view, multiplier: 0.90)

        constraints[.top] = popupView.constraint(.top, to: view, .bottom)
        constraints[.bottom] = popupView.constraint(.bottom, to: view, active: false)
    }
    
    private func setupPopupView() {
        popupView.controller = self
        popupView.tableView.register(FieldCell.self, forCellReuseIdentifier: reuseId)
        popupView.tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        popupView.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
    }
    
    /* Function add more configuration in cell for row at index path */
    func setupCell(_ cell: FieldCell, at indexPath: IndexPath) {}
    
    // MARK:- Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as! FieldCell
        cell.placeholder = fields[indexPath.item]
        setupCell(cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    // MARK:- Buttons Handler
    func add() {}
    
    func cancel() {
        constraints[.bottom]?.isActive = false
        constraints[.top]?.isActive = true
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [unowned self] in
            self.background.alpha = 0
            self.view.layoutIfNeeded()
        }) { _ in
            self.view.removeFromSuperview()
        }
    }
    
    // MARK:- Keyboard events
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        popupView.tableViewConstaints[.bottom]?.constant = frame.height * -1
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
