//
//  ViewController.swift
//  d06
//
//  Created by Audrey ROEMER on 4/3/18.
//  Copyright © 2018 Audrey ROEMER. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var animator: UIDynamicAnimator!
    var gravity = UIGravityBehavior()
    var collision = UICollisionBehavior()
    var elasticity = UIDynamicItemBehavior()
    var attachment: UIAttachmentBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        animator = UIDynamicAnimator(referenceView: view)
        animator.addBehavior(gravity)
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        elasticity.elasticity = 0.6
        animator.addBehavior(elasticity)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        view.addGestureRecognizer(gesture)
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let x = sender.location(in: view).x
        let y = sender.location(in: view).y
        let myView = Shape(x: x, y: y)
        view.addSubview(myView)
        
        gravity.addItem(myView)
        collision.addItem(myView)
        elasticity.addItem(myView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(sender:)))
        myView.isUserInteractionEnabled = true
        myView.addGestureRecognizer(panGesture)
        myView.addGestureRecognizer(pinchGesture)
        myView.addGestureRecognizer(rotationGesture)
        
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            gravity.removeItem(sender.view!)
        }
        if sender.state == .changed {
            let translation = sender.translation(in: self.view)
            if let selectedView = sender.view {
                selectedView.center = CGPoint(x: selectedView.center.x + translation.x, y: selectedView.center.y + translation.y)
            }
            sender.setTranslation(CGPoint.zero, in: self.view)
            animator.updateItem(usingCurrentState: sender.view!)
        }
        if sender.state == .ended {
            gravity.addItem(sender.view!)
        }
        
    }
    
    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        if let selectedView = sender.view as? Shape {
            if sender.state == .began {
                gravity.removeItem(selectedView)
            }
            if sender.state == .changed {
                collision.removeItem(selectedView)
                elasticity.removeItem(selectedView)
                selectedView.bounds.size.width *= sender.scale
                selectedView.bounds.size.height *= sender.scale
                if selectedView.isCircle {
                    sender.view?.layer.cornerRadius *= sender.scale
                }
                sender.scale = 1
                collision.addItem(selectedView)
                elasticity.addItem(selectedView)
                animator.updateItem(usingCurrentState: selectedView)
            }
            if sender.state == .ended {
                gravity.addItem(selectedView)
            }
        }
    }
    
    @objc func handleRotate(sender: UIRotationGestureRecognizer)
    {
        if let selectedView = sender.view as? Shape {
            if sender.state == .began {
                gravity.removeItem(selectedView)
            }
            if sender.state == .changed {
                collision.removeItem(selectedView)
                elasticity.removeItem(selectedView)
                selectedView.transform = selectedView.transform.rotated(by: sender.rotation)
                selectedView.clipsToBounds = true
                sender.rotation = 0
                collision.addItem(selectedView)
                elasticity.addItem(selectedView)
                animator.updateItem(usingCurrentState: selectedView)
            }
            if sender.state == .ended {
                gravity.addItem(selectedView)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

