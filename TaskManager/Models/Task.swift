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
    @objc dynamic var color: TaskColor?
    
    var subtasks = List<Subtask>()
}

class TaskColor: Object {
    let colorComponents = List<Float>()
}
