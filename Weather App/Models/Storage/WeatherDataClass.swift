//
//  WeatherDataClass.swift
//  yandexWeather
//
//  Created by Георгий iMac on 20.01.2021.
//

import RealmSwift

class WeatherData: Object {
    @objc dynamic var isSelected             = false
    @objc dynamic var updateTime             = 0
    @objc dynamic var cityID                 = 0
    @objc dynamic var cityName               = " "
    @objc dynamic var currentTemperature     = -100
    @objc dynamic var currentWeatherimageURL = " "
    var forecasts = List<ForecastData>()
    
    override static func primaryKey() -> String? {
            return "cityName"
        }
}
