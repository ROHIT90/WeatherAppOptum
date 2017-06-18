//
//  ViewController.swift
//  MonitoringApp
//
//  Created by Fnu, Rohit on 6/12/17.
//  Copyright © 2017 Fnu, Rohit. All rights reserved.
//

import UIKit
import SocketIO
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tabbleView: UITableView!
    var sensorNameArray = [String]()
    var sensorName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetUp()
        getSensors()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        SocketIOManager.sharedInstance.closeConnection()
    }
    
    func getSensors() {
        Alamofire.request(SENSORNAME_URL).responseData { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let json = JSON(responseData.result.value!)
                if let data = json.arrayObject {
                    self.sensorNameArray = data as! [String]
                }
                if self.sensorNameArray.count > 0 {
                    self.tabbleView.reloadData()
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == GRAPH_VIEW) {
            let barViewController = segue.destination as! BarChartViewController
            barViewController.sensorName =  sensorName
        }
    }
    
    func navigationBarSetUp() {
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 41/255, green: 182/255, blue: 246/255, alpha: 1)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tabbleView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! HomeTableViewCell
        if let cellTitle = currentCell.titleLabel.text {
            sensorName = cellTitle
        }
        SubscribedSensor.sharedInstance.subscirbedSensorName = currentCell.titleLabel.text
        SocketIOManager.sharedInstance.establishConnection()
        performSegue(withIdentifier: GRAPH_VIEW, sender: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensorNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HomeTableViewCell {
            cell.titleLabel.text = sensorNameArray[indexPath.row]
            return cell
        } else {
            return HomeTableViewCell()
        }
    }
}

