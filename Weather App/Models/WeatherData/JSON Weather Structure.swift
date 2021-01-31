//
//  JSON Structure.swift
//  yandexWeather
//
//  Created by Георгий iMac on 20.12.2020.
//

import Foundation

//Структура данных о погоде в определенном населенном пункте.
//Предполагает текущую погоду и прогноз погоды на 7 дней с разбивкой по часам на первые 2 дня.


struct WeatherStruct: Decodable, Encodable {
    var now       : Int             //current Time in unixtime format
    var fact      : FactStruct
    var forecasts : [ForecastStruct]
}

struct FactStruct: Decodable, Encodable {
    var temp       : Int
    var feels_like : Int
    var condition  : String
    var icon       : String
}

struct ForecastStruct: Decodable, Encodable {
    var date    : String
    var sunrise : String
    var sunset  : String
    var parts   : PartsOfDay        //weather forecast in parts (morning / day / evening / night)
    var hours   : [HoursStruct]     //hourly weather forecast (24 parts per day)
}

struct PartsOfDay: Decodable, Encodable {
    var evening     : PartsStruct
    var morning     : PartsStruct
    var night       : PartsStruct
    var day         : PartsStruct
}

struct PartsStruct: Decodable, Encodable {
    var temp_min   : Int            //minimum temperature
    var temp_avg   : Int            //average temperature
    var temp_max   : Int            //maximum temperature
    var feels_like : Int            //feels like
    var prec_type  : Int            //precipitation type
    var condition  : String         //weather description
    var icon       : String         //picture corresponding to the description of the weather
}

struct HoursStruct: Decodable, Encodable {
    var hour       : String?        //serial number of the hour (0-23)
    var temp       : Int?
    var feels_like : Int?
    var icon       : String?
    var condition  : String?
}

