//
//  APIController.swift
//  d04
//
//  Created by Audrey ROEMER on 3/30/18.
//  Copyright © 2018 Audrey ROEMER. All rights reserved.
//

import UIKit

class APIController {
    
    weak var delegate : APITwitterDelegate?
    let token: String
    
    init(delegate: APITwitterDelegate?, token:String)
    {
        self.delegate = delegate
        self.token = token
    }
    
    func request(search: String)
    {
        let url = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json?q=" + search + "&lang=fr&count=100&result_type=recent")
            let request = NSMutableURLRequest(url: url! as URL)
            request.httpMethod = "GET"
            request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                (data, response, error) in
                if let err = error {
                    DispatchQueue.main.async() {
                        self.delegate?.error(error: err as NSError)
                    }
                }
                else if let d = data {
                    do {
                        if let resp: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            if let allTweets: [[String:AnyObject]] = resp["statuses"] as? [[String:AnyObject]] {
                                if allTweets.count == 0
                                {
                                    DispatchQueue.main.async() {
                                        let errorTemp = NSError(domain:"Aucun tweet trouvé", code: allTweets.count, userInfo:nil)
                                        self.delegate?.error(error: errorTemp)
                                    }
                                }
                                var tweets : [Tweet] = []
                                for item in allTweets
                                {
                                    let name = item["user"]?["name"] as! String
                                    let date = item["created_at"] as! String
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
                                    let stringToDate = dateFormatter.date(from: date)
                                    dateFormatter.dateFormat = "dd/MM/YYYY hh:mm"
                                    let DateToString = dateFormatter.string(from: stringToDate!)
                                    let text = item["text"] as! String
                                    tweets.append(Tweet(name: String(describing: name), date: DateToString, text: String(describing: text)))
                                }
                                DispatchQueue.main.async() {
                                    self.delegate?.processTweet(tweets: tweets)
                                }
                            }
                        }
                    }
                    catch (let err as NSError) {
                        DispatchQueue.main.async() {
                            self.delegate?.error(error: err)
                        }
                    }
                }
            }
            task.resume()
    }
}
