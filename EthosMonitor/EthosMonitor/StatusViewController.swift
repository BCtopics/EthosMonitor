//
//  StatusViewController.swift
//  EthosMonitor
//
//  Created by Bradley GIlmore on 6/13/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
