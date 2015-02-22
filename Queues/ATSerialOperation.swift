//
//  ATSerialOperation.swift
//  Queues
//
//  Created by Manuel Spuhler on 20/02/15.
//  Copyright (c) 2015 artefact.ch. All rights reserved.
//

import Foundation

typealias Task = (ATSerialOperation -> Void)

class ATSerialOperation: NSOperation {
    
    override var executing: Bool {
        get {
            return _executing
        }
        set {
            _executing = newValue
        }
    }
    
    override var finished: Bool {
        get {
            return _finished
        }
        set {
            _finished = newValue
        }
    }
    
    private var _executing = false
    private var _finished = false
    var task: Task
    
    init(task: Task) {
        self.task = task
    }
    
    override func start() {
        task(self)
        
        self.willChangeValueForKey("isExecuting")
        executing = true
        self.didChangeValueForKey("isExecuting")
    }
    
    func finish() {
        self.willChangeValueForKey("isExecuting")
        self.willChangeValueForKey("isFinished")
        executing = false
        finished = true;
        self.didChangeValueForKey("isExecuting")
        self.didChangeValueForKey("isFinished")
    }
    
    func isFinished() -> Bool {
        return self.isFinished()
    }
    
    func isExecuting() -> Bool {
        return self.isExecuting()
    }
}

