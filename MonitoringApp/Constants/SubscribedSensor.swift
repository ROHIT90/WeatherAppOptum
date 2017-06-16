//
//  SubscribedSensor.swift
//  MonitoringApp
//
//  Created by Fnu, Rohit on 6/14/17.
//  Copyright © 2017 Fnu, Rohit. All rights reserved.
//

import Foundation

class SubscribedSensor {
    static var sharedInstance = SubscribedSensor()
    private init() {}
    var subscirbedSensorName:String?
}
