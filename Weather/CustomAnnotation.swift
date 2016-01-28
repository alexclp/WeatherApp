//
//  CustomAnnotation.swift
//  Weather
//
//  Created by Alexandru Clapa on 28/01/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import MapKit

extension NSObject {
	var theClassName: String {
		return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
	}
}

class CustomAnnotation: NSObject, MKAnnotation  {

	var coordinate: CLLocationCoordinate2D
	var title: String?
	var subtitle: String?
	
	init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
		self.coordinate = coordinate
		self.title = title
		self.subtitle = subtitle
	}
}
