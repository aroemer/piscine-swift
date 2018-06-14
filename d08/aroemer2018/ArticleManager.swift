//
//  ArticleManager.swift
//  aroemer2018
//
//  Created by Audrey ROEMER on 4/5/18.
//

import Foundation
import UIKit
import CoreData

public class ArticleManager: NSObject {
    
    private let modelName: String
    
    public init(modelName: String) {
        self.modelName = modelName
    }
    
    private(set) public lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: self.modelName, withExtension:"momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    public func newArticle()-> Article
    {
        //permet de créer un nouvel article et le renvoie.
        return NSEntityDescription.insertNewObject(forEntityName: "Article", into: managedObjectContext) as! Article
    }
   
    public func getAllArticles()->[Article]
    {
        //renvoie tous les articles stockés.
        let moc = managedObjectContext
        let articlesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")

        do {
            let allArticles = try moc.fetch(articlesFetch) as! [Article]
            return allArticles
        } catch {
            print(error)
//            fatalError("Failed to fetch articles: \(error)")
            return []
        }
    }
    public func getArticles(withLang lang : String)->[Article]
    {
        //renvoie tous les articles stockés avec la langue donnée.
        let articlesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        let langPredicate = NSPredicate(format: "language = %@", lang)
        articlesFetch.predicate = langPredicate
        do {
            let records = try managedObjectContext.fetch(articlesFetch) as! [Article]
            return records
        } catch {
            print(error)
            return []
        }
    }

    public func getArticles(containString str : String)->[Article]
    {
        //renvoie tous les articles stockés contenant la string passée en parametre.
        let articlesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        let resultPredicate = NSPredicate(format: "(content CONTAINS[c] %@) OR (title CONTAINS[c] %@)", str, str)
        articlesFetch.predicate = resultPredicate
        do {
            let records = try managedObjectContext.fetch(articlesFetch) as! [Article]
            return records
        } catch {
            print(error)
            return []
        }
    }

    public func removeArticle(article : Article)
    {
        //supprime l’article.
        managedObjectContext.delete(article)
    }

    public func save() {
    //sauvegarde toutes les modifications.
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
}
 
