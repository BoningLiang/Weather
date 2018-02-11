//
//  ViewController.swift
//  Weather
//
//  Created by Boning Liang on 2/9/18.
//  Copyright © 2018 Boning Liang. All rights reserved.
//

import UIKit
import Charts
import CoreLocation

class ViewController: UIViewController, ChartViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate{
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var weatherChartView: LineChartView!
    
    @IBOutlet weak var nextHourButton: UIBarButtonItem!
    
    @IBOutlet weak var historyButton: UIBarButtonItem!
    @IBOutlet weak var next7daysButton: UIBarButtonItem!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    

    @IBOutlet weak var summaryLabel: UILabel!
    
    
    let hourSecondsTimeInterval: TimeInterval = 3600
    var forecastData = [HourlyWeather]()
    var hourlyForecastData = [HourlyWeather]()
    var minutelyForecastData = [MinutelyWeather]()
    
    var currentLocation:String = ""
    var locationToShow = ""
    var numberOfHours:Int = 0
    var numberOfMinutes:Int = 0
    var next_hour_temperature: [Double] = []
    var next_hour_precipitation:[Double] = []
    var next_7_days_temperature: [Double] = []
    var next_7_days_precipitation: [Double] = []
    var default_location = "Auburn University"
    var isHistoryClicked = false
    var isMapClicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentLocation = default_location
        self.searchBar.delegate = self
        self.currentLocation = "Auburn, AL"
        self.locationToShow = currentLocation
        weatherChartView.noDataText = "No data available"
        weatherChartView.dragEnabled = true
        weatherChartView.scaleYEnabled = false
        weatherChartView.scaleXEnabled = false
        weatherChartView.dragYEnabled = false
        weatherChartView.legend.enabled = true
        weatherChartView.chartDescription?.enabled = false
        weatherChartView.animate(xAxisDuration: 0.5)
        
        
//        weatherChartView.xAxis.centerAxisLabelsEnabled = true
        
        
//        weatherChartView.setVisibleXRangeMaximum(0.3)
        

//        weatherChartView.pinchZoomEnabled = false
//        weatherChartView.rightAxis.enabled = false
//        weatherChartView.setScaleEnabled(false)
//        weatherChartView.autoScaleMinMaxEnabled = true
//        weatherChartView.setScaleMinima(0.5, scaleY: 1)
//        weatherChartView.leftAxis.axisMaximum=60
        
        
//        let date = ["2018-02-10","2018-02-11","2018-02-12","2018-02-13","2018-02-14","2018-02-15","2018-02-16"]
        //let current_temperature = "23"
        let future_temperature =    [23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                     20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0]
        self.next_hour_temperature = [23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                     20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0,18.0,17.0,20.0,23.0,20.0,20.0,
                                     23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                     20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0,18.0,17.0,20.0,23.0,20.0,20.0]
        
        self.next_hour_precipitation = [23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                        20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0,18.0,17.0,20.0,23.0,20.0,20.0,
                                        23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                        20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0,18.0,17.0,20.0,23.0,20.0,20.0]
        
        self.next_7_days_temperature = [23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                       20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0,
                                       23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                       20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0,
                                       23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                       20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0,
                                       23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                       20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0,
                                       23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                       20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0,
                                       23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                       20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0,
                                       23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                       20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0]
        
        self.next_7_days_precipitation = [23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                        20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0,
                                        23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                        20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0,
                                        23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                        20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0,
                                        23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                        20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0,
                                        23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                        20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0,
                                        23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                        20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0,
                                        23.0,20.0,25.0,18.0,17.0,20.0,23.0,20.0,20.0,25.0,18.0,17.0,
                                        20.0,19.0,26.0,20.0,25.0,18.0,17.0,20.0,23.0,22.0,19.0,24.0]
        
        let numberOfDate = 24
        self.numberOfMinutes = 60
        self.numberOfHours = 24*7
//        weatherChartView.
        setChart(number: numberOfMinutes, temperature: next_hour_temperature, precipitation: next_7_days_precipitation, dateFormate: "HH:mm", zoomScale: 7, duration: 60)
        // Do any additional setup after loading the view, typically from a nib.
        updateWeatherForLocation(location: default_location)
        updateMinutelyWeatherForLocation(location: default_location)
        
//        print("aa"+(self.hourlyForecastData.first?.temperature.description)!)
//        print(self.hourlyForecastData)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintAdjustmentMode = .normal
        self.navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }
    
    
    @IBAction func historyButtonAction(_ sender: Any) {
        self.isHistoryClicked = true
//        performSegue(withIdentifier: "historySegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let historyVC: historyViewController = segue.destination as! historyViewController
            historyVC.currentLocation = self.currentLocation
            historyVC.locationToShow = self.locationToShow
    }
    
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            updateWeatherForLocation(location: locationString)
        }
    }
    
    func updateWeatherForLocation (location:String)
    {
        self.currentLocation = location
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil
            {
//                if let place = placemarks?.first?.subLocality
//                {
//                    self.locationToShow = "\(place)"
//                }
                if let location = placemarks?.first?.location
                {
                    self.getNameOfLocation(location: (placemarks?.first?.location)!)
                    HourlyWeather.forecast(withLocation: location.coordinate, completion: { (results:[HourlyWeather]?) in

                        if let weatherData = results {
                            self.forecastData = weatherData
                            self.hourlyForecastData = self.forecastData
//                            print(self.forecastData)
                            DispatchQueue.main.async {
                                self.tempLabel.text = (Int((self.forecastData.first?.temperature)!).description)+"°F"
                                //self.iconLabel.text = self.forecastData.first?.icon.description
                                self.iconImageView.image = UIImage(named:(self.forecastData.first?.icon.description)!)
                                
                                self.summaryLabel.text = self.forecastData.first?.summary.description
//                                self.title = self.currentLocation//
                                self.title = self.locationToShow
                                self.next_7_days_temperature.removeAll()
                                self.next_7_days_precipitation.removeAll()
                                
                                for theForecastData in self.forecastData{
                                    self.next_7_days_temperature.append(theForecastData.temperature)
                                    self.next_7_days_precipitation.append(theForecastData.precipitation*100)
                                }
                                self.weatherChartView.zoom(scaleX: 0, scaleY: 1, x: 0, y: 0)
                                self.weatherChartView.xAxis.granularity = 3600
                                self.setChart(number: self.numberOfHours, temperature: self.next_7_days_temperature, precipitation: self.next_7_days_precipitation, dateFormate: "MMM d h:mm a", zoomScale: 40, duration: 3600)
                            }
                        }
                    })
                }
            }
        }
    }
    
    
    
    func updateMinutelyWeatherForLocation (location:String)
    {
        self.currentLocation = location
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    self.getNameOfLocation(location: (placemarks?.first?.location)!)
                    MinutelyWeather.forecast(withLocation: location.coordinate, completion: { (results:[MinutelyWeather]?) in
                        
                        if let weatherData = results {
                            self.minutelyForecastData = weatherData

                            DispatchQueue.main.async {
                                self.next_hour_temperature.removeAll()
                                self.next_hour_precipitation.removeAll()
                                
                                var index_count:Int = 0
                                for theForecastData in self.forecastData{
                                    if(index_count>=60)
                                    {
                                        break
                                    }
                                    self.next_hour_temperature.append(theForecastData.temperature)
                                    self.next_hour_precipitation.append(theForecastData.precipitation*100)
                                    index_count = index_count + 1
                                }
                            }
                        }
                    })
                }
            }
        }
    }
//    let manager = CLLocationManager()

    func getNameOfLocation(location:CLLocation)
    {
        
                CLGeocoder().reverseGeocodeLocation(location){ (placemark, error) in
                    if error != nil
                    {
                        print("Error")
                    }
                    else
                    {
                        if let place = placemark?[0]
                        {
                            print("hello,world1")
                            print(place)
                            print("hello,world2")
//                          self.locationToShow = "\(place.locality?.description)"
                            self.locationToShow = ""
                            if place.locality != nil{
                                self.locationToShow = (place.locality?.description)!
                                if place.administrativeArea != nil{
                                    self.locationToShow = self.locationToShow + ", " + (place.administrativeArea?.description)!
                                }
                            }else if place.administrativeArea != nil{
                                self.locationToShow = (place.administrativeArea?.description)!
                                if place.country != nil{
                                    self.locationToShow = self.locationToShow + ", " + (place.country?.description)!
                                }
                            }else if place.country != nil{
                                self.locationToShow = (place.country?.description)!
                            }else if place.ocean != nil{
                                self.locationToShow = (place.ocean?.description)!
                            }
                            
                            if place.postalCode != nil{
                                print("Postal Code is " + (place.postalCode?.description)!)
                            }
                            
                            self.title = self.locationToShow
                        }
                    }
                }
    }
    
    func setChart(number: Int, temperature:[Double], precipitation:[Double],dateFormate:String, zoomScale: Double, duration: Int)
    {
        weatherChartView.data?.clearValues()
//        weatherChartView.resetZoom()
        weatherChartView.zoom(scaleX: CGFloat(zoomScale), scaleY: 1, x: 0, y: 0)
        let now = Int(Date().timeIntervalSince1970)
        let hourSeconds: Int = 3600
        
        var dataEntries: [ChartDataEntry] = []
        var dataPrecipitationEntries: [ChartDataEntry] = []
        for i in 0..<temperature.count
        {
            let dataEntry = ChartDataEntry(x: Double(now+i * duration), y: temperature[i])
            let dataPrecipitationEntry = ChartDataEntry(x: Double(now+i * duration), y:precipitation[i])
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
        chartData.addDataSet(chartPrecipitationDataSet)
        weatherChartView.xAxis.valueFormatter = DateValueFormatter(dateFormat: dateFormate)
        weatherChartView.data = chartData
//        weatherChartView.xAxis.labelPosition = .bottom
        
        
//        weatherChartView.xAxis.value
        
    }
    
    @IBAction func nextHourAction(_ sender: Any) {
        
        weatherChartView.zoom(scaleX: 0, scaleY: 1, x: 0, y: 0)
        weatherChartView.xAxis.granularity = 60
        setChart(number: self.numberOfMinutes, temperature: self.next_hour_temperature, precipitation: self.next_7_days_precipitation, dateFormate: "HH:mm", zoomScale: 7, duration: 60)
        
//        updateMinutelyWeatherForLocation(location: self.currentLocation)
        
    }
    
    
    @IBAction func next7daysAction(_ sender: Any) {
        
        weatherChartView.zoom(scaleX: 0, scaleY: 1, x: 0, y: 0)
        weatherChartView.xAxis.granularity = 3600
        setChart(number: self.numberOfHours, temperature: self.next_7_days_temperature, precipitation: self.next_7_days_precipitation, dateFormate: "MMM d h:mm a", zoomScale: 40, duration: 3600)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

