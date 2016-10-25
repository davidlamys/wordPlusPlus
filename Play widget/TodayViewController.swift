//
//  TodayViewController.swift
//  Play widget
//
//  Created by David Lam on 25/10/16.
//  Copyright © 2016 David Lam. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    
    @IBOutlet weak var wordLabel: UILabel!
     var taskManager = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


        taskManager = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
        RunLoop.main.add(taskManager, forMode: RunLoopMode.commonModes)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter().removeObserver(self)
        taskManager.invalidate()
    }
    
    func updateLabel() {
        guard let sharedDefaults = UserDefaults(suiteName: "group.WordPlusPlusExtensionSharingDefaults") else {
            return
        }
        wordLabel.text = sharedDefaults.string(forKey: "currentWord") ?? "remember your why"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
       self.updateLabel()
        completionHandler(NCUpdateResult.newData)
    }
    
}
