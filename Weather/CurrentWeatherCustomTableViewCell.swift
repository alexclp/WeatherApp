//
//  CurrentWeatherCustomTableViewCell.swift
//  Weather
//
//  Created by Alexandru Clapa on 26/01/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class CurrentWeatherCustomTableViewCell: UITableViewCell {

	@IBOutlet weak var degreesLabel: UILabel?
	@IBOutlet weak var descriptionLabel: UILabel?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
