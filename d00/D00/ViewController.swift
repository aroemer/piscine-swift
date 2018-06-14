//
//  ViewController.swift
//  D00
//
//  Created by Audrey ROEMER on 3/26/18.
//  Copyright © 2018 Audrey ROEMER. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var NumberDisplayed:Double = 0
    var PreviousNumber:Double = 0
    var ResultPrinted = false
    var MathOperation = false
    var Operator = 0
    var FirstOp = false
    @IBOutlet weak var ResultLabel: UILabel!
    
    @IBAction func NumberButtons(_ sender: UIButton)
    {
        if MathOperation == true
        {
            ResultLabel.text = String(sender.tag - 1)
            NumberDisplayed = Double(ResultLabel.text!)!
            MathOperation = false
            ResultPrinted = false
        }
        else
        {
            if ResultPrinted == true
            {
                Operator = 0
                PreviousNumber = 0
                NumberDisplayed = 0
                FirstOp = false
                ResultPrinted = false
                ResultLabel.text = String(sender.tag - 1)
            }
            else
            {
                ResultLabel.text = ResultLabel.text! + String(sender.tag - 1)
                NumberDisplayed = Double(ResultLabel.text!)!
            }
        }
        print(sender.tag - 1)
    }
    
    @IBAction func OperatorButtons(_ sender: UIButton)
    {
        if ResultLabel.text != "" && sender.tag != 11 && sender.tag != 16
        {
            if sender.tag == 17
            {
                if FirstOp == false
                {
                    PreviousNumber = -Double(ResultLabel.text!)!
                    print("Neg button pressed. New number is \(PreviousNumber)")
                    ResultLabel.text = String(PreviousNumber)
                }
                else
                {
                    NumberDisplayed = -NumberDisplayed
                    print("Neg button pressed on second part. New number is \(NumberDisplayed)")
                    ResultLabel.text = String(NumberDisplayed)
                    MathOperation = true
                }
                
            }
            if MathOperation == false
            {
                PreviousNumber = Double(ResultLabel.text!)!
            }
            if sender.tag == 12
            {
                ResultLabel.text = "/"
                Operator = sender.tag
                print("Divide")
            }
            else if sender.tag == 13
            {
                ResultLabel.text = "*"
                Operator = sender.tag
                print("Multiple")
            }
            else if sender.tag == 14
            {
                ResultLabel.text = "-"
                Operator = sender.tag
                print("Minus")
            }
            else if sender.tag == 15
            {
                ResultLabel.text = "+"
                Operator = sender.tag
                print("Plus")
            }
            MathOperation = true
            FirstOp = true
        }
        if sender.tag == 16
        {
            if Operator == 12
            {
                if NumberDisplayed == 0
                {
                    ResultLabel.text = "Not a number"
                }
                else
                {
                    ResultLabel.text = String(PreviousNumber / NumberDisplayed)
                }
            }
            else if Operator == 13
            {
                ResultLabel.text = String(PreviousNumber * NumberDisplayed)
            }
            else if Operator == 14
            {
                ResultLabel.text = String(PreviousNumber - NumberDisplayed)
            }
            else if Operator == 15
            {
                ResultLabel.text = String(PreviousNumber + NumberDisplayed)
            }
            print("Result = \(ResultLabel.text!)")
            ResultPrinted = true
        }
        else if sender.tag == 11
        {
            ResultLabel.text = ""
            Operator = 0
            PreviousNumber = 0
            NumberDisplayed = 0
            FirstOp = false
            print("AC, cleared")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

