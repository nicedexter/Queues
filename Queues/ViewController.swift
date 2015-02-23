//
//  ViewController.swift
//  Queues
//
//  Created by Manuel Spuhler on 17/02/15.
//  Copyright (c) 2015 artefact.ch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        demo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Public
    
    func demo() {
        let queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        let operation = ATSerialOperation {task in
            println("#1 started")
            self.asyncCall {task.result = $0}
//          == self.asyncCall {(json, error) in task.result = (json, error)}
        }
        
        let operation2 = ATSerialOperation {task in
            println("#2 started")
            
            if let result = operation.result as? (NSDictionary, NSError) {
                println("result1: \(result.0.count)")
            }
            
            self.asyncCall {task.result = $0}
        }
        
        operation2.completionBlock = {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if let result = operation2.result as? (NSDictionary, NSError) {
                    println("result2: \(result.0.count)")
                }
            })
        }

        queue.addOperations([operation, operation2], waitUntilFinished: false)
    }
    
    // MARK: async dummy function
    
    func asyncCall(block: (json: AnyObject?, error: NSError?) -> Void) {
        let url = NSURL(string: "http://transport.opendata.ch/v1/connections?from=Geneva&to=Zurich")
        let request = NSURLRequest(URL:url!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            if (error != nil) {
                block(json: nil, error: error)
            }
            
            var jsonError: NSError?
            if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary {
                
                if (jsonError != nil) {
                    block(json: nil, error: jsonError)
                }
                
                block(json: json, error: nil)
            }
        }).resume()
    }

}
