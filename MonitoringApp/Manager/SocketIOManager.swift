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
    
    let mySpecialNotificationKey = "com.rohitgandu.harami"

    
    let socket = SocketIOClient(socketURL: URL(string: BASE_URL)!, config: [.log(true), .forcePolling(true)])
    
    override init() {
        super.init()

        socket.on("connect") { ( dataArray, ack) -> Void in
            print("Connected")
            self.socket.emit("subscribe", SubscribedSensor.sharedInstance.subscirbedSensorName!)
        }
        
        socket.on("data") { ( dataArray, ack) -> Void in
            
            let dataDict:[String: Any] = ["data": dataArray]

            
            NotificationCenter.default.post(name: Notification.Name(rawValue: self.mySpecialNotificationKey), object: dataArray, userInfo: dataDict)
            
            
            
//            let swiftyJsonVar = JSON(dataArray)
//            print("temppp\(swiftyJsonVar[0]["val"])")
//            let newValueTemp = swiftyJsonVar[0]["val"].string
//            if newValueTemp != nil {
//                SubscribedSensor.sharedInstance.newTemperatureValue = Float(newValueTemp!)
//            } else {
//                SubscribedSensor.sharedInstance.newTemperatureValue = 0.0
//            }
//            
            
        }
//        socket.onAny {
//            print("got event: \($0.event) with items \(String(describing: $0.items))")
//        }
        
 
    }
    
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }

}
