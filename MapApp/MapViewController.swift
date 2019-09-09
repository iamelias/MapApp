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
    
    static var refreshIndicator: Int = 0 //0 is off, 1 is on
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetStudentLocationClient.getStudentLocations(completion: self.handleGetLocationResponse(success: error:)) //running GetStudentLocation client to get location object data
        //print("I'm back in MapViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        GetStudentLocationClient.getStudentLocations(completion: self.handleGetLocationResponse(success: error:)) //running GetStudentLocation client to get location object data
        if MapViewController.refreshIndicator == 1 { //if refresh is on, ignore if not on
        refresh()
            print("refreshIndicator: 1")
            MapViewController.refreshIndicator = 0 //turning off refresh
        }
        else {
            print("refresh Indicator is still 0")
        }
    }
    
    
    @IBAction func refreshTapped(_ sender: Any) {
        
        refresh()

    }
    
    func refresh() {
        print("refreshed")
        
        mapView.removeAnnotations(MapViewController.myAnnotations)
        GetStudentLocationClient.getStudentLocations(completion: self.handleGetLocationResponse(success: error:)) //running GetStudentLocation client to get location object data
        
    }
    
    func handleGetLocationResponse(success: Bool, error: Error?) {
        //let LocationDataStruct = GetStudentLocation().getStructData()
        MapViewController().makeAnnotations() //calling function that makes annotations for pin
        //print(MapViewController.myAnnotations) Testing annotations stored in class property successfully
        self.mapView.addAnnotations(MapViewController.myAnnotations) //adding all annotations to map
        
    }
    
    func makeAnnotations() {
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
            mediaURL = mylocations[mapObject].mediaURL
            
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
            if let studentURL = view.annotation?.subtitle! {
                app.open(URL(string: studentURL)!, options: [:], completionHandler: nil)
            }
        }
    }
    
}
