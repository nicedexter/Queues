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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        demo()
    }
    
    func demo() {
        println("start")
        let now = NSDate()
        
        let queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        let operation = ATSerialOperation({ task in
            println("#1 started")
            let url = NSURL(string: "http://transport.opendata.ch/v1/connections?from=Geneva&to=Zurich")
            let request = NSURLRequest(URL:url!)
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
                println("#1 finished")
                
                if (error != nil) {
                    println("#1 Handle error")
                }
                
                var jsonError: NSError?
                if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary {
                    
                    task.result = json
                    task.finish()
                }

            }).resume()
        })
        
        let operation2 = ATSerialOperation({ task in
            println(operation.result)
            println("#2 started")
            NSThread.sleepForTimeInterval(2)
            task.finish()
        })
        
        operation2.completionBlock = {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                println("#2 finished")
                println("isMainThread: \(NSThread.isMainThread())")
            })
        }

        queue.addOperations([operation, operation2], waitUntilFinished: false)
        
        println("end")
        let elapsed = NSDate().timeIntervalSinceDate(now)
        println("isMainThread: \(NSThread.isMainThread()), elapsed: \(elapsed)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

