//
//  DateValueFormatter.swift
//  Weather
//
//  Created by Boning Liang on 2/10/18.
//  Copyright © 2018 Boning Liang. All rights reserved.
//

import Foundation
import Charts

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
//        dateFormatter.dateFormat = "dd MMM HH:mm"
        dateFormatter.dateFormat = "HH:mm"
    }
    
    init(dateFormat:String){
        super.init()
        dateFormatter.dateFormat = dateFormat
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
