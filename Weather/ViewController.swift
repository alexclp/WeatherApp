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

extension String {
	var length: Int {
		return characters.count
	}
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

	let basicImageURL = "http://openweathermap.org/img/w/"
	var days = [WeatherDay]()
	let locationManager = CLLocationManager()
	var location = CLLocationCoordinate2D()
	
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.tableView.registerNib(UINib(nibName: "WeatherForecastCustomCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
		self.tableView.registerNib(UINib(nibName: "CurrentWeatherCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "currentWeatherCell")
		
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
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
		
		if indexPath.row == 0 {
			
			let cell = tableView.dequeueReusableCellWithIdentifier("currentWeatherCell", forIndexPath: indexPath) as! CurrentWeatherCustomTableViewCell
			
			WeatherProvider.provideCurrentWeatherForCoordinates(self.location.latitude, self.location.longitude, completionBlock: { (day) -> Void in
				let current = day
				
				var feelslike = WindChillCalculator.calculateFactor(current.maxTemp!, windSpeed: current.windSpeed!, units: "metric")
				feelslike = "\(feelslike.componentsSeparatedByString(".")[0])°"
				let maxTemp = "\(current.maxTemp!.componentsSeparatedByString(".")[0])°"
				
				let attributedDegrees = NSMutableAttributedString(string: "\(maxTemp), feels like \(feelslike)")
				attributedDegrees.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSRange(location: 0, length: maxTemp.length))
				attributedDegrees.addAttribute(NSForegroundColorAttributeName, value: UIColor.purpleColor(), range: NSRange(location: attributedDegrees.length - feelslike.length, length: feelslike.length))
				
				cell.degreesLabel?.attributedText = attributedDegrees
				
				var desc = current.longDesc!
				desc.replaceRange(desc.startIndex...desc.startIndex, with: String(desc[desc.startIndex]).capitalizedString)
				
				let attributedDesc = NSMutableAttributedString(string: desc)
				attributedDesc.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: 0, length: attributedDesc.length))
				
				cell.descriptionLabel?.attributedText = attributedDesc
			})
			
			return cell
			
			
		} else {
			
			let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell", forIndexPath: indexPath) as! WeatherForecastCustomCell
			let current = self.days[indexPath.row - 1]
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
				cell.minLabel?.text = minTemp.componentsSeparatedByString(".")[0] + "°"
			}
			
			if let maxTemp = current.maxTemp {
				cell.maxLabel?.text = maxTemp.componentsSeparatedByString(".")[0] + "°"
			}
			
			if let desc = current.briefDesc {
				cell.descLabel?.text = desc
			}
			
			return cell
		}
		
		
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.days.count != 0 {
			return self.days.count + 1
		}
		return 0
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return self.view.bounds.size.height / 2.5
		} else {
			return 72.0
		}
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
//	MARK: LOCATION
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		self.location = manager.location!.coordinate
		/*
		let coder: CLGeocoder = CLGeocoder()
		coder.reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
			
			if (error != nil) {
				print("Reverse geocoder failed with error" + error!.localizedDescription)
			}
			
			if placemarks!.count > 0 {
				let pm = placemarks![0] as CLPlacemark
//				print(pm)
			} else {
				print("Problem with the data received from geocoder")
			}
		})
		*/
		fetchDataForCoordinates(self.location.latitude, longitude: self.location.longitude)
		self.locationManager.stopUpdatingLocation()
	}
}

