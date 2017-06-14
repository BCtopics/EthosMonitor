//
//  StatusViewController.swift
//  EthosMonitor
//
//  Created by Bradley GIlmore on 6/13/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import UIKit
import UserNotifications

class StatusViewController: UIViewController {

    fileprivate let userNotificationIdentifier = "statusChangedNotification"
    
    func scheduleLocalNotification() {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Status Changed"
        notificationContent.body = "Status Changed"
        
        let fireDate = Date(timeInterval: 1, since: Date())
        
        let dateComponenets = Calendar.current.dateComponents([.minute, .second], from: fireDate)
        let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponenets, repeats: false)
        
        let request = UNNotificationRequest(identifier: userNotificationIdentifier, content: notificationContent, trigger: dateTrigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                NSLog("Unable to add notification request. \(error.localizedDescription)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animaetd)
        self.fetch()
    }

    func fetch() {
        
        StatusController.fetchStatus { (status) in
            
            if status.aliveGPUS == status.totalGPUS {
                DispatchQueue.main.async {
                    
                    self.statusTexLabel.text = "Working"
                    self.statusTexLabel.textColor = .green
                }
                NSLog("Working")
            }
            
            if status.aliveGPUS != status.totalGPUS {
                DispatchQueue.main.async {
                    
                    self.scheduleLocalNotification()
                    
                    self.statusTexLabel.text = "Miner is down"
                    self.statusTexLabel.textColor = .red
                }
                NSLog("Miner is down")
            }
            
        }
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var statusTexLabel: UILabel!
    

}
