//
//  WeatherProvider.swift
//  Weather
//
//  Created by Alexandru Clapa on 24/01/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherProvider: NSObject {
	
	static let basicURL = "http://api.openweathermap.org/data/2.5/forecast/daily"
	static let appID = "750458e9cdcade313ceb5e65e250e8fd"
	
	class func provideWeatherForCity(city: String, completionBlock: ([WeatherDay]) -> Void) {
		
	}
	
	class func provideWeatherForCoordinates(latitude: Double, _ longitude: Double, completionBlock: ([WeatherDay]) -> Void)  {
		
		let urlString = basicURL + "?q=London&mode=json&units=metric&cnt=10&appid=\(appID)"
		print("Providing weather")
		
		WeatherServer.sharedServer().GET(urlString) { (response) -> Void in
		
			var parsedDays = [WeatherDay]()
			
			switch response {
				case .Failure(_): print("Failed to fetch data")
				
				case .Success(let data):
					if let json = data as? Dictionary<NSObject, AnyObject> {
						
						let days = json["list"] as! Array<Dictionary<NSObject, AnyObject>>
						
						for day in days {
							let weatherDayObject = WeatherDay()
						
							weatherDayObject.timestamp = day["dt"] as? String
							let temperatures = day["temp"] as! Dictionary<String, Double>
							weatherDayObject.maxTemp = String(temperatures["max"])
							weatherDayObject.minTemp = String(temperatures["min"])
					
							let descriptions = day["weather"] as! Array<Dictionary<String, AnyObject>>
							let today = descriptions[0]
							weatherDayObject.briefDesc = today["main"] as? String
							weatherDayObject.longDesc = today["description"] as? String
							
							parsedDays.append(weatherDayObject)
						}
						
					}

			}
			
			completionBlock(parsedDays)
		}
		
	}
	
}
