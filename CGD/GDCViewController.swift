//
//  GDCViewController.swift
//  KVO_cancel
//
//  Created by Vincenzo Stira on 29/04/16.
//  Copyright © 2016 VIncenzo Stira. All rights reserved.
//

import UIKit

class GDCViewController: UIViewController {
    
    
    @IBOutlet weak var myLabel: UILabel!

    @IBOutlet weak var my2Label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.yellowColor()
        
        my2Label.hidden = true
        
        
        //Create a queue
        let workingQueue = dispatch_queue_create("my_queue", nil)
        
        let attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_USER_INITIATED, 0)
        let workingQueue2 = dispatch_queue_create("com.vincenzostira", attr)
        
        dispatch_async(workingQueue2, <#T##block: dispatch_block_t##dispatch_block_t##() -> Void#>)
        
        // Dispatch to the newly created queue. GCD take the responsibility for most things.
        dispatch_async(workingQueue) {
            // Async work in workingQueue
            let label = String(CString: dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), encoding: NSUTF8StringEncoding)
            print(label)
            
            print("Working...")
            self.my2Label.hidden = false
            self.my2Label.text = "I'm on second thread"
            
            NSThread.sleepForTimeInterval(2)  // Simulate for 2 secs executing time
            
            dispatch_async(dispatch_get_main_queue()) {
                // Return to main queue, update UI here
                print("Work done. Update UI")
                self.my2Label.hidden = true
                self.view.backgroundColor = UIColor.redColor()
                self.myLabel.text = "Work Done!"
            }
        }
        
        myLabel.text = "I'm on main thread..."

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
