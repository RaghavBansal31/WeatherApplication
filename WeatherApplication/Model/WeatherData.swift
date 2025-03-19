//
//  WeatherData.swift
//  WeatherApplication
//
//  Created by Raghav Bansal on 3/19/25.
//

import Foundation

struct WeatherData:Decodable{
    let main:MainWeather
    let weather:[Weather]
    let name:String?
    
}

struct MainWeather:Decodable{
    let temp:Double?
    let humidity: Double
    
}

struct Weather:Decodable{
    let description:String
    let icon:String
}

struct ForecastData:Decodable{
    let list:[Forecast]
}

struct Forecast:Decodable{
    let dt_txt:String?
    let main:MainWeather?
    let weather:[Weather]
}
