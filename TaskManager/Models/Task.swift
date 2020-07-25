//
//  Task.swift
//  TaskManager
//
//  Created by Artem on 14.06.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import RealmSwift

class Task: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var id = UUID().uuidString
//    @objc dynamic var isCompleted: Bool = false
    @objc dynamic var color: TaskColor?
    
    var subtasks = List<Subtask>()
    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
}

class TaskColor: Object {
//    let colorName = ""
    let colorComponents = List<Float>() //this will be an array of [r, g, b, a]
}
