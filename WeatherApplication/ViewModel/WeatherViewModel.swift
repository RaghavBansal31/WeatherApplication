//
//  WeatherViewModel.swift
//  WeatherApplication
//
//  Created by Raghav Bansal on 3/19/25.
//

import Foundation



class WeatherViewModel{
    
    private let apiKey = "4cacc444577cbc639564ad93b53c8d19"
    
    //Fetch current weather data
    func fetchWeather(forCity city: String, completion:@escaping (WeatherData?) ->Void){
        let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
        // if let and do catch, where the if let is used to convert urlstring to URL and using URLSession the data is checked for any errors and and decoded to their WeatherData data Model to ge the data in the model to be used in UI.
        if let url = URL(string:weatherUrl){
            URLSession.shared.dataTask(with: url) { data, reponse, error in
                if let data = data{
                    do{
                        let weather = try JSONDecoder().decode(WeatherData.self, from: data)
                        DispatchQueue.main.async{
                            completion(weather)
                            print(weather)
                        }
                    } catch{
                        print("There is a decoding error: \(error)")
                        DispatchQueue.main.async{
                            completion(nil)
                            
                        }
                    }
                } else{
                    DispatchQueue.main.async{
                        completion(nil)
                        print("There is some issue with the data fetched")
                    }
                }
            }.resume()
        }
    }
    
    // Fetch Data Forecast for 5 days
    func fetchForecast(forCity city: String, completion:@escaping (ForecastData?) ->Void){
        // url String to be formed with API key and city that will be searched for
        let forecastUrl = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&cnt=5&appid=\(apiKey)"
        
//        api.openweathermap.org/data/2.5/forecast/daily?lat={lat}&lon={lon}&cnt={cnt}&appid={API key}
        
        // if let and do catch, where the if let is used to convert urlstring to URL and using URLSession the data is checked for any errors and and decoded to ForecastData data model to ge the data in the model to be used in UI.
        if let url = URL(string:forecastUrl){
            URLSession.shared.dataTask(with: url) { data, reponse, error in
                if let data = data{
                    do{
                        let forecast = try JSONDecoder().decode(ForecastData.self, from: data)
                        DispatchQueue.main.async{
                            completion(forecast)
                            print(forecast)
                        }
                    } catch{
                        print("There is a decoding error: \(error)")
                        DispatchQueue.main.async{
                            completion(nil)
                            
                        }
                    }
                } else{
                    DispatchQueue.main.async{
                        completion(nil)
                        print("There is some issue with the data fetched")
                    }
                }
            }.resume()
        }
    }
    
}
