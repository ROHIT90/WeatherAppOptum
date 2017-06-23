//
//  SocketIOManager.swift
//  MonitoringApp
//
//  Created by Fnu, Rohit on 6/12/17.
//  Copyright © 2017 Fnu, Rohit. All rights reserved.
//

import SocketIO
import SwiftyJSON

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    let sensorDataNotificationKey = SENSOR_DATA_NOTIFICATION_KEY
    let socket = SocketIOClient(socketURL: URL(string: BASE_URL)!, config: [.log(true), .forcePolling(true)])
    
    override init() {
        super.init()
        socket.on("connect") { ( dataArray, ack) -> Void in
            self.socket.emit("subscribe", SubscribedSensor.sharedInstance.subscirbedSensorName!)
        }
        
        socket.on("data") { ( dataArray, ack) -> Void in
            let dataDict:[String: Any] = ["data": dataArray]
            NotificationCenter.default.post(name: Notification.Name(rawValue: self.sensorDataNotificationKey), object: dataArray, userInfo: dataDict)
        }
        
        socket.on("data") { ( dataArray, ack) -> Void in
            print("initial data array\(dataArray)")
            let dataDict:[String: Any] = ["init": dataArray]
            let jsonVar = JSON(dataDict)
            let type = jsonVar["minute"]["val"].arrayValue
            print("this is init dict\(type)")
        }
    }
    
    func unsubscribe() {
        self.socket.emit("unsubscribe", SubscribedSensor.sharedInstance.subscirbedSensorName!)
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
