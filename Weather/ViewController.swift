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
	
//	MARK: TABLE VIEW METHODS

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell", forIndexPath: indexPath) as! WeatherForecastCustomCell
		
		let current = days[indexPath.row]
		cell.weatherImage?.image = UIImage(contentsOfFile: "placeholder.png")
		
		print("id: \(current.iconID)")
		
		Alamofire.request(.GET, basicImageURL + "\(current.iconID!).png")
			.responseImage { response in
				debugPrint(response)
				
				print(response.request)
				print(response.response)
				debugPrint(response.result)
				
				if let image = response.result.value {
//					print("image downloaded: \(image)")
					cell.weatherImage?.image = image
				}
		}
		
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

