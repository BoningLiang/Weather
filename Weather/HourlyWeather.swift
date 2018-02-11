//
//  Weather.swift
//  Weather
//
//  Created by Boning Liang on 2/10/18.
//  Copyright © 2018 Boning Liang. All rights reserved.
//

import Foundation
import CoreLocation

struct HourlyWeather {
    let summary:String
    let icon:String
    let temperature:Double
    let precipitation:Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        // suggestion
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        guard let temperature = json["temperature"] as? Double else {throw SerializationError.missing("temp is missing")}
        guard let precipitation = json["precipProbability"] as? Double else {throw SerializationError.missing("precip is missing")}
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        self.precipitation = precipitation
        
    }
    
    
    static let basePath = "https://api.darksky.net/forecast/e79dc1ea24bcc1c621d5aee8a3a6bc26/"
    
    static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([HourlyWeather]?) -> ()) {
        
//        CLGeocoder().reverseGeocodeLocation(location){ (placemark, error) in
//            if error != nil
//            {
//                print("Error")
//            }
//            else
//            {
//                if let place = placemark?[0]
//                {
//
//                }
//            }
//        }
        
        let url = basePath + "\(location.latitude),\(location.longitude)" + "?exclude=currently,minutely,alerts,flags&extend=hourly"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[HourlyWeather] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["hourly"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? HourlyWeather(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                        
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
                completion(forecastArray)
                
            }
            
            
        }
        
        task.resume()
        
    }
    
    
}

