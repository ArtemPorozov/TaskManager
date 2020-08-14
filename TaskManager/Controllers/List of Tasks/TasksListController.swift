//
//  TasksListController.swift
//  TaskManager
//
//  Created by Artem on 26.05.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit
import RealmSwift

class TasksListController: UICollectionViewController, AddingTaskControllerDelegate {
    
    // MARK: - Nested Types
    
    private struct Day {
        let date, monthIndex, year: Int
        let month: String
        let weekday: String
    }
    
    private enum CellType: String {
        case dayHeader
        case day
        case taskHeader
        case taskName
    }
    
    // MARK: - Private Properties
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let todaysDate = Calendar.current.component(.day, from: Date())
    private let currentMonth = Calendar.current.component(.month, from: Date())
    private let currentYear = Calendar.current.component(.year, from: Date())
    
    private var days = [Day]()
    private let month: Int
    private let year: Int
    
    private var tasks: Results<Task>?
    private var taskDays: Results<TaskDay>?
    
    private var addingTaskController: AddingTaskController? {
        didSet {
            addingTaskController?.delegate = self
        }
    }
    
    // MARK: - Initializers
    
    init(month: Int, year: Int) {
        let layout = DayTasksProgressLayout()
        self.month = month
        self.year = year
        super.init(collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        setupCollectionView()
        getDaysForSelectedMonth(monthIndex: month, year: year)
        readTasks()
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateCollectionView()
    }
    
    // MARK: - Collection View Delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            if indexPath.section == 0 {
                print("TaskNameHeaderCell")
            } else {
                print("TaskNameCell")
                guard let task = tasks?[indexPath.section - 1] else { return }
                let taskController = TaskController(task: task)
                navigationController?.pushViewController(taskController, animated: true)
            }
        } else {
            if indexPath.section == 0 {
                print("DayHeaderCell")
            } else {
                print("DayCell")
                let cell = collectionView.cellForItem(at: indexPath) as! DayCell
                
                if cell.progressLabel.text == "" && indexPath.item <= todaysDate {
                    cell.progressLabel.text = "+"
                    createDayEntity(for: indexPath)
                } else if cell.progressLabel.text == "+" {
                    
                    var taskForDayToPresent = TaskForDay()
                    
                    let day = days[indexPath.item - 1]
                    guard let taskDays = taskDays else { return }
                    
                    for taskDay in taskDays {
                        if (taskDay.date == String(day.date)) && (taskDay.month == day.month) && (taskDay.year == String(day.year)) {
                            
                            let task = tasks?[indexPath.section - 1]
                            for taskForDay in taskDay.tasks {
                                if taskForDay.id == task?.id {
                                    taskForDayToPresent = taskForDay
                                }
                            }
                        }
                    }
                    let vc = TaskForSelectedDayController(task: taskForDayToPresent)
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        if indexPath.row == 0 {
            if indexPath.section == 0 {
                return nil
            } else {
                let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
                    let action = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill")) { action in
                        self.deleteTask(indexPath: indexPath)
                    }
                    return UIMenu(title: "", children: [action])
                }
                return configuration
            }
        } else {
            if indexPath.section == 0 {
                return nil
            } else {
                let cell = collectionView.cellForItem(at: indexPath) as! DayCell
                if cell.progressLabel.text == "+" {
                    let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
                        let action = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill")) { action in
                            self.deleteTaskForDay(indexPath: indexPath)
                        }
                        return UIMenu(title: "", children: [action])
                    }
                    return configuration
                } else {
                    return nil
                }
            }
        }
    }
    
    // MARK: - Collection View Data Source
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let tasks = tasks {
            return tasks.count + 1
        }
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.taskHeader.rawValue, for: indexPath) as! TaskNameHeaderCell
                setBordersForCell(cell)
                cell.nameLabel.text = "Tasks"
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.taskName.rawValue, for: indexPath) as! TasksNameCell
                setBordersForCell(cell)
                let task = tasks?[indexPath.section - 1]
                cell.nameLabel.text = task?.name
                
                if let color = task?.color {
                    setColorForCell(color: color, for: cell)
                } else {
                    cell.backgroundColor = .white
                }
                return cell
            }
        } else {
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.dayHeader.rawValue, for: indexPath) as! DayHeaderCell
                let day = days[indexPath.item - 1]
                cell.dateLabel.text = String(day.date)
                cell.weekdayLabel.text = String(day.weekday)
                
                if Int(cell.dateLabel.text!) == todaysDate && year == currentYear && month == currentMonth {
                    cell.backgroundColor = #colorLiteral(red: 1, green: 0.3416897995, blue: 0.4337002806, alpha: 1)
                } else {
                    cell.backgroundColor = .white
                }
                setBordersForCell(cell)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.day.rawValue, for: indexPath) as! DayCell
                setBordersForCell(cell)
                cell.progressLabel.text = ""
                
                let day = days[indexPath.item - 1]
                guard let taskDays = taskDays else { return cell }
                
                for taskDay in taskDays {
                    if (taskDay.date == String(day.date)) && (taskDay.month == day.month) && (taskDay.year == String(day.year)) {
                        
                        let task = tasks?[indexPath.section - 1]
                        for taskForDay in taskDay.tasks {
                            if taskForDay.id == task?.id {
                                cell.progressLabel.text = "+"
                            }
                        }
                    }
                }
                return cell
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        navigationItem.title = "List of Tasks"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setRightBarButton(.init(barButtonSystemItem: .add, target: self, action: #selector(addNewTask)), animated: true)
    }
    
    @objc private func addNewTask() {
        
        let addingTaskController = AddingTaskController()
        self.addingTaskController = addingTaskController
        present(UINavigationController(rootViewController: addingTaskController), animated: true, completion: nil)
    }
    
    private func setupViews() {
        
        view.addSubview(monthLabel)
        monthLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        monthLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        monthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        monthLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        monthLabel.text = "\(Calendar.current.monthSymbols[month - 1]) \(year)"
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
    }
    
    private func getDaysForSelectedMonth(monthIndex: Int, year: Int) {
        
        let numberOfDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        let month = Calendar.current.monthSymbols[monthIndex - 1]
        let numberOfDaysInSelectedMonth = numberOfDaysInMonth[monthIndex - 1]
        let weekdays = [2: "Mo", 3: "Tu", 4: "We", 5: "Th", 6: "Fr", 7: "Sa", 8: "Su"]
        
        for number in 1...numberOfDaysInSelectedMonth {
            
            guard var weekdayIndex = ("\(year)-\(monthIndex)-\(number)".date?.weekday) else { return }
            if weekdayIndex == 1 {
                weekdayIndex = 8
            }
            guard let weekday = weekdays[weekdayIndex] else { return }
            let day = Day(date: number, monthIndex: monthIndex, year: year, month: month, weekday: weekday)
            days.append(day)
        }
    }
    
    private func readTasks(){
        
        let realm = try! Realm()
        tasks = realm.objects(Task.self)
        taskDays = realm.objects(TaskDay.self)
    }
    
    private func registerCells() {
        collectionView.register(TasksNameCell.self, forCellWithReuseIdentifier: CellType.taskName.rawValue)
        collectionView.register(TaskNameHeaderCell.self, forCellWithReuseIdentifier: CellType.taskHeader.rawValue)
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: CellType.day.rawValue)
        collectionView.register(DayHeaderCell.self, forCellWithReuseIdentifier: CellType.dayHeader.rawValue)
    }
    
    private func setBordersForCell(_ cell: UICollectionViewCell) {
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    private func createDayEntity(for indexPath: IndexPath) {
        
        let taskDay = TaskDay()
        
        let day = days[indexPath.item - 1]
        
        taskDay.date = String(day.date)
        taskDay.weekday = day.weekday
        taskDay.month = day.month
        taskDay.year = String(year)
        taskDay.id = taskDay.date + taskDay.month + taskDay.year
        
        let taskForDay = TaskForDay()
        
        if let task = tasks?[indexPath.section - 1] {
            taskForDay.name = task.name
            taskForDay.id = task.id
            taskForDay.dayId = taskDay.id
        }
        
        let realm = try! Realm()
        
        if let taskDay = realm.object(ofType: TaskDay.self, forPrimaryKey: taskDay.id) {
            try! realm.write {
                taskDay.tasks.append(taskForDay)
            }
        } else {
            try! realm.write {
                realm.add(taskDay)
                taskDay.tasks.append(taskForDay)
            }
        }
    }
    
    private func deleteTask(indexPath: IndexPath) {
        
        guard let task = self.tasks?[indexPath.section - 1] else { return }
        let realm = try! Realm()
        let tasksForDay = realm.objects(TaskForDay.self)
        
        try! realm.write {
            for taskForDay in tasksForDay {
                if taskForDay.name == task.name && taskForDay.id == task.id {
                    realm.delete(taskForDay)
                }
            }
            realm.delete(task)
        }
        collectionView.reloadData()
    }
    
    private func deleteTaskForDay(indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! DayCell
        if cell.progressLabel.text == "+" {
            var taskForDayToDelete = TaskForDay()
            let day = self.days[indexPath.item - 1]
            guard let taskDays = taskDays else { return }
            
            for taskDay in taskDays {
                if (taskDay.date == String(day.date)) && (taskDay.month == day.month) && (taskDay.year == String(day.year)) {
                    
                    let task = self.tasks?[indexPath.section - 1]
                    for taskForDay in taskDay.tasks {
                        if taskForDay.id == task?.id {
                            taskForDayToDelete = taskForDay
                        }
                    }
                }
            }
            let realm = try! Realm()
            
            try! realm.write {
                realm.delete(taskForDayToDelete)
            }
            cell.progressLabel.text = ""
            collectionView.reloadData()
        }
    }
    
    private func setColorForCell(color: TaskColor, for cell: UICollectionViewCell) {
        
        let red = CGFloat(color.colorComponents[0])
        let green = CGFloat(color.colorComponents[1])
        let blue = CGFloat(color.colorComponents[2])
        let alpha = CGFloat(color.colorComponents[3])
        let taskColor = CGColor.init(srgbRed: red, green: green, blue: blue, alpha: alpha)
        cell.backgroundColor = UIColor.init(cgColor: taskColor)
    }
    
    // MARK: - AddingTaskControllerDelegate
    
    func updateCollectionView() {
        self.collectionView.reloadData()
    }
    
}
