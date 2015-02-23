# Simple Serialized Asynchronous Tasks

Subclass of NSOperation to perform serialized async blocks of tasks.

Like Promises, but dead simple.

```
let queue = NSOperationQueue()
queue.maxConcurrentOperationCount = 1

let operation1 = ATSerialOperation({ task in
    NSThread.sleepForTimeInterval(2)
    task.finish()
})

let operation2 = ATSerialOperation({ task in
    if let result: AnyObject = operation1.result {}
    NSThread.sleepForTimeInterval(2)
    task.finish()
})

operation2.completionBlock = {
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
      // update UI
    })
}

queue.addOperations([operation, operation2], waitUntilFinished: false)

```
