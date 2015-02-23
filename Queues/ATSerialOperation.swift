//
//  ATSerialOperation.swift
//  Queues
//
//  Created by Manuel Spuhler on 20/02/15.
//  Copyright (c) 2015 artefact.ch. All rights reserved.
//

import Foundation

typealias Task = (ATSerialOperation -> Void)
typealias Result = (AnyObject?, NSError?)

class ATSerialOperation: NSOperation {
    
    enum State {
        case Ready, Executing, Finished, Cancelled
        func keyPath() -> String {
            switch self {
            case Ready:
                return "isReady"
            case Executing:
                return "isExecuting"
            case Finished:
                return "isFinished"
            case Cancelled:
                return "isCancelled"
            }
        }
    }
    
    // MARK: - Public properties
    
    var task: Task
    var _result: Result?
    var result: Result? {
        get {return _result}
        set {
            _result = newValue
            state = .Finished
        }
    }
    
    // MARK: - Private properties
    
    var state: State {
        willSet {
            println("\(state.keyPath()) -> \(newValue.keyPath())")
            willChangeValueForKey(newValue.keyPath())
            willChangeValueForKey(state.keyPath())
        }
        didSet {
            didChangeValueForKey(oldValue.keyPath())
            didChangeValueForKey(state.keyPath())
        }
    }

    override var ready: Bool {
        return state == .Ready
    }
    
    override var executing: Bool {
        return state == .Executing
    }
    
    override var finished: Bool {
        return state == .Finished
    }
    
    override var cancelled: Bool {
        return state == .Cancelled
    }
    
    override var asynchronous: Bool {
        return true
    }
    
    // MARK: - Public methods
    
    init(task: Task) {
        self.task = task
        self.state = .Ready
        super.init()
    }
    
    override func start() {
        task(self)
        state = .Executing
    }
    
    func finish() {
        state = .Finished
    }
    
    override func cancel() {
        state = .Cancelled
    }

}
