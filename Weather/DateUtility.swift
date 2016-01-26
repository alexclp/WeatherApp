//
//  DateUtility.swift
//  Weather
//
//  Created by Alexandru Clapa on 26/01/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class DateUtility: NSObject {
	
	class func sharedDateUtility() -> DateUtility {
	
		var sharedInstance: DateUtility!
		var onceToken = dispatch_once_t()
		
		dispatch_once(&onceToken) { () -> Void in
			sharedInstance = DateUtility()
		}
	
		return sharedInstance
	}
	
	class func stringFromDate(date: NSDate) -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let dateString = dateFormatter.stringFromDate(date)
		
		return dateString
	}
	
	class func getDayOfWeek(today: String) -> String {
		
		let formatter  = NSDateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let todayDate = formatter.dateFromString(today)!
		
		let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
		let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
		let weekDay = myComponents.weekday
		
		let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
		
		return days[Int(weekDay) - 1]
	}
	
	class func getCurrentDate() -> String {
		
		let todaysDate: NSDate = NSDate()
		let dateFormatter: NSDateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		let dateInFormat: String = dateFormatter.stringFromDate(todaysDate)
		
		return getDayOfWeek(stringFromDate(todaysDate)) + ", \(dateInFormat)"
	}
}
