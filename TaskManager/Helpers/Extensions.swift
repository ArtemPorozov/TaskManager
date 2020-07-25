//
//  Extensions.swift
//  TaskManager
//
//  Created by Artem on 26.05.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit

//get first day of the month
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
}

extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
