//
//  SettingsViewController.swift
//  Weather
//
//  Created by Alexandru Clapa on 27/01/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Eureka

class SettingsViewController: UITableViewController, UITextFieldDelegate  {

	@IBOutlet weak var locationModeSwitch: UISwitch!
	@IBOutlet weak var unitsSegmentedControl: UISegmentedControl!
	@IBOutlet weak var cityCell: UITableViewCell!
	@IBOutlet weak var cityTextField: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.title = "Settings"
		
		setupView()
	}
	
	@IBAction func switchValueChanged(sender: AnyObject) {
		if locationModeSwitch.on {
			cityCell.hidden = true
			
			NSUserDefaults.standardUserDefaults().setBool(true, forKey: "autoLocation")
		} else {
			cityCell.hidden = false
			
			NSUserDefaults.standardUserDefaults().setBool(false, forKey: "autoLocation")
		}
		
		NSUserDefaults.standardUserDefaults().synchronize()
	}
	
	@IBAction func unitChanged(sender: AnyObject) {
		if unitsSegmentedControl.selectedSegmentIndex == 0 {
			NSUserDefaults.standardUserDefaults().setObject("metric", forKey: "units")
		} else {
			NSUserDefaults.standardUserDefaults().setObject("imperial", forKey: "units")
		}
		
		NSUserDefaults.standardUserDefaults().synchronize()
	}
	
	func setupView() {
		if let unit = NSUserDefaults.standardUserDefaults().objectForKey("units") {
			if unit as! String == "metric" {
				unitsSegmentedControl.selectedSegmentIndex = 0
			} else if unit as! String == "imperial" {
				unitsSegmentedControl.selectedSegmentIndex = 1
			}
		}
		
		if let automatic = NSUserDefaults.standardUserDefaults().objectForKey("autoLocation") {
			if automatic as! Bool {
				locationModeSwitch.on = true
				cityCell.hidden = true
			} else {
				locationModeSwitch.on = false
				cityCell.hidden = false
			}
		}
	}
	
	// MARK: Table View Stuff
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.row == 1 && indexPath.section == 0 {
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
			performSegueWithIdentifier("showMapSegue", sender: self)
		}
	}
	
	@IBAction func doneButtonClicked(sender: UIBarButtonItem) {
		performSegueWithIdentifier("showWeatherSegue", sender: nil)
	}

}
