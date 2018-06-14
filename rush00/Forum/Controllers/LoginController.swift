//
//  LoginController.swift
//  Forum
//
//  Created by Alexandra Legent on 05/12/2017.
//  Copyright © 2017 Alexandre Legent. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let background: UIImageView = {
        let image = UIImage(named: "LoginBackground")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let logoImage: UIImageView = {
        let image = UIImage(named: "LogoWhite")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign in", for: .normal)
        button.backgroundColor = .forumBlue
        button.titleLabel?.font = .futuraBook(ofSize: 25.2)
        button.addTarget(self, action: #selector(handleSignin), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(background)
        view.addSubview(logoImage)
        view.addSubview(loginButton)
        
        setupLayouts()
    }
    
    private func setupLayouts() {
        _ = background.fill(view)
        _ = logoImage.constraint(dimension: .height, constant: 125)
        _ = logoImage.constraint(.width, to: logoImage, .height)
        _ = logoImage.center(.horizontaly, view)
        _ = logoImage.center(.verticaly, view, multiplier: 0.50)
        _ = loginButton.constraint(dimension: .height, constant: 48)
        _ = loginButton.constraint(dimension: .width, constant: 250)
        _ = loginButton.center(view)
    }
    
    @objc func handleSignin() {
        LoginService.shared.requestAuthorization()
    }
}
