//
//  ViewController.swift
//  Weather
//
//  Created by Alexandru Clapa on 23/01/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import CoreLocation
import AlamofireImage
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

	let basicImageURL = "http://openweathermap.org/img/w/"
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
	
	func stringFromDate(date: NSDate) -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //format style. Browse online to get a format that fits your needs.
		let dateString = dateFormatter.stringFromDate(date)
		
		return dateString
	}
	
	func getDayOfWeek(today: String) -> String {
		
		let formatter  = NSDateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let todayDate = formatter.dateFromString(today)!
		let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
		let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
		let weekDay = myComponents.weekday
		
		let days: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
		
		
		return days[Int(weekDay) - 1]
	}
	
//	MARK: TABLE VIEW METHODS

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell", forIndexPath: indexPath) as! WeatherForecastCustomCell
		
		let current = days[indexPath.row]
		cell.weatherImage?.image = UIImage(contentsOfFile: "placeholder.png")
		
		Alamofire.request(.GET, basicImageURL + "\(current.iconID!).png")
			.responseImage { response in
				if let image = response.result.value {
					cell.weatherImage?.image = image
				}
		}
		
		let date = NSDate(timeIntervalSince1970: Double(current.timestamp!)!)
		cell.dayLabel?.text = getDayOfWeek(stringFromDate(date))
		
		cell.descLabel?.text = current.briefDesc
		
		if let minTemp = current.minTemp {
			cell.minLabel?.text = minTemp.componentsSeparatedByString(".")[0]
		}
		
		if let maxTemp = current.maxTemp {
			cell.maxLabel?.text = maxTemp.componentsSeparatedByString(".")[0]
		}
		
		if let desc = current.briefDesc {
			cell.descLabel?.text = desc
		}
	
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

