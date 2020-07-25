//
//  CalendarController.swift
//  TaskManager
//
//  Created by Artem on 23.05.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit

class CalendarController: UIViewController, MonthViewDelegate, CalendarDateControllerDelegate {
    
    let monthView = MonthView()
    let weekdaysView = WeekdaysView()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(white: 0.3, alpha: 0.3)
        return view
    }()
    
    let calendarDateController = CalendarDateController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarDateController.delegate = self
        layoutSubviews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showTabBar()
    }
    
    fileprivate func showTabBar() {
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
            }
        }, completion: nil)
    }
    
    fileprivate func hideTabBar() {
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
        }, completion: nil)
    }
    
    fileprivate func layoutSubviews() {
        
        view.addSubview(monthView)
        
        monthView.translatesAutoresizingMaskIntoConstraints = false
        monthView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        monthView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        monthView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        monthView.delegate = self
        
        view.addSubview(weekdaysView)
        
        weekdaysView.translatesAutoresizingMaskIntoConstraints = false
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor, constant: 32).isActive = true
        weekdaysView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weekdaysView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        weekdaysView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        view.addSubview(separatorView)
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 8).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(calendarDateController.view)
        addChild(calendarDateController)
        
        calendarDateController.view.translatesAutoresizingMaskIntoConstraints = false
        calendarDateController.view.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16).isActive = true
        calendarDateController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calendarDateController.view.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        calendarDateController.view.heightAnchor.constraint(equalToConstant: 270).isActive = true
        
    }
    
    func didChangeMonth(month: Int, year: Int) {
        
        calendarDateController.selectedMonth = month + 1
        calendarDateController.selectedYear = year
        
        if month == 1 {
            if calendarDateController.selectedYear % 4 == 0 {
                calendarDateController.numberOfDaysInMonth[month] = 29
            } else {
                calendarDateController.numberOfDaysInMonth[month] = 28
            }
        }
        
        calendarDateController.firstWeekDayOfMonth = calendarDateController.getFirstWeekDay()
        
        //        DispatchQueue.main.async {
        self.calendarDateController.collectionView.reloadData()
        //        }
    }
    
    func presentTasksListController(tasksListController: TasksListController) {
        navigationController?.pushViewController(tasksListController, animated: true)
        navigationController?.navigationBar.backgroundColor = .white
        hideTabBar()
    }
    
}

