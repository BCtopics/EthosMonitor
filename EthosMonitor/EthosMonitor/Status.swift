//
//  Status.swift
//  EthosMonitor
//
//  Created by Bradley GIlmore on 6/13/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import Foundation

class Status {
    
    //MARK: - Private Keys
    
    private let kAlive = "alive_gpus"
    private let kTotal = "total_gpus"
    
    //MARK: - Properties
    
    var aliveGPUS: Int
    var totalGPUS: Int
    
    //MARK: - Initializers
    
    init(aliveGPUS: Int, totalGPUS: Int) {
        self.aliveGPUS = aliveGPUS
        self.totalGPUS = totalGPUS
    }
    
    init?(dictionary: [String: Any]) {
        guard let alive = dictionary[kAlive] as? Int,
            let total = dictionary[kTotal] as? Int else { return nil }
        
        self.aliveGPUS = alive
        self.totalGPUS = total
        
    }
    
}
