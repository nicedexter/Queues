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
        
        let operation = ATSerialOperation({ block in
            println("#1 started")
            let url = NSURL(string: "http://transport.opendata.ch/v1/connections?from=Geneva&to=Zurich")
            let request = NSURLRequest(URL:url!)
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
                println("#1 finished")
                block.finish()
            })
            task.resume()
        })
        
        let operation2 = ATSerialOperation({ block in
            println("#2 started")
            NSThread.sleepForTimeInterval(2)
            println("#2 finished")
            block.finish()
        })
        
        // If waitUntilFinished is true, it blocks the main Thread until finished.
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
            queue.addOperations([operation, operation2], waitUntilFinished: true)
            println("#1-#2 finished")
        })
        
//        queue.addOperations([operation, operation2], waitUntilFinished: false)
        
        println("end")
        let elapsed = NSDate().timeIntervalSinceDate(now)
        println("isMainThread: \(NSThread.isMainThread()), elapsed: \(elapsed)")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

