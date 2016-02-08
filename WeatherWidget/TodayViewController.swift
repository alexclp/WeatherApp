//
//  TodayViewController.swift
//  WeatherWidget
//
//  Created by Alexandru Clapa on 01/02/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
	
	@IBOutlet weak var weatherImage: UIImageView?
	@IBOutlet weak var currentTempLabel: UILabel?
	@IBOutlet weak var minTempLabel: UILabel?
	@IBOutlet weak var maxTempLabel: UILabel?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
