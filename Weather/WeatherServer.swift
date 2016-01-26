//
//  WeatherServer.swift
//  Weather
//
//  Created by Alexandru Clapa on 24/01/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

enum ServerError {
	case ServerError
	case ParseError
}

enum ServerResponse {
	case Success(AnyObject?)
	case Failure(ServerError)
}


class WeatherServer: NSObject {

	class func sharedServer() -> WeatherServer {
		
		var sharedInstance: WeatherServer!
		var onceToken = dispatch_once_t()
		
		dispatch_once(&onceToken) { () -> Void in
			sharedInstance = WeatherServer()
		}
		
		return sharedInstance
	}
	
	func GET(urlString: String, completitionHandler: (ServerResponse) -> Void) {
		
		let session = NSURLSession.sharedSession()
		let dataTask = session.dataTaskWithURL(NSURL(string: urlString)!) { (data, response, error) -> Void in
			
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				
				if data == nil {
					
					completitionHandler(.Failure(.ServerError))
					return
				}
				
				do {
					
					let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
					completitionHandler(.Success(json))
					
				} catch {
					
					completitionHandler(.Failure(.ParseError))
				}
			})
		}
		dataTask.resume()
	}
}
