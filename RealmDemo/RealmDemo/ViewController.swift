//
//  ViewController.swift
//  RealmDemo
//
//  Created by deng on 2017/2/13.
//  Copyright © 2017年 dengyonghao. All rights reserved.
//

import UIKit
import RealmSwift
// v1
final class Task: Object {
    // realm 没有自增属性
    dynamic var id = NSUUID().uuidString
    dynamic var text = ""
    dynamic var completed = false
    
    // 主键
    override static func primaryKey() -> String? {
        return "id"
    }
}

// v2
//final class Task: Object {
//    // realm 没有自增属性
//    dynamic var id = NSUUID().uuidString
//    dynamic var text = ""
//    dynamic var completed = false
//    dynamic var date = NSDate()
//    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
//}

class ViewController: UITableViewController {
    
    var tasks: Results<Task>!
    var notificationToken: NotificationToken!
    var realm: Realm!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI();
        setupRealm()
        getTodoList()
        addNotification()
    }
    
    private func prepareUI() {
        title = "TODO"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "kTodoCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTodo))
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    private func setupRealm() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let filePath = paths[0] + "/default.realm"
        print(filePath)
        
        var realmConfiguration = Realm.Configuration()
        realmConfiguration.fileURL = URL(fileURLWithPath: filePath)
        
        // 用于数据库迁移
        realmConfiguration.schemaVersion = 1
        
        realmConfiguration.migrationBlock = { migration, oldSchemaVersion in
            
            migration.enumerateObjects(ofType: Task.className()) { oldObject, newObject in
                if oldSchemaVersion < 1 {
                    let text = oldObject!["text"] as! String
                    newObject!["text"] = "\(text)+\(text)"
                    
//                    migration.renameProperty(onType: Task.className(), from: "text", to: "text2")
                }
                
                
//                if oldSchemaVersion < 2 {
//                    newObject!["date"] = NSDate()
//                }
            }
                
        }
        
        realm = try! Realm(configuration: realmConfiguration)
    }
    
    private func getTodoList() {
        // 查询
        tasks = realm.objects(Task.self)
//        tasks = realm.objects(Task.self).filter("completed = false")
        self.tableView.reloadData()
    }
    
    @objc fileprivate func addTodo() {
        let alertController = UIAlertController(title: "new todo", message: "enter todo name", preferredStyle: .alert)
        var alertTextField: UITextField!
        alertController.addTextField { (textField) in
            alertTextField = textField
            textField.placeholder = "todo Name"
        }
        
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            guard let text = alertTextField.text , !text.isEmpty else { return }
            
            try! self.realm.write {
                let task = Task(value: ["text": text])
                // 添加
                self.realm.add(task)
            }
        })
        present(alertController, animated: true, completion: nil)
    }
    
    private func addNotification() {
        notificationToken = tasks.addNotificationBlock({ (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.tableView.reloadData()
                break
            case .update(_, deletions: _, insertions: _, modifications: _):
                self.getTodoList()
                break
            case .error(let err):
                fatalError("\(err)")
                break
            }
        })
    }
    
    // MARK: TableView delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kTodoCell", for: indexPath)
        let item = tasks[indexPath.row]
        cell.textLabel?.text = item.text;
        cell.textLabel?.alpha = item.completed ? 0.5 : 1
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                let item = tasks[indexPath.row]
                // 删除
                self.realm.delete(item)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = tasks[indexPath.row]
        if !item.completed {
            try! realm.write {
                let item = tasks[indexPath.row]
                item.completed = !item.completed
                // 更新
                self.realm.add(item, update: true)
            }
        }
        
    }
}

