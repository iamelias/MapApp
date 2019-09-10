//
//  LocationTableViewController.swift
//  MapApp
//
//  Created by Elias Hall on 9/3/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit

class LocationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var Table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        GetStudentLocationClient.getStudentLocations(completion: self.handleGetLocationResponse(success: error:)) //running GetStudentLocation client to get location object data
        if MapViewController.refreshIndicator == 1 { //if refresh is on, ignore if not on
            MapViewController().refresh(inMap: false)
            print("refreshIndicator: 1")
            MapViewController.refreshIndicator = 0 //turning off refresh
        }
        else {
            print("refresh Indicator is still 0")
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Table.reloadData()
    }
    
    func handleGetTableResponse(success: Bool, error: Error?) {
        print("I got here")
    }
    
    
    
    

     func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        
       // print("Table Test: 1")
        //print("Test Table row number: \(DataHoldStruct.ResponseDataArray.count)")
        return DataHoldStruct.ResponseDataArray.count
        
       
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("Table Test: 2")
        var tableRowLabel = DataHoldStruct.ResponseDataArray //assigning struct that holds each student object
        //print(tableRowLabel) //Testing TableView cell data retrieved
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) //defining the reusable cell
        cell.textLabel?.text = "\(tableRowLabel[indexPath.row].firstName)  \(tableRowLabel[indexPath.row].lastName)" // defining student's name text
        cell.detailTextLabel?.text = tableRowLabel[indexPath.row].mediaURL //defining student's url subText
    
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var tableRowLabel = DataHoldStruct.ResponseDataArray
        let app = UIApplication.shared
        app.open(URL(string: tableRowLabel[indexPath.row].mediaURL)!, options: [:], completionHandler: nil)

}
}
