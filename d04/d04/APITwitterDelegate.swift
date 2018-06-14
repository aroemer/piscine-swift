//
//  APITwitterDelegate
//  d04
//
//  Created by Audrey ROEMER on 3/30/18.
//  Copyright © 2018 Audrey ROEMER. All rights reserved.
//

import Foundation

protocol APITwitterDelegate : class
{
    func processTweet(tweets: [Tweet])
    func error(error: NSError)
}
