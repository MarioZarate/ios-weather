//
//  ForecastCollectionViewCell.swift
//  Weather
//
//  Created by Mario Zarate Velasquez on 3/8/20.
//  Copyright © 2020 Mario Zarate Velasquez. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func generateCell(weather: HourlyForecast) {
        timeLabel.text = weather.date.time()
        tempLabel.text = String(format: "%.0f%@", weather.temp, returnTempFormatFromUserDefaults())
        weatherImageView.image = getWeatherIconFor(weather.weatherIcon)
    }

}
