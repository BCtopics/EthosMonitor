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

    //MARK: - Timer
    
    var timer: DispatchSourceTimer?
    
    func startTimer() {
        let queue = DispatchQueue(label: "com.domain.app.ethosMonitor")  // you can also use `DispatchQueue.main`, if you want
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.scheduleRepeating(deadline: .now(), interval: .seconds(120))
        timer!.setEventHandler { [weak self] in
            self?.fetch()
        }
        timer!.resume()
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    deinit {
        self.stopTimer()
    }
    
    //MARK: - Notifications
    
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
    
    //MARK: - General Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
    }

    //MARK: - Fetch Request
    
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
