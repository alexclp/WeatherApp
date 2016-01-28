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
		
	}
	
	@IBAction func switchValueChanged(sender: AnyObject) {
		if locationModeSwitch.on {
			cityCell.hidden = true
		} else {
			cityCell.hidden = false
		}
	}
	
	@IBAction func unitChanged(sender: AnyObject) {
	
	}
	
	// MARK: Table View Stuff
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("Click at index: \(indexPath)")
		if indexPath.row == 1 && indexPath.section == 0 {
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
			performSegueWithIdentifier("showMapSegue", sender: self)
		}
	}
	
	// MARK: Text Field Delegate
	
	func textFieldDidEndEditing(textField: UITextField) {
		
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		NSUserDefaults.standardUserDefaults().setObject(cityTextField.text, forKey: "city")
		NSUserDefaults.standardUserDefaults().synchronize()
		
		cityTextField.resignFirstResponder()
		
		return true
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
