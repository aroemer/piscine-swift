//
//  ViewController.swift
//  d04
//
//  Created by Audrey ROEMER on 3/30/18.
//  Copyright © 2018 Audrey ROEMER. All rights reserved.
//

import UIKit

class ViewController: UIViewController, APITwitterDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var token: String?
    var tweets: [Tweet] = []
    
    @IBOutlet weak var SearchField: UITextField! {
        didSet {
            SearchField.delegate = self
            SearchField.becomeFirstResponder()
            getToken()
        }
    }
    
    @IBOutlet weak var TweetTableView: UITableView! {
        didSet {
            TweetTableView.dataSource = self
            TweetTableView.rowHeight = UITableViewAutomaticDimension
            TweetTableView.estimatedRowHeight = 80.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TweetTableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetTableViewCell
        cell.nameLabel.text = tweets[indexPath.row].name
        cell.dateLabel.text = tweets[indexPath.row].date
        cell.contentLabel.text = tweets[indexPath.row].text
        return cell
    }
    
    func processTweet(tweets: [Tweet]) {
        for tweet in tweets {
            print("\(tweet)\n")
        }
        self.tweets = tweets
        TweetTableView.reloadData()
    }
    
    func error(error: NSError) {
        let alert = UIAlertController(title: "Oups", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func executeRequest(search: String)
    {
        if let token = self.token {
            let apiController = APIController(delegate: self, token: token)
            apiController.request(search: search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let search = SearchField.text {
            executeRequest(search: search)
        }
        self.view.endEditing(true)
        return false
    }
    
    func getToken() {
        let CUSTOMER_KEY = ""
        let CUSTOMER_SECRET = ""
        let BEARER = (CUSTOMER_KEY + ":" + CUSTOMER_SECRET).data(using: String.Encoding.utf8)!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let url = NSURL(string: "https://api.twitter.com/oauth2/token")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic \(BEARER)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                self.error(error: (err as NSError))
            }
            else if let d = data {
                do {
                    if let resp: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let token = resp["access_token"] {
                            self.token = token as? String
                        }
                    }
                }
                catch (let err) {
                    print(err)
                }
            }
        }
        task.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.TweetTableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
