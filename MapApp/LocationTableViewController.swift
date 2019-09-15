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
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
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
        reload()
        
    }
    
    func reload() {
        

        MapViewController().refresh(inMap: false)
        autoRefresh()
    }
    
    func autoRefresh() {
        Table.reloadData()
    }
    @IBAction func refreshTapped(_ sender: Any) {
        Table.reloadData()
        print("Table reload was called")    }
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        DeleteClient.DeleteSession {
            print("Made it to DispatchQueue.main in table")
            DispatchQueue.main.async {
                print("made it to logoutTapped")
                self.dismiss(animated: true, completion: nil)
            }
        
    }
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        var updateTester = false
        updateTester = AddLocationClient.ObjectData.ObjectIdent //either change to false or keep true
        
        guard !updateTester else {
            
            let alert = UIAlertController(title: "Update", message: "Do you want to update your location?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                
                let AddLocationViewController:UIViewController = UIStoryboard(name: "Main", bundle:  nil).instantiateViewController(withIdentifier: "StoryLoca") as UIViewController
                
                self.present(AddLocationViewController, animated: true, completion: nil) //calling AddViewController modualy
                
                print("alert is ok")
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction) in print("cancel was tapped")
                
                return
            })
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        let AddLocationViewController:UIViewController = UIStoryboard(name: "Main", bundle:  nil).instantiateViewController(withIdentifier: "StoryLoca") as UIViewController
        
        self.present(AddLocationViewController, animated: true, completion: nil) //calling AddViewController modualy

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
