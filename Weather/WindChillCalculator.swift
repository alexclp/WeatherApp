//
//  WindChillCalculator.swift
//  Weather
//
//  Created by Alexandru Clapa on 26/01/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class WindChillCalculator: NSObject {
	
	class func sharedCalculator() -> WindChillCalculator {
		
		var sharedInstance: WindChillCalculator!
		var onceToken = dispatch_once_t()
		
		dispatch_once(&onceToken) { () -> Void in
			sharedInstance = WindChillCalculator()
		}
		
		return sharedInstance
	}
	
	class func calculateFactor(temperature: String, windSpeed: String) -> String {
		
		if let units = NSUserDefaults.standardUserDefaults().objectForKey("units") {
			let temp = Double(temperature)
			let speed = Double(windSpeed)
			if (units as! String) == "metric" {
				
				let feelslike = 13.12 + 0.6215 * temp! - 11.37 * pow(speed!, 0.16) + 0.3965 * pow(temp!, 0.16)
				return String(feelslike)
				
			} else {
				
				let feelslike = 35.74 + 0.6215 * temp! - 35.75 * pow(speed!, 0.16) + 0.4275 * pow(temp!, 0.16)
				return String(feelslike)
				
			}
		} else {
			let temp = Double(temperature)
			let speed = Double(windSpeed)
			let feelslike = 13.12 + 0.6215 * temp! - 11.37 * pow(speed!, 0.16) + 0.3965 * pow(temp!, 0.16)
			return String(feelslike)
		}
		
	}
}
