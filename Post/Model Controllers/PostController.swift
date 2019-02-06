//
//  PostController.swift
//  Post
//
//  Created by Ben Huggins on 2/4/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class PostController {
    
    private static let baseURL =  URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
    static var posts: [Post] = []
    
    static func fetchPosts(reset: Bool = true, completion: @escaping () -> Void) {
        
        let queryEndInterval = reset ? Date().timeIntervalSince1970 : posts.last?.timestamp ?? Date().timeIntervalSince1970
        
        let urlParameters = [
            "orderBy": "\"timestamp\"",
            "endAt": "\(queryEndInterval)",
            "limitToLast": "15",
            ]
        
        let queryItems = urlParameters.compactMap( { URLQueryItem(name: $0.key, value: $0.value) } )
        
        guard let unwrappedURL = baseURL else { fatalError("url is having fatal issues")}
        
         var urlComponents = URLComponents(url: unwrappedURL, resolvingAgainstBaseURL: true)
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { completion(); return }
        
        
        // added in url instead of unwrappedURL to change parameters
        let getterEndPoint = url.appendingPathExtension("json")
        
        var urlRequest = URLRequest(url: getterEndPoint)
        print(urlRequest)
        urlRequest.httpBody = nil
        urlRequest.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            do {
                if let downloadError = error { throw downloadError}
                guard let data = data else {throw NSError() }
                let jsonDecoder = JSONDecoder()
                let postsDictionary = try jsonDecoder.decode([String:Post].self, from: data)
                //completion(posts.posts)
                let posts: [Post] = postsDictionary.compactMap({ $0.value})
                let sortedPosts = posts.sorted(by: {$0.timestamp > $1.timestamp})
                if reset {
                    self.posts = sortedPosts
                } else {
                    self.posts.append(contentsOf: sortedPosts)
                }
                completion()
                return
                
            } catch {
   
            }
        }
        dataTask.resume()

    }
    
    func addNewPostWith(username: String, text: String, completion: @escaping() -> Void) {
        let post = Post(text: text, username: username)
        var postData: Data
        
        do {
            // grab encoder
            let encoder = JSONEncoder()
            //encode post
            postData = try encoder.encode(post)
//            completion()
    
        } catch {
            print("error encoding new post \(error) : \(error.localizedDescription)")
            completion()
            return
   
        }
        
       guard let unwrappedURL = PostController.baseURL else { completion(); return }
        
         let postEndpoint = unwrappedURL.appendingPathExtension("json")
        
        var urlRequest = URLRequest(url: postEndpoint)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = postData
        
        
         let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            
            if let error = error {
                completion()
                print(error)
                return
            }
            guard let data = data,
                let responseBack = String(data: data, encoding: .utf8) else {
                print("no data found from API")
                completion()
                return
            }
            print(responseBack)
            
            PostController.fetchPosts(reset: false, completion: {
                completion()
            })
         
        }
        dataTask.resume()

}
}


