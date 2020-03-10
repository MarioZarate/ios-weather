//
//  WeatherViewController.swift
//  Weather
//
//  Created by Pedro on 3/4/20.
//  Copyright © 2020 Mario Zarate Velasquez. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Vars

    let userDefaults = UserDefaults.standard
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D!
    
    var allLocations: [WeatherLocation] = []
    var allWeatherViews: [WeatherView] = []
    var allWeatherData: [CityTempData] = []
    
    var shouldRefresh: Bool = true
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManagerStart()
        scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if shouldRefresh {
            allLocations = []
            allWeatherViews = []
            removeViewsFromScrollView()
            locationAuthCheck()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManagerStop()
    }
    
    //MARK: Download Weather
    
    private func getWeather() {
        loadLocationsFromUserDefaults()
        createWeatherViews()
        addWeatherToScrollView()
        setPageControllPageNumber()
        
        
    }
    
    private func removeViewsFromScrollView() {
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
    }
    
    private func createWeatherViews() {
        for _ in allLocations {
            allWeatherViews.append(WeatherView())
        }
    }
    
    private func addWeatherToScrollView() {
        for i in 0..<allWeatherViews.count {
            let weatherView = allWeatherViews[i]
            let location = allLocations[i]
            
            getCurrentWeather(weatherView: weatherView, location: location)
            getWeeklyWeather(weatherView: weatherView, location: location)
            getHourlyWeather(weatherView: weatherView, location: location)
            
            let xPos = self.view.frame.width * CGFloat(i)
            weatherView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            scrollView.addSubview(weatherView)
            scrollView.contentSize.width = weatherView.frame.width * CGFloat(i+1)
        }
    }
    
    private func getCurrentWeather(weatherView: WeatherView, location: WeatherLocation) {
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather(location: location) { (success) in
            weatherView.refreshData()
            self.generateWeatherList()
        }
    }
    
    private func getWeeklyWeather(weatherView: WeatherView, location: WeatherLocation) {
        WeeklyForecast.downloadWeeklyWeatherForecast(location: location) { (weatherForecasts) in
            weatherView.weeklyWeatherForecastData = weatherForecasts
            weatherView.tableView.reloadData()
        }
    }
    
    private func getHourlyWeather(weatherView: WeatherView, location: WeatherLocation) {
        HourlyForecast.downloadHourlyForecastWeather(location: location) { (weatherForecasts) in
            weatherView.dailyWeatherForecastData = weatherForecasts
            weatherView.hourlyCollectionVIew.reloadData()
        }
    }
    
    // MARK: LoadLocations from User Defaults
    
    private func loadLocationsFromUserDefaults() {
        let currentLocation = WeatherLocation(city: "", country: "", countryCode: "", isCurrentLocation: true)
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            allLocations = try! PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
            allLocations.insert(currentLocation, at: 0)
        } else {
            print("No user data in user defaults")
            allLocations.append(currentLocation)
        }
    }
    
    // MARK: PageControll
    
    private func setPageControllPageNumber() {
        pageControl.numberOfPages = allWeatherViews.count
    }
    
    private func updatePageControlSelectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
    
    // MARK: Location Manager
    
    private func locationManagerStart() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.delegate = self
        }
        locationManager!.startMonitoringSignificantLocationChanges()
    }
    
    private func locationManagerStop() {
        if locationManager != nil {
            locationManager!.stopMonitoringSignificantLocationChanges()
        }
    }
    
    private func locationAuthCheck() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager!.location?.coordinate
            if currentLocation != nil {
                LocationService.shared.latitude = currentLocation.latitude
                LocationService.shared.longitude = currentLocation.longitude
                getWeather()
            } else {
                locationAuthCheck()
            }
        } else {
            locationManager?.requestWhenInUseAuthorization()
            locationAuthCheck()
        }
    }
    
    private func generateWeatherList() {
        allWeatherData = []
        for weatherView in allWeatherViews {
            allWeatherData.append(CityTempData(city: weatherView.currentWeather.city, temp: weatherView.currentWeather.currentTmp))
        }
        print("We have \(allWeatherData.count)")
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allLocationSegue" {
            let vc = segue.destination as! AllLocationsTableViewController
            vc.weatherData = allWeatherData
            vc.delegate = self
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Faild to get location, \(error.localizedDescription)")
    }
}

extension WeatherViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        updatePageControlSelectedPage(currentPage: Int(round(value)))
    }
}

extension WeatherViewController: AllLocationsTableViewControllerDelegate {
    func didChooseLocation(atIndex: Int, shouldRefresh: Bool) {
        let viewNumber = CGFloat(integerLiteral: atIndex)
        let newOffset = CGPoint(x: viewNumber * (scrollView.frame.width + 1.0), y: 0)
        scrollView.setContentOffset(newOffset, animated: true)
        updatePageControlSelectedPage(currentPage: atIndex)
        self.shouldRefresh = shouldRefresh
    }
}
