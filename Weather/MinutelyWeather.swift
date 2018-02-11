//
//  Weather.swift
//  Weather
//
//  Created by Boning Liang on 2/10/18.
//  Copyright © 2018 Boning Liang. All rights reserved.
//
import Foundation
import CoreLocation

struct MinutelyWeather {
    let summary:String
    let icon:String
    let precipProbability:Double
    let time:Int
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        
        guard let precipProbability = json["precipProbability"] as? Double else {throw SerializationError.missing("precip is missing")}
        
        guard let time = json["time"] as? Int else {throw SerializationError.missing("time is missing")}
        
        
        self.summary = summary
        self.icon = icon
        self.precipProbability = precipProbability
        self.time = time
    }
    
    
    static let basePath = "https://api.darksky.net/forecast/e79dc1ea24bcc1c621d5aee8a3a6bc26/"
    
    static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([MinutelyWeather]?) -> ()) {
        
        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[MinutelyWeather] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? MinutelyWeather(json: dataPoint) {
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
