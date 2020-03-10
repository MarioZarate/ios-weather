//
//  MainWeatherTableViewCell.swift
//  Weather
//
//  Created by Mario Zarate Velasquez on 3/9/20.
//  Copyright © 2020 Mario Zarate Velasquez. All rights reserved.
//

import UIKit

class MainWeatherTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generateCell(weatherData: CityTempData) {
        cityLabel.text = weatherData.city
        cityLabel.adjustsFontSizeToFitWidth = true        
        tempLabel.text = String(format: "%.0f %@", weatherData.temp, "C")
        // TODO: make temp format dynamic
    }

}
