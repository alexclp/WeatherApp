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
		
		if NSUserDefaults.standardUserDefaults().doubleForKey("lastLatitude") != 0.0 &&
		NSUserDefaults.standardUserDefaults().doubleForKey("lastLongitude") != 0.0 {
			let coordinate = CLLocationCoordinate2D(latitude: NSUserDefaults.standardUserDefaults().doubleForKey("lastLatitude"), longitude: NSUserDefaults.standardUserDefaults().doubleForKey("lastLongitude"))
			
			let annotation = CustomAnnotation.init(coordinate: coordinate, title: "", subtitle: "")
			
			mapView?.addAnnotation(annotation)
			
			let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 30.0, longitudeDelta: 30.0))
			mapView?.setRegion(region, animated: true)
			
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
