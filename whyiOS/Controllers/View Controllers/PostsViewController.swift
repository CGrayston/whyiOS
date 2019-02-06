//
//  PostsViewController.swift
//  whyiOS
//
//  Created by Chris Grayston on 2/6/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Source of Truth
    //    static var posts: [Post] = PostController.fetchPosts { (posts) in
    //        PostsViewController.posts = posts ?? []
    //    }
    var fetchedPosts: [Post] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //        self.fetchedPosts =
        
        self.fetchPostsAndRefreshTableView()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        let addPostAlertController = UIAlertController(title: "What is your reason?", message: nil, preferredStyle: .alert)
        
        var nameTextField = UITextField()
        var cohortTextField = UITextField()
        var reasonTextField = UITextField()
        
        addPostAlertController.addTextField { (textField) in
            nameTextField = textField
            nameTextField.placeholder = "Enter your name..."
        }
        
        addPostAlertController.addTextField { (textField) in
            cohortTextField = textField
            cohortTextField.placeholder = "Enter your cohort..."
        }
        
        addPostAlertController.addTextField { (textField) in
            reasonTextField = textField
            reasonTextField.placeholder = "Enter your reason for enrolling..."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        let postAction = UIAlertAction(title: "Post", style: .default) { (_) in
            if let name = nameTextField.text, !name.isEmpty,
            let cohort = cohortTextField.text, !cohort.isEmpty,
                let reason = reasonTextField.text, !reason.isEmpty {
                PostController.postReason(cohort: cohort, name: name, reason: reason, completion: { (success) in
                    if success {
                        self.fetchPostsAndRefreshTableView()
                    } else {
                        print("Error posting from message alert")
                    }
                })
            }
        }
        
        addPostAlertController.addAction(cancelAction)
        addPostAlertController.addAction(postAction)
        
        self.present(addPostAlertController, animated: true)
        
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        fetchPostsAndRefreshTableView()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell()}
        
        let post = fetchedPosts[indexPath.row]
        cell.nameTextLabel.text = post.name
        cell.cohortTextLabel.text = post.cohort
        cell.reasonTextLabel.text = post.reason
        
        return cell
    }
    
    func fetchPostsAndRefreshTableView() {
        PostController.fetchPosts { (posts) in
            if let posts = posts {
                self.fetchedPosts = posts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
