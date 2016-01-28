//
//  LocationSelecterViewController.swift
//  Weather
//
//  Created by Alexandru Clapa on 28/01/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import MapKit

class LocationSelecterViewController: UIViewController {

	@IBOutlet weak var mapView: MKMapView?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
		longPressGesture.minimumPressDuration = 0.5
		mapView?.addGestureRecognizer(longPressGesture)
		
		self.title = "Place a pin"
		
		setupView()
    }
	
	func setupView() {
		if let coordinate: CLLocation = NSUserDefaults.standardUserDefaults().objectForKey("lastCoordinateManual") as? CLLocation {
			let annotation = CustomAnnotation.init(coordinate: coordinate.coordinate, title: "", subtitle: "")
			
			mapView?.addAnnotation(annotation)
		}
	}

	func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
		if gestureRecognizer.state != UIGestureRecognizerState.Began {
			return
		}
		
		let touchPoint: CGPoint = gestureRecognizer.locationInView(mapView)
		let touchMapCoordinate = mapView?.convertPoint(touchPoint, toCoordinateFromView: mapView)
		
		let annotation = CustomAnnotation.init(coordinate: touchMapCoordinate!, title: "", subtitle: "")
		
		if let annotations = mapView?.annotations {
			mapView?.removeAnnotations(annotations)
		}
		
		NSUserDefaults.standardUserDefaults().setBool(false, forKey: "autoLocation")
		NSUserDefaults.standardUserDefaults().setDouble((touchMapCoordinate?.latitude)!, forKey: "lastLatitude")
		NSUserDefaults.standardUserDefaults().setDouble((touchMapCoordinate?.longitude)!, forKey: "lastLongitude")
		NSUserDefaults.standardUserDefaults().synchronize()
		
		mapView?.addAnnotation(annotation)
	}
	
}
