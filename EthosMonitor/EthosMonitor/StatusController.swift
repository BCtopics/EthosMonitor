//
//  StatusController.swift
//  EthosMonitor
//
//  Created by Bradley GIlmore on 6/13/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import Foundation

class StatusController {
    
    //MARK: - baseURL
    
    static let baseURL = URL(string: "http://3df0c9.ethosdistro.com/?json=yes")
    
    //MARK: - Fetch Method / GET
    
    static func fetchStatus(completion: @escaping (Status) -> Void){
        
        // Unwrapp baseURL
        guard let url = baseURL else { NSLog("baseURL was nil"); return }
        
        // Create URLParamaters
        let urlParameters = [
            "json" : "yes"
        ]
        
        // Perform Request
        NetworkController.performRequest(for: url, httpMethod: .get, urlParameters: urlParameters) { (data, error) in

            // Error Handle
            if let error = error {
                NSLog("Error performing fetch request. \(error.localizedDescription)")
                return
            }
            
            // Make sure data is there
            guard let data = data else { NSLog("Data was invalid"); return }
            
            //Serialize the json from the bits we get back
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] else { NSLog("Error during JSONSerialization"); return }
            
            // Create status objects
            guard let status = Status(dictionary: jsonDictionary) else {NSLog("Status was messed up"); return}
            
            completion(status)
        }
    }
    
}
