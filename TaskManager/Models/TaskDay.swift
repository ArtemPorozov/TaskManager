//
//  TaskDay.swift
//  TaskManager
//
//  Created by Artem on 14.06.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import RealmSwift

class TaskDay: Object {
    
    @objc dynamic var date: String = ""
    @objc dynamic var weekday: String = ""
    @objc dynamic var month: String = ""
    @objc dynamic var year: String = ""
    
    @objc dynamic var id: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var tasks = List<TaskForDay>()
}
