//
//  ViewController.swift
//  Weather
//
//  Created by Alexandru Clapa on 23/01/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import CoreLocation

extension String {
	var length: Int {
		return characters.count
	}
}

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
	
	var days = [WeatherDay]()
	let locationManager = CLLocationManager()
	var location = CLLocationCoordinate2D()
	var currentCity = ""
	
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	
		self.tableView.registerNib(UINib(nibName: "WeatherForecastCustomCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
		self.tableView.registerNib(UINib(nibName: "CurrentWeatherCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "currentWeatherCell")
		
		self.locationManager.requestWhenInUseAuthorization()
		
		if let autoLocation = NSUserDefaults.standardUserDefaults().objectForKey("autoLocation") {
			if autoLocation as! Bool {
				if CLLocationManager.locationServicesEnabled() {
					locationManager.delegate = self
					locationManager.desiredAccuracy = kCLLocationAccuracyBest
					locationManager.startUpdatingLocation()
				}
				
			} else {
				if NSUserDefaults.standardUserDefaults().doubleForKey("lastLongitude") != 0.0 && NSUserDefaults.standardUserDefaults().doubleForKey("lastLatitude") != 0.0 {
					
					let locationToShow = CLLocation(latitude: NSUserDefaults.standardUserDefaults().doubleForKey("lastLatitude"), longitude: NSUserDefaults.standardUserDefaults().doubleForKey("lastLongitude"))
					
					location = locationToShow.coordinate
					giveCityNameForLocation(locationToShow)
					fetchDataForCoordinates(locationToShow.coordinate.latitude, locationToShow.coordinate.longitude)
					
				} else {
					if CLLocationManager.locationServicesEnabled() {
						locationManager.delegate = self
						locationManager.desiredAccuracy = kCLLocationAccuracyBest
						locationManager.startUpdatingLocation()
					}
				}
			}
		}
		
		
	}
	
	func fetchDataForCoordinates(latitude: Double, _ longitude: Double) {
		
		WeatherProvider.provideWeatherForCoordinates(latitude, longitude) { (days) -> Void in
			self.days = days
			self.tableView.reloadData()
		}
	}
	
	func getWeatherIcon(code: String) -> UIImage? {
		
		if code == "01d" || code == "01n" {
			return UIImage(named: "clear_sky.png")
		} else if code == "02d" || code == "02n" {
			return UIImage(named: "few_clouds.png")
		} else if code == "03d" || code == "03n" {
			return UIImage(named: "scattered_clouds.png")
		} else if code == "04d" || code == "04n" {
			return UIImage(named: "broken_clouds.png")
		} else if code == "09d" || code == "09n" {
			return UIImage(named: "shower_rain.png")
		} else if code == "10d" || code == "10n" {
			return UIImage(named: "rain.png")
		} else if code == "11d" || code == "11n" {
			return UIImage(named: "thunderstorm.png")!
		} else if code == "13d" || code == "13n" {
			return UIImage(named: "snow.png")
		} else if code == "50d" || code == "50n" {
			return UIImage(named: "mist.png")
		} else {
			return UIImage(named: "placeholder.png")
		}
 	}
	
//	MARK: TABLE VIEW METHODS

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if indexPath.row == 0 {
			
			let cell = tableView.dequeueReusableCellWithIdentifier("currentWeatherCell", forIndexPath: indexPath) as! CurrentWeatherCustomTableViewCell
			
			WeatherProvider.provideCurrentWeatherForCoordinates(self.location.latitude, self.location.longitude, completionBlock: { (day) -> Void in
				let current = day
				
				if let maxTemp = current.maxTemp, windSpeed = current.windSpeed {
					var feelslike = WindChillCalculator.calculateFactor(maxTemp, windSpeed: windSpeed)
					feelslike = "\(feelslike.componentsSeparatedByString(".")[0])"
					var maxTemp = "\(maxTemp.componentsSeparatedByString(".")[0])"
					
					if feelslike == "-0" {
						feelslike = "0"
					}
					
					if maxTemp == "-0" {
						maxTemp = "0"
					}
					
					let attributedDegrees = NSMutableAttributedString(string: "\(maxTemp), feels like \(feelslike)")
					attributedDegrees.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSRange(location: 0, length: maxTemp.length))
					attributedDegrees.addAttribute(NSForegroundColorAttributeName, value: UIColor.purpleColor(), range: NSRange(location: attributedDegrees.length - feelslike.length, length: feelslike.length))
					
					cell.degreesLabel?.attributedText = attributedDegrees
				}
				
				if let weatherDescription = current.longDesc {
					var desc = weatherDescription
					desc.replaceRange(desc.startIndex...desc.startIndex, with: String(desc[desc.startIndex]).capitalizedString)
					
					let attributedDesc = NSMutableAttributedString(string: desc)
					attributedDesc.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: 0, length: attributedDesc.length))
					
					cell.descriptionLabel?.attributedText = attributedDesc

				}
				
				cell.dateLabel?.text = DateUtility.getCurrentDate()
				cell.cityLabel?.text = self.currentCity
			})
			
			return cell
			
			
		} else {
			
			let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell", forIndexPath: indexPath) as! WeatherForecastCustomCell
			let current = self.days[indexPath.row - 1]
			cell.weatherImage?.image = getWeatherIcon(current.iconID!)
			
			
			let date = NSDate(timeIntervalSince1970: Double(current.timestamp!)!)
			cell.dayLabel?.text = DateUtility.getDayOfWeek(DateUtility.stringFromDate(date))
			
			cell.descLabel?.text = current.briefDesc
			
			if let minTemp = current.minTemp {
				cell.minLabel?.text = minTemp.componentsSeparatedByString(".")[0]
				if cell.minLabel?.text == "-0" {
					cell.minLabel?.text = "0"
				}
			}
			
			if let maxTemp = current.maxTemp {
				cell.maxLabel?.text = maxTemp.componentsSeparatedByString(".")[0]
				if cell.maxLabel?.text == "-0" {
					cell.maxLabel?.text = "0"
				}
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

		let coder: CLGeocoder = CLGeocoder()
		coder.reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
			
			if (error != nil) {
				print("Reverse geocoder failed with error" + error!.localizedDescription)
			}
			
			if placemarks!.count > 0 {
				let pm = placemarks![0] as CLPlacemark

				if let locality = pm.locality {
					self.currentCity = locality
				}
			} else {
				print("Problem with the data received from geocoder")
			}
			
			if let locationToShow = self.locationManager.location {
				self.giveCityNameForLocation(locationToShow)
			}
			
			self.fetchDataForCoordinates(self.location.latitude, self.location.longitude)
		})

		
		self.locationManager.stopUpdatingLocation()
	}
	
	func giveCityNameForLocation(location: CLLocation) {
		let coder: CLGeocoder = CLGeocoder()
		coder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
			
			if (error != nil) {
				print("Reverse geocoder failed with error" + error!.localizedDescription)
			}
			
			if placemarks!.count > 0 {
				let pm = placemarks![0] as CLPlacemark
				
				if let locality = pm.locality {
					self.currentCity = locality
				}
			} else {
				print("Problem with the data received from geocoder")
			}
			
		})
	}
	
//	MARK: USER INTERACTION
//	TODO: WRAP UP WEATHER INFO
	
	func stringToShare() -> String {
		
		var toReturn = "Weather in \(self.currentCity) is\n"
		
		for day in days {
			let date = NSDate(timeIntervalSince1970: Double(day.timestamp!)!)
			if let maxTemp = day.maxTemp, minTemp = day.minTemp {
				toReturn.appendContentsOf("\(DateUtility.getDayOfWeek(DateUtility.stringFromDate(date))) \(maxTemp.componentsSeparatedByString(".")[0]) \(minTemp.componentsSeparatedByString(".")[0])\n")
			}
		}
		
		return toReturn
	}
	
	@IBAction func displayShareSheet() {
		
		let activityViewController = UIActivityViewController(activityItems: [stringToShare() as NSString], applicationActivities: nil)
		presentViewController(activityViewController, animated: true, completion: {})
	}
	
}

