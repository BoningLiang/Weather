//
//  historyViewController.swift
//  Weather
//
//  Created by Boning Liang on 2/10/18.
//  Copyright © 2018 Boning Liang. All rights reserved.
//

import UIKit
import Charts
import CoreLocation

class historyViewController: UIViewController, ChartViewDelegate {

    var currentLocation:String = ""
    var locationToShow:String=""
    var historyDate:String=""
    
    @IBOutlet weak var historyWeatherChartView: LineChartView!

    let hourSecondsTimeInterval: TimeInterval = 3600
    var historyData = [HourlyWeatherWithDate]()
    var numberOfHours:Int = 0
    
    var history_24_hour_temperature: [Double] = []
    var history_24_hour_precipitation: [Double] = []
    var history_24_hour:[Int] = []
    
    @IBOutlet weak var calendarPicker: UIDatePicker!
    
    @IBOutlet weak var okButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.locationToShow
        
        
        historyWeatherChartView.noDataText = "Choose a previous day"
        // Do any additional setup after loading the view.
        historyWeatherChartView.dragEnabled = true
        historyWeatherChartView.scaleYEnabled = false
        historyWeatherChartView.scaleXEnabled = false
        historyWeatherChartView.dragYEnabled = false
        historyWeatherChartView.legend.enabled = true
        historyWeatherChartView.chartDescription?.enabled = false
        historyWeatherChartView.animate(xAxisDuration: 0.5)
        calendarPicker.maximumDate = Date()
        
    }
    @IBAction func okButtonAction(_ sender: Any) {
        historyDate = calendarPicker.date.description
        print(Int(calendarPicker.date.timeIntervalSince1970))
        print("currentLocation=" + self.currentLocation)
        let date = Int(calendarPicker.date.timeIntervalSince1970)
        do{
            try updateWeatherForLocation(location: currentLocation, date: date)
        }catch{
            print("Errors")
        }
        
//        print(self.historyDate)
    }
    
    func updateWeatherForLocation (location:String, date: Int)
    {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    HourlyWeatherWithDate.forecast(dateTime: date,withLocation: location.coordinate, completion: { (results:[HourlyWeatherWithDate]?) in
                        
                        if let weatherData = results {
                            self.historyData = weatherData
                            DispatchQueue.main.async {
                                self.history_24_hour_temperature.removeAll()
                                self.history_24_hour_precipitation.removeAll()
                                self.history_24_hour.removeAll()
                                
                                for theHistoryData in self.historyData{
                                    self.history_24_hour_temperature.append(theHistoryData.temperature)
                                    self.history_24_hour_precipitation.append(theHistoryData.precipitation*100)
                                    self.history_24_hour.append(theHistoryData.dateTime)
                                }
                                
                                self.historyWeatherChartView.zoom(scaleX: 0, scaleY: 1, x: 0, y: 0)
                                self.historyWeatherChartView.xAxis.granularity = 3600
                                if(self.history_24_hour_precipitation.count>0 || self.history_24_hour_temperature.count>0)
                                {
                                    self.setChart(dateTime: self.history_24_hour, temperature: self.history_24_hour_temperature, precipitation: self.history_24_hour_precipitation, dateFormate: "MMM d h:mm a", zoomScale: 5, duration: 3600)
                                }
                                else
                                {
                                    let alert = UIAlertController(title: "No data", message: "No data!", preferredStyle: .alert)
                                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alert.addAction(action)
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    func setChart(dateTime: [Int], temperature:[Double], precipitation:[Double],dateFormate:String, zoomScale: Double, duration: Int)
    {
        historyWeatherChartView.data?.clearValues()
        historyWeatherChartView.zoom(scaleX: CGFloat(zoomScale), scaleY: 1, x: 0, y: 0)
//        let now = Int(Date().timeIntervalSince1970)
        
//        let hourSeconds: Int = 3600
        
        var dataEntries: [ChartDataEntry] = []
        var dataPrecipitationEntries: [ChartDataEntry] = []
        for i in 0..<temperature.count
        {
            let dataEntry = ChartDataEntry(x: Double(dateTime[i]), y: temperature[i])
            let dataPrecipitationEntry = ChartDataEntry(x: Double(dateTime[i]), y:precipitation[i])
            dataEntries.append(dataEntry)
            dataPrecipitationEntries.append(dataPrecipitationEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Temperature")
        let chartPrecipitationDataSet = LineChartDataSet(values: dataPrecipitationEntries, label:"Precipitation")
        chartDataSet.lineWidth = 2
        chartPrecipitationDataSet.lineWidth = 2
        
        chartDataSet.colors = [UIColor.orange]
        chartDataSet.circleRadius = CGFloat(5)
        chartPrecipitationDataSet.circleRadius = CGFloat(5)
        
        chartDataSet.mode = .cubicBezier
        chartPrecipitationDataSet.mode = .cubicBezier
        
        let chartData = LineChartData()
        //        let chartPrecipitationData = LineChartData
        
        chartData.addDataSet(chartDataSet)
        if(self.history_24_hour_precipitation.count>0)
        {
            if(self.history_24_hour_precipitation[0] >= 0)
            {
                chartData.addDataSet(chartPrecipitationDataSet)
            }
        }
        historyWeatherChartView.xAxis.valueFormatter = DateValueFormatter(dateFormat: dateFormate)
        historyWeatherChartView.data = chartData
        //        weatherChartView.xAxis.labelPosition = .bottom
        
        
        //        weatherChartView.xAxis.value
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
