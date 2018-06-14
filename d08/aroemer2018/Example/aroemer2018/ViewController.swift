//
//  ViewController.swift
//  aroemer2018
//
//  Created by aroemer on 04/05/2018.
//  Copyright (c) 2018 aroemer. All rights reserved.
//

import UIKit
import CoreData
import aroemer2018

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let DataManager = ArticleManager(modelName: "article")
        let newArt = DataManager.newArticle()
        newArt.title = "Coucou"
        newArt.content = "Coucou le monde"
        newArt.creation_date = NSDate()
        newArt.language = "french"
        
        let anotherArt = DataManager.newArticle()
        anotherArt.title = "I am an article"
        anotherArt.content = "I am a great article"
        anotherArt.creation_date = NSDate()
        anotherArt.language = "english"
        
        let lastArt = DataManager.newArticle()
        lastArt.title = "Last but not least"
        lastArt.content = "I am therefore I think"
        lastArt.creation_date = NSDate()
        lastArt.language = "english"
        
        let allArt = DataManager.getAllArticles()
        print("All Articles: \n \(allArt)")
        
        let langArt = DataManager.getArticles(withLang: "english")
        print("Articles in english: \n \(langArt)")
        
        let strArt = DataManager.getArticles(containString: "i am")
        print("Articles with str: \n \(strArt)")
        
        
        DataManager.removeArticle(article: anotherArt)
        
        let allArtafterRemove = DataManager.getAllArticles()
        print("All Articles after remove: \n \(allArtafterRemove)")
        
//        uncomment to delete all articles
//        for ar in allArtafterRemove
//        {
//            DataManager.removeArticle(article: ar)
//        }
        
        DataManager.save()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

