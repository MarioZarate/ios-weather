//
//  WeatherViewController.swift
//  Weather
//
//  Created by Pedro on 3/4/20.
//  Copyright © 2020 Mario Zarate Velasquez. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var weatherLocation: WeatherLocation!
    
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(scrollView.bounds)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("didAppear:", scrollView.bounds)
        let weatherView = WeatherView()
        weatherView.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        scrollView.addSubview(weatherView)
        
        weatherLocation = WeatherLocation(city: "Cusco", country: "Peru", countryCode: "PE", isCurrentLocation: false)

        getCurrentWeather(weatherView: weatherView)
        getWeeklyWeather(weatherView: weatherView)
        getHourlyWeather(weatherView: weatherView)
    }
    
    //MARK: Download Weather
    
    private func getCurrentWeather(weatherView: WeatherView) {
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather(location: weatherLocation) { (success) in
            weatherView.refreshData()
        }
    }
    
    private func getWeeklyWeather(weatherView: WeatherView) {
        WeeklyForecast.downloadWeeklyWeatherForecast(location: weatherLocation) { (weatherForecasts) in
            weatherView.weeklyWeatherForecastData = weatherForecasts
            weatherView.tableView.reloadData()
        }
    }
    
    private func getHourlyWeather(weatherView: WeatherView) {
        HourlyForecast.downloadHourlyForecastWeather(location: weatherLocation) { (weatherForecasts) in
            weatherView.dailyWeatherForecastData = weatherForecasts
            weatherView.hourlyCollectionVIew.reloadData()
        }
    }
}
