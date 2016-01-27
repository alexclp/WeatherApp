//
//  LocationUtility.swift
//  Weather
//
//  Created by Alexandru Clapa on 27/01/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import CoreLocation

class LocationUtility: NSObject {
	
	let baseGoogleURL = "https://maps.googleapis.com/maps/api/geocode/json?"
	let googleKey = "AIzaSyB4n9Bn5SWLJBAVQGEbvcaPfymDcklPK_0"

	class func sharedLocationUtility() -> LocationUtility {
	
		var sharedInstance: LocationUtility!
		var onceToken = dispatch_once_t()
	
		dispatch_once(&onceToken) { () -> Void in
			sharedInstance = LocationUtility()
		}
	
		return sharedInstance
	}
	
	func coordinatesForCityName(city: String, completionBlock: (CLLocationCoordinate2D) -> Void) {
		let urlString = baseGoogleURL + "address=\(city)&key=\(googleKey)"
		print("url: \(urlString)")
		
		WeatherServer.sharedServer().GET(urlString) { (response) -> Void in
			
			var coordinates = CLLocationCoordinate2D()
			
			switch response {
				case .Failure(_): print("Failed to fetch location data")
				case .Success(let data):
					if let json = data as? Dictionary<NSObject, AnyObject> {
						let results = json["results"] as! Array<Dictionary<NSObject, AnyObject>>
						let firstResult = results[0]
						let location = firstResult["geometry"]!["location"] as! Dictionary<String, Double>
						
						let lat = location["lat"]
						let lng = location["lng"]
						
						coordinates.longitude = lng!
						coordinates.latitude = lat!
						
						print("coordinates: \(coordinates)")
				}
			}
			
			completionBlock(coordinates)
		}
	}
}

