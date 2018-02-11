//
//  Weather.swift
//  Weather
//
//  Created by Boning Liang on 2/10/18.
//  Copyright © 2018 Boning Liang. All rights reserved.
//

import Foundation
import CoreLocation

struct HourlyWeatherWithDate {
    let summary:String
    let icon:String
    let temperature:Double
    var precipitation:Double
    let dateTime:Int
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init?(json:[String:Any]) throws {
        // suggestion
        guard let summary = json["summary"] as? String else {
            print("summary is missing")
            throw SerializationError.missing("summary is missing")}
        
        guard let icon = json["icon"] as? String else {
            print("icon is missing")
            throw SerializationError.missing("icon is missing")}
        
        guard let temperature = json["temperature"] as? Double else {
            print("temp is missing")
            
            //throw SerializationError.missing("temp is missing")
            return nil
        }
        if(json["precipProbability"] != nil)
        {
            self.precipitation = json["precipProbability"] as! Double
        }
        else
        {
            self.precipitation = -1
        }
        
        
        guard let dateTime = json["time"] as? Int else {
            print("date is missing")
            throw SerializationError.missing("date is missing")}
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
//        self.precipitation = precipitation
        self.dateTime = dateTime
    }
    
    
    static let basePath = "https://api.darksky.net/forecast/e79dc1ea24bcc1c621d5aee8a3a6bc26/"
    
    static func forecast (dateTime: Int, withLocation location:CLLocationCoordinate2D, completion: @escaping ([HourlyWeatherWithDate]?) -> ()) {
        
        let url = basePath + "\(location.latitude),\(location.longitude),\(dateTime)" + "?exclude=currently,minutely,alerts,flags&extend=hourly"
        print(url)
        let request = URLRequest(url: URL(string: url)!)
        print("request")
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            print("shared")
            var forecastArray:[HourlyWeatherWithDate] = []
            print("forecastArray")
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        print("jsonserialization")
                        if let dailyForecasts = json["hourly"] as? [String:Any] {
                            print("daily forecasts")
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                print("daily Data")
                                for dataPoint in dailyData {
                                    if let weatherObject = try? HourlyWeatherWithDate(json: dataPoint) {
                                        if(weatherObject?.precipitation == nil)
                                        {
                                            print("Precipitation is nil")
                                        }
                                        else
                                        {
                                            forecastArray.append(weatherObject!)
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }catch {
                    print("Error1")
                    print(error.localizedDescription)
                }
                
                completion(forecastArray)
                
            }
            
            
        }
        
        task.resume()
        
    }
    
    
}


