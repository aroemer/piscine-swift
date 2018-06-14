//
//  ViewController.swift
//  d07
//
//  Created by Audrey ROEMER on 4/4/18.
//  Copyright © 2018 Audrey ROEMER. All rights reserved.
//

import RecastAI
import ForecastIO
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var bot : RecastAIClient?
    var client : DarkSkyClient?

    @IBOutlet weak var searchField: UITextField! {
        didSet {
            searchField.delegate = self
            searchField.becomeFirstResponder()
        }
    }
    @IBOutlet weak var responseLabel: UILabel!
    
    @IBAction func makeRequestButton(_ sender: UIButton) {
        if let search = searchField.text {
            makeRequest(request: search)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let search = searchField.text {
            makeRequest(request: search)
        }
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.bot = RecastAIClient(token : "646d745e15982c2cede9f614803d2d9e")
        self.client = DarkSkyClient(apiKey: "5785ca117a612093e596d8305685701d")
        self.client?.language = .english
    }
    
    func makeRequest(request: String)
    {
        self.bot?.textRequest(request, successHandler: successHandle, failureHandle: failureHandle)
    }
    
    func successHandle(_ response: Response) -> Void
    {
        if let location = response.get(entity: "location")
        {
            if let lat = location["lat"]
            {
                if let lng = location["lng"]
                {
                    self.client?.getForecast(latitude: lat as! Double, longitude: lng as! Double)
                    { result in
                        switch result {
                        case .success(let currentForecast, _):
                            DispatchQueue.main.async() {
                                self.responseLabel.text = currentForecast.currently?.summary
                            }
                        case .failure(_):
                            DispatchQueue.main.async() {
                                self.responseLabel.text = "Error"
                            }
                        }
                    }
                }
            }
        
        }
        else
        {
            responseLabel.text = "Error"
        }
    }
    
    func failureHandle(_ error: Error) -> Void
    {
        responseLabel.text = "Error"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

