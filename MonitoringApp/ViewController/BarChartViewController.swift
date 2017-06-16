//
//  BarChartViewController.swift
//  MonitoringApp
//
//  Created by Fnu, Rohit on 6/12/17.
//  Copyright © 2017 Fnu, Rohit. All rights reserved.
//

import UIKit
import SwiftChart
import Foundation
import Alamofire
import SwiftyJSON

class BarChartViewController: UIViewController {
    
    var sensorName:String = ""
    var sensorNameArray = [String]()
    var temperatureArray:Array<Float> = []
    var maxTemperature:Float?
    var minTemperature:Float?
    let sensorDataNotificationKey = SENSOR_DATA_NOTIFICATION_KEY
    @IBOutlet weak var chart: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = sensorName
        getTemperatureRange()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateGraph(_:)), name: NSNotification.Name(rawValue: sensorDataNotificationKey), object: nil)
    }
    
    func updateGraph(_ notification: NSNotification) {
        if let item = notification.userInfo?["data"] as Any? {
            let swiftyJsonVar = JSON(item)
            let newValueTemp = swiftyJsonVar[0]["val"].floatValue
            
            self.temperatureArray.append(newValueTemp)
            let series = ChartSeries(self.temperatureArray)
            series.color = ChartColors.redColor()
            self.chart.add(series)
        }
    }
    
    func getTemperatureRange() {
        Alamofire.request(RANGE_URL).responseJSON { resopnse in
            let result = resopnse.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let temprature = dict[self.sensorName] as? Dictionary <String, AnyObject> {
                    if let min = temprature["min"] as? Float {
                        self.minTemperature = min
                    }
                    if let max = temprature["max"] as? Float {
                        self.maxTemperature = max
                    }
                    self.temperatureArray.append(self.minTemperature!)
                    self.temperatureArray.append(self.maxTemperature!)
                    let series = ChartSeries(self.temperatureArray)
                    series.color = ChartColors.greenColor()
                    self.chart.add(series)
                }
            }
        }
    }
    
}
