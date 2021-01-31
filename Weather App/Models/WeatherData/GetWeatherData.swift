//
//  GetWeatherData.swift
//  Weather App
//
//  Created by Георгий iMac on 30.01.2021.
//

import Foundation
import Alamofire

protocol WeatherJSONDelegate: class {
   func updateWeatherData(weatherData: WeatherData)
}


class WeatherJSON {
    let cityCoordinateLat : String!
    let cityCoordinateLong: String!
    var arrayOfURLs       : [String] = []
    var weatherData       = WeatherData()
    
    weak var weatherJSONDelegate: WeatherJSONDelegate!

    
    init(lat: String, lon: String, cityID: Int, delegate: WeatherJSONDelegate) {
        cityCoordinateLat  = lat
        cityCoordinateLong = lon
        weatherData.cityID = cityID
        self.weatherJSONDelegate = delegate
        getCityWeatherData()
    }
    
    
    private func getCityWeatherData() -> () {
        let weatherURL = "https://api.weather.yandex.ru/v2/forecast?&lat="+self.cityCoordinateLat+"&lon="+self.cityCoordinateLong+"&lang=ru_RU&limit=7&hours=true&extra=false"
        AF.request(weatherURL, method: .get, headers: ["X-Yandex-API-Key":"b6cb2e4f-6a7a-4a96-a697-12d3bd32e20d"]).responseData{
            (responseData) in
            switch responseData.result {
                case  .success(let value):
                   do { let weatherData = try JSONDecoder().decode(WeatherStruct.self, from: value)
                    self.weatherData.currentTemperature = weatherData.fact.temp
                    self.weatherData.currentWeatherimageURL = self.getImageURLString(weatherData.fact.icon)
                    self.getArrayOfImageURLs(weatherData: weatherData)
                    self.getForecastsData(weatherForecasts:  weatherData.forecasts)
                   }
                   catch let error {print(error)}
                case .failure(let error):
                   print(error)
            }
        }
    }
    
    
    private func getArrayOfImageURLs(weatherData: WeatherStruct) -> () {
        for x in 0...weatherData.forecasts.count-1 {
            arrayOfURLs.append(getImageURLString(weatherData.forecasts[x].parts.day.icon))
        }
    }
    
    
    private func getForecastsData (weatherForecasts: [ForecastStruct]) -> () {
        let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
        for x in 0...weatherForecasts.count-1 {
                dateFormatter.dateFormat = "yyyy-mm-dd"
            let date = dateFormatter.date(from: weatherForecasts[x].date)!
                dateFormatter.dateFormat = "EEEE"
            let weekDay = dateFormatter.string(from: date).capitalized
            let forecastData = ForecastData()
                forecastData.condition = translateToRussian(part: weatherForecasts[x].parts.day.condition)
                forecastData.dayTemperature = weatherForecasts[x].parts.day.temp_avg
                forecastData.nightTemperature = weatherForecasts[x].parts.night.temp_avg
                forecastData.weatherImageURL = self.arrayOfURLs[x]
                forecastData.weekDay = weekDay
            self.weatherData.forecasts.append(forecastData)
        }
    }
    
    
    private func sendDataToView () -> () {
        self.weatherJSONDelegate.updateWeatherData(weatherData: weatherData) 
    }

}

extension WeatherJSON {
    
    func getImageURLString(_ iconName: String) -> (String) {
        return "https://yastatic.net/weather/i/icons/blueye/color/svg/"+iconName+".svg"
    }
}
