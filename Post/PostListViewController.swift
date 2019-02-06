//
//  ViewController.swift
//  Post
//
//  Copyright © 2018 DevMtnStudent. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    let postController = PostController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        
        PostController.fetchPosts {
            //self.reloadTableViews()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    func presentNewPostAlert() {
        
        let newPostAlertController = UIAlertController(title: "New Post", message: nil, preferredStyle: .alert)
        
        var usernameTextField = UITextField()
        newPostAlertController.addTextField { (username) in
            usernameTextField = username
        }
        var messagenameTextField = UITextField()
        newPostAlertController.addTextField { (message) in
            messagenameTextField = message
        }
        let postAction = UIAlertAction(title: "Post", style: .default) { (postAction) in
            guard let username = usernameTextField.text, !username.isEmpty,
                let text = messagenameTextField.text, !text.isEmpty else {
                    return
            }
            self.postController.addNewPostWith(username: username, text: text, completion: {
                self.reloadTableViews()
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        newPostAlertController.addAction(postAction)
        newPostAlertController.addAction(cancelAction )
        
        self.present(newPostAlertController, animated: true, completion: nil)
    }
    
    func presentErrorAlert() {
        let alertController = UIAlertController(title: "Missing info", message: "Make sure both text fields are filled out", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
 
    @IBAction func addPostTapped(_ sender: Any) {
  presentNewPostAlert()
    
    }
    
    func reloadTableViews() {
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }

    }
    @objc func refreshControlPulled() {
        
         //UIApplication.shared.isNetworkActivityIndicatorVisible = true

        
        PostController.fetchPosts {
            self.reloadInputViews()
            DispatchQueue.main.async {
               self.refreshControl.endRefreshing()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        let post = PostController.posts[indexPath.row]
        
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(indexPath.row) - \(post.username) - \(Date(timeIntervalSince1970: post.timestamp))"
        return cell
        
    }
   
        }
cd
extension PostListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= (PostController.posts.count - 1) {
            print(PostController.posts.count)
            PostController.fetchPosts(reset: false) {
                print(PostController.posts.count)
                
                self.reloadTableViews()
            }
        }
    }
}




       

   
  



