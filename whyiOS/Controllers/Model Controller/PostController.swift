//
//  PostController.swift
//  whyiOS
//
//  Created by Chris Grayston on 2/6/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation

class PostController {
    
    // Base URL
    static let baseURL = URL(string: "https://whydidyouchooseios.firebaseio.com/reasons")
    
    static func fetchPosts(completion: @escaping (([Post]?) -> Void)) {
        guard let unwrappedURL = baseURL else {
            print("Bad URL")
            completion([])
            return
        }
        
        let getterEndpoint = unwrappedURL.appendingPathExtension("json")
        
        var urlRequest = URLRequest(url: getterEndpoint)
        urlRequest.httpMethod = "GET"
        urlRequest.httpBody = nil
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                print("Error with data task: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Error getting data in data task")
                completion(nil)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let decodedDictionary = try jsonDecoder.decode([String:Post].self, from: data)
                let decodedPosts = decodedDictionary.compactMap( { $0.value })
                completion(decodedPosts)
                
            } catch {
                print("Error with data task")
                completion(nil)
                return
            }
        }
        dataTask.resume()
    }
    
    static func postReason(cohort: String, name: String, reason: String, completion: @escaping ((Bool) -> Void)) {
        guard let unwrappedURL = baseURL else {
            print("Error unwrapping")
            completion(false)
            return
        }
        
        let urlAsJson = unwrappedURL.appendingPathExtension("json")
        
        // Create Post object
        let newPost = Post(cohort: cohort, name: name, reason: reason)
        
        do {
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(newPost)
            var urlRequest = URLRequest(url: urlAsJson)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = data
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                
                if data != nil {
                    completion(true)
                    return
                }
                // If data was nil
                completion(false)
            }
            dataTask.resume()
        } catch {
            print("\(error.localizedDescription)")
            completion(false)
            return
        }
        
    }
}
