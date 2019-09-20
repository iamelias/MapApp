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
        
        if MapViewController.refreshIndicator == 1 { //if refresh indicator is on, ignore if not on
            MapViewController().refresh(inMap: false) //recalling GetStudent to refresh database data
            //    print("refreshIndicator: 1")
            MapViewController.refreshIndicator = 0 //turning off refresh indicator
        }
        else {
            //   print("refresh Indicator is still 0")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.reload()
    }
    
    func reload() {
        MapViewController().refresh(inMap: false) //refreshing database right before reloading TableView
        autoRefresh()
    }
    
    func autoRefresh() {
        
        Table.reloadData() //reloading TableView with refreshed data
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        Table.reloadData()
        //print("Table reload was called")
        
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        //print("made it to logoutTapped in TableController")
        DeleteClient.DeleteSession {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil) //return to signin screen
            }
            
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        var updateTester = false //initially won't update
        updateTester = AddStudentClient.ObjectData.ObjectIdent //either change to false or keep true
        
        guard !updateTester else {
            
            let alert = UIAlertController(title: "Update", message: "Do you want to update your location?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                
                let AddLocationViewController:UIViewController = UIStoryboard(name: "Main", bundle:  nil).instantiateViewController(withIdentifier: "StoryLoca") as UIViewController
                
                self.present(AddLocationViewController, animated: true, completion: nil) //calling AddViewController modualy
                
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
        // print("Sucessfully reached handleGetTableResponse")
    }
    
    func downloadFail() { //alert if downloard error
        let alert = UIAlertController(title: "Download Failed", message: "Failed to retrieve student locations", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return DataHoldStruct.ResponseDataArray.count //defining number of cells
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        guard let url = URL(string: tableRowLabel[indexPath.row].mediaURL!) else {
            return
        }
        app.open(url, options: [:], completionHandler: nil) //opening url when cell tapped
    }
}
