//
//  SecondViewController.swift
//  d02
//
//  Created by Audrey ROEMER on 3/28/18.
//  Copyright © 2018 Audrey ROEMER. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    weak var delegate: ViewController!
    
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var DatePickerField: UIDatePicker!
    @IBOutlet weak var DeathDescriptionField: UITextView!
    
    @IBOutlet weak var NameValidationLabel: UILabel!
    
    var noteToEdit: Note?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneButton"
        {
            guard let text = NameTextField.text else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/YYYY hh:mm"
            let somedateString = dateFormatter.string(from: DatePickerField.date)
            guard let desc = DeathDescriptionField.text else { return }
            let note = Note(name: text, date: somedateString, description: desc)
            if let destinationViewController = segue.destination as? ViewController
            {
                destinationViewController.newNote = note
            }
        }
    }
    
    @IBAction func unWindSegue(segue: UIStoryboardSegue)
    {
            NameTextField.text = noteToEdit!.name
            DeathDescriptionField.text = noteToEdit!.description
    }
    
    @IBAction func Done(_ sender: UIBarButtonItem) {
        //check user input, if NameTextField performSegue
            let text = NameTextField.text
            if text!.count == 0 || text! == ""
            {
                NameValidationLabel.text = "This field cannot be empty."
                UIView.animate(withDuration: 0.25, animations: {
                    self.NameValidationLabel.isHidden = false
                })
            }
            else
            {
                performSegue(withIdentifier: "doneButton", sender: self)
                self.NameValidationLabel.isHidden = true
            }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NameTextField.delegate = self
        DatePickerField.minimumDate = Date()
        DeathDescriptionField.layer.borderColor = UIColor.lightGray.cgColor
        DeathDescriptionField.layer.borderWidth = 0.5
        DeathDescriptionField.layer.cornerRadius = 5
        setupView()
    }
    
    fileprivate func setupView() {
        // Configure Name Validation Label
        NameValidationLabel.isHidden = true
    }
    
}

extension SecondViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == NameTextField
        {
            let text = textField.text
            if text!.count == 0 || text! == ""
            {
                NameValidationLabel.text = "This field cannot be empty."
                UIView.animate(withDuration: 0.25, animations: {
                    self.NameValidationLabel.isHidden = false
                })
            }
            else
            {
                self.NameValidationLabel.isHidden = true
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.NameValidationLabel.isHidden = true
    }
    

}

