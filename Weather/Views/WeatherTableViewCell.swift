//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Mario Zarate Velasquez on 3/8/20.
//  Copyright © 2020 Mario Zarate Velasquez. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generateCell(forecast: WeeklyForecast) {
        dayOfTheWeekLabel.text = forecast.date.dayOfTheWeek()
        tempLabel.text = "\(forecast.temp)"
        weatherImageView.image = getWeatherIconFor(forecast.weatherIcon)
    }
    
}
