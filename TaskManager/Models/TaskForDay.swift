//
//  TaskForDay.swift
//  TaskManager
//
//  Created by Artem on 03.07.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import RealmSwift

class TaskForDay: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var id: String = ""
//    @objc dynamic var day: TaskDay?
    @objc dynamic var dayId: String = ""

    
//    @objc dynamic var isCompleted: Bool = false
    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
    
    var subtasks = List<Subtask>()
}
