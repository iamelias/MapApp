//
//  MapViewController.swift
//  MapApp
//
//  Created by Elias Hall on 8/29/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    static var myAnnotations: [MKPointAnnotation] = [] // class property holding annotations for multi-method access
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    static var refreshIndicator: Int = 0 //0 is off, 1 is on
    static var errorHandler = false //for download error, initally off
    var mapChecker: Bool = true //checking if I'm in mapViewController
    static var userExists: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard MapViewController.errorHandler == false else { //errorHandler is off or return
            return
        }
        if MapViewController.userExists == false { //prevents changing user's pin name when relogging in
            GetPublicClient.publicInfo(completion: self.handleGetUserResponse(success:error:))
        }
        GetStudentLocationClient.getStudentLocations(completion: self.handleGetLocationResponse(success: error:)) //running GetStudentLocation client to get location object data
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard MapViewController.errorHandler == false else { //if off continue, if on execute within braces
            if MapViewController.errorHandler == true {
                downloadFail()
                MapViewController.errorHandler = true
            }
            return
        }
        
        if MapViewController.refreshIndicator == 1 { //if refresh is on refresh, ignore if not on
            refresh(inMap: true)
            //print("refreshIndicator: 1")
            MapViewController.refreshIndicator = 0 //turning off refresh
        }
        else {
            //  print("refresh Indicator is still 0")
        }
        
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        var updateTester = false
        updateTester = AddStudentClient.ObjectData.ObjectIdent //either change to false or keep true
        
        guard !updateTester else { //if updating instead of adding for first time
            
            let alert = UIAlertController(title: "Update", message: "Do you want to update your location?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                
                let AddLocationViewController:UIViewController = UIStoryboard(name: "Main", bundle:  nil).instantiateViewController(withIdentifier: "StoryLoca") as UIViewController
                
                self.present(AddLocationViewController, animated: true, completion: nil) //calling AddViewController modualy
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction) in
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
    
    @IBAction func refreshTapped(_ sender: Any) { //if refresh button is tapped call refresh function
        refresh(inMap: true)
        
    }
    @IBAction func logoutTapped(_ sender: Any) {
        DeleteClient.DeleteSession { //Deauthenticating
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil) //returning to loginScreen
            }
        }
    }
    
    func refresh (inMap: Bool) { //refresh function refreshes MapViewController/TableViewController
        
        if inMap { //if accessing from map controller
            mapView.removeAnnotations(MapViewController.myAnnotations)
            GetStudentLocationClient.getStudentLocations(completion: self.handleGetLocationResponse(success: error:)) //running GetStudentLocation client to get location object data
        }
            
        else {
            GetStudentLocationClient.getStudentLocations(completion: LocationTableViewController().handleGetTableResponse(success: error:)) //running GetStudentLocation client to get location object data
        }
        
    }
    
    func downloadFail() { //called if there is a download fail in client
        let alert = UIAlertController(title: "Download Failed", message: "The student locations failed to download", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        
        return
    }
    
    func handleGetUserResponse(success: Bool, error: Error?) {
        if success == true {
            MapViewController.userExists = true //for possible relogging in
            // print("Getting User was success")
        }
        else {
            // print("Failed to get User")
        }
    }
    
    func handleGetLocationResponse(success: Bool, error: Error?) {
        if !success {
            MapViewController.errorHandler = true //For setting error handler for error alert
            
        }
            
        else {
            
            if mapView != nil {
                MapViewController().makeAnnotations() //calling function that makes annotations for pin
                self.mapView.addAnnotations(MapViewController.myAnnotations)  //adding all annotations to map
            }
        }
    }
    
    func makeAnnotations() {
        
        var mylocations = DataHoldStruct.ResponseDataArray//GetStudentLocation.ResponseData //getting all api objects
        
        var annotationsArray = [MKPointAnnotation]() //holding annotations
        let locationsNumber = mylocations.count
        
        var lat: Double = 0.0 //initializing pin data
        var long: Double = 0.0
        var coordinate: CLLocationCoordinate2D
        var first: String = ""
        var last: String = ""
        var mediaURL: String = ""
        
        for mapObject in 0...(locationsNumber - 1) { //for each object...
            
            lat = CLLocationDegrees(mylocations[mapObject].latitude) //converting to mapkit lat & long degrees
            long = CLLocationDegrees(mylocations[mapObject].longitude)
            
            coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long) //defining mapkit coordinate from lat&long
            
            first = mylocations[mapObject].firstName
            last = mylocations[mapObject].lastName
            mediaURL = mylocations[mapObject].mediaURL!
            
            let annotation = MKPointAnnotation() //creating/defining mapkit annotation
            annotation.coordinate = coordinate // giving annotation its info
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotationsArray.append(annotation) //adding annotation to array of annotations
            
        } //end object mapkit assignments. All stored in annotations array
        MapViewController.myAnnotations = annotationsArray //assigning annotations array to class property array
        
        return //returning to handleLoginResponse method
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { //creating pin Image
        let reuseIdentifier = "mapPin" // declaring reuse identifier
        
        var pinImage: MKPinAnnotationView? = nil
        pinImage = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        
        if pinImage == nil {
            pinImage = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinImage!.canShowCallout = true //making box appear when pin is tapped
            pinImage!.pinTintColor = .red //making the pin red
            pinImage!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) //adding info button
        }
        else {
            pinImage!.annotation = annotation
        }
        
        return pinImage //returning the pin image/view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) { //this method opens URL in safari
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            
            guard let url = URL(string: (view.annotation?.subtitle!)!) else {
                return
            }
            app.open(url, options: [:], completionHandler: nil)
        }
    }
}


