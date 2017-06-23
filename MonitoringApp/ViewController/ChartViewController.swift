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

class ChartViewController: UIViewController {
    
    var sensorName:String = ""
    var sensorNameArray = [String]()
    var temperatureArray:Array<Float> = []
    var maxTemperature:Float?
    var minTemperature:Float?
    let sensorDataNotificationKey = SENSOR_DATA_NOTIFICATION_KEY

    @IBOutlet weak var deviationValue: UILabel!
    @IBOutlet weak var minValue: UILabel!
    @IBOutlet weak var maxValue: UILabel!
    @IBOutlet weak var chart: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = sensorName
        getTemperatureRange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    func updateMinuteGraph(_ notification: NSNotification) {
        if let item = notification.userInfo?["data"] as Any? {
            let jsonVar = JSON(item)
            let typeScale = jsonVar[0]["scale"].stringValue
            let type = jsonVar[0]["type"].stringValue
            if type == "update" && typeScale == "minute" {
                let newValueTemp = jsonVar[0]["val"].floatValue
                self.temperatureArray.append(newValueTemp)
                let series = ChartSeries(self.temperatureArray)
                if newValueTemp > maxTemperature! || newValueTemp < minTemperature! {
                    series.color = ChartColors.redColor()
                    deviationValue.textColor = UIColor.red
                } else if newValueTemp == maxTemperature! || newValueTemp == minTemperature! {
                    series.color = ChartColors.greenColor()
                    deviationValue.textColor = UIColor.green
                } else {
                    series.color = ChartColors.greenColor()
                    deviationValue.textColor = UIColor.green
                }
                self.chart.add(series)
                self.deviationValue.text = String(newValueTemp)
            }
        }
    }
    
    func updateRecentGraph(_ notification: NSNotification) {
        if let item = notification.userInfo?["data"] as Any? {
            let jsonVar = JSON(item)
            let typeScale = jsonVar[0]["scale"].stringValue
            let type = jsonVar[0]["type"].stringValue
            if type == "update" && typeScale == "recent" {
                let newValueTemp = jsonVar[0]["val"].floatValue
                self.temperatureArray.append(newValueTemp)
                let series = ChartSeries(self.temperatureArray)
                if newValueTemp > maxTemperature! || newValueTemp < minTemperature! {
                    series.color = ChartColors.redColor()
                    deviationValue.textColor = UIColor.red
                } else if newValueTemp == maxTemperature! || newValueTemp == minTemperature! {
                    series.color = ChartColors.greenColor()
                    deviationValue.textColor = UIColor.green
                } else {
                    series.color = ChartColors.greenColor()
                    deviationValue.textColor = UIColor.green
                }
                self.chart.add(series)
                self.deviationValue.text = String(newValueTemp)
            }
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
                    self.minValue.text = String(describing: self.minTemperature!)
                    self.maxValue.text = String(describing: self.maxTemperature!)
                    self.temperatureArray.append(self.minTemperature!)
                    self.temperatureArray.append(self.maxTemperature!)
                    let series = ChartSeries(self.temperatureArray)
                    series.color = ChartColors.greenColor()
                    self.chart.add(series)
                }
            }
        }
    }
    
    @IBAction func minuteButtonTapped(_ sender: Any) {
        chart.removeAllSeries()
        NotificationCenter.default.removeObserver(self)

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateMinuteGraph(_:)), name: NSNotification.Name(rawValue: sensorDataNotificationKey), object: nil)
    }
    @IBAction func recentButtonTapped(_ sender: Any) {
        chart.removeAllSeries()
        NotificationCenter.default.removeObserver(self)

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateRecentGraph(_:)), name: NSNotification.Name(rawValue: sensorDataNotificationKey), object: nil)
    }
    @IBAction func unsubscribeButtonTapped(_ sender: Any) {
        SocketIOManager.sharedInstance.unsubscribe()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
