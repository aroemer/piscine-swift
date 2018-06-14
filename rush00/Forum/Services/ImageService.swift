//
//  ImageService.swift
//  Forum
//
//  Created by Alexandra Legent on 05/12/2017.
//  Copyright © 2017 Alexandre Legent. All rights reserved.
//

import UIKit

class ImageService {
    static let shared = ImageService()
    private let caching = NSCache<NSString, UIImage>()
    
    func getImage(at link: String, completion: @escaping (UIImage?) -> Void) {
        let qos = DispatchQoS.background.qosClass
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
        
        if let cachedImage = caching.object(forKey: NSString(string: link)) {
            completion(cachedImage)
            return
        }
        DispatchQueue.global(qos: qos).async {
            guard let data = try? Data(contentsOf: url) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            let image = UIImage(data: data)!
            self.caching.setObject(image, forKey: NSString(string: link))
            DispatchQueue.main.async { completion(image) }
        }
    }
}
