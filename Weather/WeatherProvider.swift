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
	static let basicURLCurrent = "http://api.openweathermap.org/data/2.5/weather"
	static let appID = "750458e9cdcade313ceb5e65e250e8fd"
	
	class func provideCurrentWeatherForCoordinates(latitude: Double, _ longitude: Double, completionBlock: (WeatherDay) -> Void) {
		let urlString = basicURLCurrent + "?lat=\(latitude)&lon=\(longitude)&appid=\(appID)&units=metric"
		
		print("Crashing URL:\(urlString)")
		
		WeatherServer.sharedServer().GET(urlString) { (response) -> Void in
			
			let weatherDayObject = WeatherDay()
			
			switch response {
				case .Failure(_): print("Failed to fetch data")
				
				case .Success(let data):
					
					if let json = data as? Dictionary<NSObject, AnyObject> {
						let temps = json["main"] as! Dictionary<String, AnyObject>
						
						if let temp = temps["temp"] {
							let stringRepresentation = String(temp)
							let separated = stringRepresentation.componentsSeparatedByString(".")[0]
							weatherDayObject.maxTemp = separated
						}
						
						let windSpeeds = json["wind"] as! Dictionary<String, Double>
						weatherDayObject.windSpeed = String(windSpeeds["speed"]!)
						
						let descriptions = json["weather"] as! Array<Dictionary<String, AnyObject>>
						let first = descriptions[0]
						weatherDayObject.longDesc = first["main"] as? String
					}
			}
			
			completionBlock(weatherDayObject)
		}
	}
	
	class func provideWeatherForCity(city: String, completionBlock: ([WeatherDay]) -> Void) {
		
	}
	
	class func provideWeatherForCoordinates(latitude: Double, _ longitude: Double, completionBlock: ([WeatherDay]) -> Void)  {
		
		let urlString = basicURL + "?lat=\(latitude)&lon=\(longitude)&mode=json&units=metric&cnt=10&appid=\(appID)"
		print("url: \(urlString)")
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
							
							weatherDayObject.timestamp = String(day["dt"]!)
							let temperatures = day["temp"] as! Dictionary<String, Double>
							weatherDayObject.maxTemp = String(temperatures["max"]!)
							weatherDayObject.minTemp = String(temperatures["min"]!)
							weatherDayObject.windSpeed = String(day["speed"]!)
					
							let descriptions = day["weather"] as! Array<Dictionary<String, AnyObject>>
							let today = descriptions[0]
							weatherDayObject.briefDesc = today["main"] as? String
							weatherDayObject.longDesc = today["description"] as? String
							weatherDayObject.iconID = today["icon"] as? String
							
							parsedDays.append(weatherDayObject)
						}
						
					}

			}
			
			completionBlock(parsedDays)
		}
		
	}
	
}
