//
//  TabBarController.swift
//  TaskManager
//
//  Created by Artem on 23.05.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createNavigationController(viewController: CalendarController(), title: "Daily Tasks", imageName: "calendar"),
            createNavigationController(viewController: StatisticsController(), title: "Statistics", imageName: "statistics")
        ]
    }
    
    fileprivate func createNavigationController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.backgroundColor = .white
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(named: imageName)
        
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
                
        return navigationController
    }
}
