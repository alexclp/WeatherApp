//
//  ViewController.swift
//  Weather
//
//  Created by Alexandru Clapa on 23/01/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	var days = [WeatherDay]()
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		
		WeatherProvider.provideWeatherForCoordinates(51.5072, longitude: 0.1275) { (days) -> Void in
			self.days.appendContentsOf(days)
			self.tableView.reloadData()
		}
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
		
		let current = days[indexPath.row]
		
		cell.textLabel?.text = current.briefDesc
		cell.detailTextLabel?.text = current.longDesc
		
		return cell
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return days.count
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}

