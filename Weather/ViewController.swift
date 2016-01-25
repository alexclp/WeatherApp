//
//  ViewController.swift
//  Weather
//
//  Created by Alexandru Clapa on 23/01/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

	var days = [WeatherDay]()
	let locationManager = CLLocationManager()
	
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.tableView.registerNib(UINib(nibName: "WeatherForecastCustomCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
		
		self.locationManager.requestWhenInUseAuthorization()
		
		if CLLocationManager.locationServicesEnabled() {
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
			locationManager.startUpdatingLocation()
		}
	}
	
	func fetchDataForCoordinates(latitude: Double, longitude: Double) {
		WeatherProvider.provideWeatherForCoordinates(latitude, longitude) { (days) -> Void in
			self.days = days
			self.tableView.reloadData()
		}
	}
	
//	MARK: TABLE VIEW METHODS

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell", forIndexPath: indexPath) as! WeatherForecastCustomCell
		
		let current = days[indexPath.row]
		cell.weatherImage?.image = UIImage(contentsOfFile: "placeholder.png")
//		cell.minLabel?.text = current.minTemp
//		cell.maxLabel?.text = current.maxTemp
		cell.descLabel?.text = current.briefDesc
		
		if let minTemp = current.minTemp {
			cell.minLabel?.text = minTemp
		}
		
		if let maxTemp = current.maxTemp {
			cell.maxLabel?.text = maxTemp
		}
		
		if let desc = current.briefDesc {
			cell.descLabel?.text = desc
		}
	
		print("min: \(current.minTemp)")
		
		return cell
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return days.count
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
//	MARK: LOCATION
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let location: CLLocationCoordinate2D = manager.location!.coordinate
		
		fetchDataForCoordinates(location.latitude, longitude: location.longitude)
		self.locationManager.stopUpdatingLocation()
	}
}

