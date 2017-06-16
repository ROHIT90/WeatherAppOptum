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
    var sesnosrName:String = ""
    var sensorNameArray = [String]()
    
    var myArray:Array<Float> = []
    
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var newTempValueLabel: UILabel!
    
    var maxTemperature:Float?
    var minTemperature:Float?
    
    let mySpecialNotificationKey = "com.rohitgandu.harami"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = sesnosrName
        getTemperatureRange()
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateGraph(_:)), name: NSNotification.Name(rawValue: mySpecialNotificationKey), object: nil)
        
        
    }
    
    func updateGraph(_ notification: NSNotification) {
        print("Notification sent!")
        if let item = notification.userInfo?["data"] as Any? {
            // draw graph
            print("this is item\(item)");
            let swiftyJsonVar = JSON(item)
            print("temppp\(swiftyJsonVar[0]["val"])")
            let newValueTemp = swiftyJsonVar[0]["val"].floatValue
            
            //Append all the values youget in item above to your myArray
            self.myArray.append(newValueTemp)
            let series = ChartSeries(self.myArray)
            series.color = ChartColors.redColor()
            self.chart.add(series)
        }
    }
    
    
    func getTemperatureRange() {
        Alamofire.request(RANGE_URL).responseJSON { resopnse in
            let result = resopnse.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let temprature = dict[self.sesnosrName] as? Dictionary <String, AnyObject> {
                    if let min = temprature["min"] as? Float {
                        self.minTemperature = min
                        print("currentTemprature:\(min)")
                    }
                    if let max = temprature["max"] as? Float {
                        self.maxTemperature = max
                        print("currentTemprature:\(max)")
                    }
                    self.myArray.append(self.minTemperature!)
                    self.myArray.append(self.maxTemperature!)
                    let series = ChartSeries(self.myArray)
                    series.color = ChartColors.greenColor()
                    self.chart.add(series)
                }
            }
        }
    }
    
}
