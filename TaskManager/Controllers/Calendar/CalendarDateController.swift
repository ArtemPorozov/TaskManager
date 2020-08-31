//
//  CalendarDateController.swift
//  TaskManager
//
//  Created by Artem on 24.05.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit

protocol CalendarDateControllerDelegate {
    func presentTasksListController(tasksListController: TasksListController)
}

final class CalendarDateController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Public Properties
    
    var delegate: CalendarDateControllerDelegate?
    
    var firstWeekDayOfMonth: Int = 0
    var selectedMonth: Int = 0
    var selectedYear: Int = 0
    var numberOfDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    // MARK: - Private Properties
    
    private let cellId = "cellId"
    private var todaysDate: Int = 0
    private var currentMonth: Int = 0
    private var currentYear: Int = 0
    private var daysOfSelectedMonth: [String: Int] = [:]
    
    // MARK: - Initializers
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        super.init(collectionViewLayout: layout)
        
        initializeData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        registerCells()
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 7, height: 54)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let tasksListController = TasksListController(month: selectedMonth, year: selectedYear)
        
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarDateCell
        if let column = Int(cell.dateLabel.text ?? "1") {
            tasksListController.collectionView.layoutIfNeeded()
            tasksListController.collectionView.scrollToItem(at: [0, column], at: .centeredHorizontally, animated: true)
        }
        delegate?.presentTasksListController(tasksListController: tasksListController)
    }
    
    // MARK: - Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysInMonth[selectedMonth - 1] + firstWeekDayOfMonth - 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CalendarDateCell
        if indexPath.item <= firstWeekDayOfMonth - 3 {
            cell.isHidden = true
        } else {
            let date = indexPath.item - (firstWeekDayOfMonth - 3)
            cell.isHidden = false
            cell.dateLabel.text = "\(date)"
            
            if date == todaysDate && selectedYear == currentYear && selectedMonth == currentMonth {
                cell.dateLabel.backgroundColor = #colorLiteral(red: 1, green: 0.3416897995, blue: 0.4337002806, alpha: 1)
            } else {
                cell.dateLabel.backgroundColor = .white
            }
        }
        return cell
    }
    
    // MARK: - Public Methods
    
    func getFirstWeekDay() -> Int {
        let day = ("\(selectedYear)-\(selectedMonth)-01".date?.weekday)!
        return day == 1 ? 8 : day
    }
    
    // MARK: - Private Methods
    
    private func initializeData() {
        
        todaysDate = Calendar.current.component(.day, from: Date())
        currentMonth = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        selectedMonth = currentMonth
        selectedYear = currentYear
        firstWeekDayOfMonth = getFirstWeekDay()
        
        if selectedMonth == 2 && selectedYear % 4 == 0 {
            numberOfDaysInMonth[selectedMonth - 1] = 29
        }
    }
    
    private func setupViews() {
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
    }
    
    private func registerCells() {
        
        collectionView.register(CalendarDateCell.self, forCellWithReuseIdentifier: cellId)
    }
    
}
