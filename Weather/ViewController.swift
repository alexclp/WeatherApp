//
//  ViewController.swift
//  Weather
//
//  Created by Alexandru Clapa on 23/01/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		
		WeatherProvider.provideWeatherForCoordinates(51.5072, longitude: 0.1275) { (days) -> Void in

		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
		
	}


}

