//
//  TasksViewController.swift
//  FirebaseTodo
//
//  Created by Тамирлан Абаев   on 12.04.2021.
//

import UIKit
import Firebase

class TasksViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var user: User!
    var ref:Firebase.DatabaseReference!
    var tasks = Array<Task>()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel!.text = task.title
        let isCompleted = task.completed
        toogleCompleted(cell, isCompleted: isCompleted)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            task.ref?.removeValue()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed
        toogleCompleted(cell, isCompleted: isCompleted)
        task.ref?.updateChildValues(["completed":isCompleted])
    }
    
    func toogleCompleted(_ cell:UITableViewCell, isCompleted:Bool) {
        
        cell.accessoryType = isCompleted ? .checkmark : .none
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Firebase.Auth.auth().currentUser else { return }
        user = User(user: currentUser)
        ref = Firebase.Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref.observe(.value) {[weak self] (snapshot) in
            var _tasks = Array<Task>()
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }
            self?.tasks = _tasks
            self?.tableView.reloadData()
        }
        
    }
    
    
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Task", message: "Add new task", preferredStyle: .alert)
        alertController.addTextField { _ in
        }
        
        let save = UIAlertAction(title: "Save", style: .default) {[weak self] _ in
            guard let textField = alertController.textFields?.first, textField.text != "" else {return}
            let task = Task(title: textField.text!, userId: (self?.user.uid)!)
            let taskRef = self?.ref.child(task.title.lowercased())
            taskRef?.setValue(task.convertToDictonary())
        }
        
        let cancle = UIAlertAction(title: "Cancle", style: .default) { _ in
        }
        alertController.addAction(save)
        alertController.addAction(cancle)
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
    

    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch  {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
