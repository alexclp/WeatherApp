//
//  SettingsViewController.swift
//  Weather
//
//  Created by Alexandru Clapa on 27/01/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Eureka

class SettingsViewController: UITableViewController, UINavigationBarDelegate  {

	@IBOutlet weak var locationModeSwitch: UISwitch!
	@IBOutlet weak var unitsSegmentedControl: UISegmentedControl!
	@IBOutlet weak var cityCell: UITableViewCell!
	@IBOutlet weak var cityTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
//		createNavBar()
		
	}
	
	@IBAction func switchValueChanged(sender: AnyObject) {
	}
	@IBAction func unitChanged(sender: AnyObject) {
	}
	func createNavBar() {
		// Create the navigation bar
		let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 60)) // Offset by 20 pixels vertically to take the status bar into account
		
		navigationBar.backgroundColor = UIColor.whiteColor()
		navigationBar.delegate = self;
		
		let navigationItem = UINavigationItem()
		navigationItem.title = "Title"
		
		let rightButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonClicked:")
		
		navigationItem.rightBarButtonItem = rightButton
		
		navigationBar.items = [navigationItem]
		
		self.view.addSubview(navigationBar)
	}

	
	
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showWeatherSegue" {
//			Save data
		}
    }
	
	@IBAction func doneButtonClicked(sender: UIBarButtonItem) {
		performSegueWithIdentifier("showWeatherSegue", sender: nil)
	}

}
