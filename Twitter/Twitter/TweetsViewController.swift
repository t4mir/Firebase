//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Тамирлан Абаев   on 18.04.2021.
//

import UIKit
import Firebase
import FirebaseDatabase

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var current_user: User?
    var filteredData: [Tweet]!
    var tweets:[Tweet] = []
    var ref = Database.database().reference()
    
    @IBOutlet weak var myTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = tweets[indexPath.row].content
        cell.detailTextLabel?.text = tweets[indexPath.row].author
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            let ref = Database.database().reference().child("tweets").child((self.filteredData![indexPath.row].selectId)!)
//            ref.removeValue()
//            tweets.remove(at: indexPath.row)
//            self.filteredData!.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let ref = (Database.database().reference().child("tweets").child(tweets[indexPath.row].selectId!))
//            ref.removeValue()
//            tweets.remove(at: indexPath.row)
//            self.filteredData.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
            ref.removeValue()
            tableView.reloadData()
        }
      
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        current_user = Auth.auth().currentUser
        
        let parent = ref.child("tweets")
        parent.observe(.value) {[weak self] (snapshot) in
            self?.tweets.removeAll()
            for child in snapshot.children {
                if let snap = child as? DataSnapshot {
                    let tweet = Tweet(snapshot: snap)
                    self?.tweets.append(tweet)
                }
            }
            self?.tweets.reverse()
            self?.myTableView.reloadData()
            
        }
        self.filteredData = tweets
        
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error 404")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New tweet", message: "Enter a text", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Tweet"
        }
 
        alert.addAction(UIAlertAction(title: "Tweet", style: .default, handler: {[weak self,weak alert]  (_) in
            
            let textField = alert?.textFields![0]
            let selectId = Database.database().reference().child("tweets").childByAutoId()
            let tweet = Tweet(textField!.text!, (self?.current_user?.email)!,(selectId.key)!)
            self?.ref.child("tweets").childByAutoId().setValue(tweet.dict)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    

}
