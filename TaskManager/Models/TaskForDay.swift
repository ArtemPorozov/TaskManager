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
    @objc dynamic var dayId: String = ""

    var subtasks = List<Subtask>()
}
