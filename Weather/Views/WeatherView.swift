//
//  WeatherView.swift
//  Weather
//
//  Created by Pedro on 3/4/20.
//  Copyright © 2020 Mario Zarate Velasquez. All rights reserved.
//

import UIKit

class WeatherView: UIView {
    
    // MARK: - IBOutlets    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var hourlyCollectionVIew: UICollectionView!
    @IBOutlet weak var infoCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Vars
    var currentWeather: CurrentWeather!
    var weeklyWeatherForecastData: [WeeklyForecast] = []
    var dailyWeatherForecastData: [HourlyForecast] = []
    var weatherInfoData: [WeatherInfo] = []
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        mainInit()
    }
    
    private func mainInit() {
        Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        setupTableView()
        setupHourlyCollection()
        setupInfoCollectionView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    private func setupHourlyCollection() {
        hourlyCollectionVIew.register(UINib(nibName: "ForecastCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        hourlyCollectionVIew.dataSource = self
    }
    
    private func setupInfoCollectionView() {
        infoCollectionView.register(UINib(nibName: "InfoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        infoCollectionView.dataSource = self
    }
    
    func refreshData() {
        setupCurrentWeather()
        setupWeatherInfo()
        infoCollectionView.reloadData()
    }
    
    private func setupCurrentWeather() {
        self.cityLabel.text = currentWeather.city
        self.dateLabel.text = "Today, \(currentWeather.date.shortDate())"
        self.infoLabel.text = currentWeather.weatherType
        self.tempLabel.text = String(format: "%.0f%@", currentWeather.currentTmp, returnTempFormatFromUserDefaults())
    }
    
    private func setupWeatherInfo() {
        let wind = WeatherInfo(infoText: String(format: "%.1f m/sec", currentWeather.windSpeed), nameText: nil, image: getWeatherIconFor("wind"))
        let humidity = WeatherInfo(infoText: String(format: "%.0f", currentWeather.humidity), nameText: nil, image: getWeatherIconFor("humidity"))
        let pressure = WeatherInfo(infoText: String(format: "%.0f mb", currentWeather.pressure), nameText: nil, image: getWeatherIconFor("pressure"))
        let visibility = WeatherInfo(infoText: String(format: "%.0f km", currentWeather.visibility), nameText: nil, image: getWeatherIconFor("visibility"))
        let feelsLike = WeatherInfo(infoText: String(format: "%.1f", currentWeather.feelsLike), nameText: nil, image: getWeatherIconFor("feelsLike"))
        let uv = WeatherInfo(infoText: String(format: "%.1f", currentWeather.uv), nameText: "UV index", image: nil)
        let sunrise = WeatherInfo(infoText: currentWeather.sunrise, nameText: nil, image: getWeatherIconFor("sunrise"))
        let sunset = WeatherInfo(infoText: currentWeather.sunset, nameText: nil, image: getWeatherIconFor("sunset"))
        
        weatherInfoData = [wind, humidity, pressure, visibility, feelsLike, uv, sunrise, sunset]
    }
    
}

extension WeatherView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyWeatherForecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherTableViewCell
        
        cell.generateCell(forecast: weeklyWeatherForecastData[indexPath.row])
        return cell
    }
}

extension WeatherView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hourlyCollectionVIew {
            return dailyWeatherForecastData.count
        } else {
            return weatherInfoData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hourlyCollectionVIew {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ForecastCollectionViewCell
            cell.generateCell(weather: dailyWeatherForecastData[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InfoCollectionViewCell
            cell.generateCell(weatherInfo: weatherInfoData[indexPath.row])
            return cell
        }
    }
}
