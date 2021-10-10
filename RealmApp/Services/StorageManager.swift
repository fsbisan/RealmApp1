//
//  StorageManager.swift
//  RealmApp
//
//  Created by Alexey Efimov on 07.10.2021.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import RealmSwift

class StorageManager {
    static let shared = StorageManager()
    let realm = try! Realm()
    
    private init() {}
    
    // MARK: - TaskList
    func save(_ taskLists: [TaskList]) {
        write {
            realm.add(taskLists)
        }
    }
    
    func save(_ taskList: TaskList) {
        write {
            realm.add(taskList)
        }
    }
    
    func delete(_ taskList: TaskList) {
        write {
            realm.delete(taskList.tasks)
            realm.delete(taskList)
        }
    }
    
    func edit(_ taskList: TaskList, newValue: String) {
        write {
            taskList.name = newValue
        }
    }
    
    func done(_ taskList: TaskList) {
        write {
            taskList.tasks.setValue(true, forKey: "isComplete")
        }
    }
    
    // MARK: - Tasks
    func save(_ task: Task, to taskList: TaskList) {
        write {
            taskList.tasks.append(task)
        }
    }
    
    func deleteTask(_ task: Task) {
        write {
            realm.delete(task)
        }
    }
    
    func editTask(_ task: Task, newValue: String, newNote: String) {
        write {
            task.name = newValue
            task.note = newNote
        }
    }
    
    func doneTaskToggle(_ task: Task, sectionIndexPath: Int) {
        var isComplete = true
        if sectionIndexPath == 1 {
            isComplete = false
        }
        write {
            task.setValue(isComplete, forKey: "isComplete")
        }
    }
    
    private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch let error {
            print(error)
        }
    }
}
