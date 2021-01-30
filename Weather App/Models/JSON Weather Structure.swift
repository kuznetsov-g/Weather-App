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
    var now       : Int
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
    var parts   : PartsEnum         //прогноз погоды по частям (утро / день 12ч / вечер / ночь 12ч)
    var hours   : [HoursStruct]     //прогноз погоды по часам (24 части на сутки)
}

struct PartsEnum: Decodable, Encodable {       //часть дня
    var evening     : PartsStruct
    var morning     : PartsStruct
    var night       : PartsStruct
    var day         : PartsStruct
}

struct PartsStruct: Decodable, Encodable {
    var temp_min   : Int            //минимальная температура
    var temp_avg   : Int            //средняя температура
    var temp_max   : Int            //максимальная температура
    var feels_like : Int            //ощущается как
    var prec_type  : Int            //тип осадков
    var condition  : String         //описание погоды
    var icon       : String         //картинка соответствующая описанию погоды
}

struct HoursStruct: Decodable, Encodable {
    var hour       : String?        //порядковый номер часа (0-23)
    var temp       : Int?
    var feels_like : Int?
    var icon       : String?
    var condition  : String?
}

