//
//  CurrentWeather.swift
//  Weather
//
//  Created by Mario Zarate Velasquez on 3/3/20.
//  Copyright © 2020 Mario Zarate Velasquez. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather {
    
    private var _city: String!
    private var _date: Date!
    private var _currentTemp: Double!
    private var _feelsLike: Double!
    private var _uv: Double!
    
    private var _weatherType: String!
    private var _pressure: Double!
    private var _humidity: Double!
    private var _windSpeed: Double!
    private var _weatherIcon: String!
    private var _visibility: Double!
    private var _sunrise: String!
    private var _sunset: String!
    
    var city: String {
        if _city == nil {
            _city = ""
        }
        return _city
    }
    
    var date: Date {
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    
    var currentTmp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    var feelsLike: Double {
        if _feelsLike == nil {
            _feelsLike = 0.0
        }
        return _feelsLike
    }
    
    var uv: Double {
        if _uv == nil {
            _uv = 0.0
        }
        return _uv
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var pressure: Double {
        if _pressure == nil {
            _pressure = 0.0
        }
        return _pressure
    }
    
    var humidity: Double {
        if _humidity == nil {
            _humidity = 0.0
        }
        return _humidity
    }
    
    var windSpeed: Double {
        if _windSpeed == nil {
            _windSpeed = 0.0
        }
        return _windSpeed
    }
    
    var weatherIcon: String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    
    var visibility: Double {
        if _visibility == nil {
            _visibility = 0.0
        }
        return _visibility
    }
    
    var sunrise: String {
        if _sunrise == nil {
            _sunrise = ""
        }
        return _sunrise
    }
    
    var sunset: String {
        if _sunset == nil {
            _sunset = ""
        }
        return _sunset
    }
    
    func getCurrentWeather() {
        let LOCATIONAPI_URL = "https://api.weatherbit.io/v2.0/current?city=Raleigh,NC&key=40f7f0d73eba4b1c9e7f69ce211612c2"
        Alamofire.request(LOCATIONAPI_URL).responseJSON { (response) in
            let result = response.result
            if result.isSuccess {
                let json = JSON(result.value)
                print(json)
                self._city = json["data"][0]["city_name"].stringValue
                self._date = currentDateFromUnix(unixDate: json["data"][0]["ts"].double)
            } else {
                print("no result found for current location")
            }
        }
    }
}
