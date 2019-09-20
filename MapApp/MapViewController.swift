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
    static var errorHandler = false //error handler is on
    var mapChecker: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard MapViewController.errorHandler == false else { //errorHandler is off or return
            print("ViewDidLoad guard")
            return
        }
       GetStudentLocationClient.getStudentLocations(completion: self.handleGetLocationResponse(success: error:)) //running GetStudentLocation client to get location object data
        //print("I'm back in MapViewController")
        }

    
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard MapViewController.errorHandler == false else { //if off continue, if on execute within braces
            if MapViewController.errorHandler == true {
                downloadFail()
                MapViewController.errorHandler = true
                print("ViewDidAppear inside guard")
            }
            
            print("ViewDid Appear outside guard")
            return
            
        }
        
        if MapViewController.refreshIndicator == 1 { //if refresh is on, ignore if not on
            refresh(inMap: true)
            print("refreshIndicator: 1")
            MapViewController.refreshIndicator = 0 //turning off refresh
        }
        else {
            print("refresh Indicator is still 0")
        }
        

    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        var updateTester = false
            updateTester = AddStudentClient.ObjectData.ObjectIdent //either change to false or keep true
        
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
    
    @IBAction func refreshTapped(_ sender: Any) {
        
        refresh(inMap: true)

    }
    @IBAction func logoutTapped(_ sender: Any) {
        
          DeleteClient.DeleteSession {
        DispatchQueue.main.async {
        print("made it to logoutTapped")
            self.dismiss(animated: true, completion: nil)
        }
        }
        
        print("Logged out from MapView")
        
    }
    
    func refresh (inMap: Bool) {
        print("refreshed")
        
        if inMap { //if accessing from map controller
        mapView.removeAnnotations(MapViewController.myAnnotations)
        GetStudentLocationClient.getStudentLocations(completion: self.handleGetLocationResponse(success: error:)) //running GetStudentLocation client to get location object data
        }
        
        else {
             GetStudentLocationClient.getStudentLocations(completion: LocationTableViewController().handleGetTableResponse(success: error:)) //running GetStudentLocation client to get location object data
        }
        
    }
    
    func downloadFail() {
        print("I got to download fail")
        let alert = UIAlertController(title: "Download Failed", message: "The student locations failed to download", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
       //self.show(alert, sender: nil)
        
        return
    }
    
    func handleGetLocationResponse(success: Bool, error: Error?) {
        if !success {
            MapViewController.errorHandler = true
            
        }
        
        else {
        
        //let LocationDataStruct = GetStudentLocation().getStructData()
        if mapView != nil {
        MapViewController().makeAnnotations() //calling function that makes annotations for pin
        //print(MapViewController.myAnnotations) Testing annotations stored in class property successfully
         self.mapView.addAnnotations(MapViewController.myAnnotations)  //adding all annotations to map
        }
    }
    }
    
    func makeAnnotations() {
        
//        guard DataHoldStruct.ResponseDataArray != nil else {
//            downloadFail()
//            return
//        }
        var mylocations = DataHoldStruct.ResponseDataArray//GetStudentLocation.ResponseData //getting all api objects
              // print(mylocations) //Testing Data retrievel
        //        print(mylocation.count) //Testing mapObject count
        
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
        //MapViewController.myAnnotations.removeAll()
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
            //******************
            
            guard let url = URL(string: (view.annotation?.subtitle!)!) else {
                return
            }
            app.open(url, options: [:], completionHandler: nil)

            }
        }
    }
    

