//
//  AddLocationViewController.swift
//  MapApp
//
//  Created by Elias Hall on 8/29/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddLocationViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var URLText: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var addLocationMap: MKMapView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userAddedLocation: String = ""
    var userTransferURL: String = ""
    var userTransferLat: Double = 0
    var userTransferLon: Double = 0
    
    override func viewDidLoad() { //initial view setup
        super.viewDidLoad()
        locationText.delegate = self
        URLText.delegate = self
        addLocationMap.isHidden = true //hiding post find location look
        addButton.isHidden = true
        activityIndicator.isHidden = true
        
    }
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil) //returning to MapViewController or TableViewController
    }
    
    @IBAction func tapFindOnMap(_ sender: Any) {
        self.view.endEditing(true) //automatically dismiss keyboard
        activityIndicRun(true) //starting the activity indicator
        let address = locationText.text!
        let geocode = CLGeocoder()
        geocode.geocodeAddressString(address, completionHandler: { placemarks, error in if (error != nil) {
            
            //Geocoding fail alert
            let alert = UIAlertController(title: "Geocoding Failed", message: "Cannot present the location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            self.activityIndicator.isHidden = true
            
            return
            
            }
            
            if let placemark = placemarks?[0]  { //Defining coordinate pin for addLocationView
                let lat = placemark.location!.coordinate.latitude
                let transferLat = Double(lat)
                let lon = placemark.location!.coordinate.longitude
                let transferLon = Double(lon)
                let coordinate = placemark.location!.coordinate
                
                self.userTransferLat = transferLat
                self.userTransferLon = transferLon
                
                var mapRegion = MKCoordinateRegion() //Defining map surrounding pin when adding view
                mapRegion.center = coordinate
                mapRegion.span.latitudeDelta = 0.2
                mapRegion.span.longitudeDelta = 0.2
                
                self.addLocationMap.setRegion(mapRegion, animated: true)
                
                let name = placemark.name!
                let region = placemark.administrativeArea!
                
                let addedLocation = "\(name),\(region)" //Defining annotation detail
                self.userAddedLocation = addedLocation
                self.userTransferURL = self.URLText.text!
                
                let annotation = MKPointAnnotation() //creating/defining mapkit annotation
                annotation.coordinate = placemark.location!.coordinate
                
                let annotationDetail = "\(placemark.name!), \(placemark.administrativeArea!) \(placemark.country!)"
                annotation.title = annotationDetail
                self.addLocationMap.addAnnotation(annotation)
                self.UIChange() //changing objects present/hidden

            }})
    }
    
    @IBAction func addTapped(_ sender: Any)
    {
        var updateTester = false //Initially add will not update
        updateTester = AddStudentClient.ObjectData.ObjectIdent //update or add
        if updateTester == false { //If false, will not update will add for first time
            AddStudentClient.postStudentLocation(newLocation: userAddedLocation, newURL: self.URLText.text!, newLatitude: userTransferLat, newLongitude: userTransferLon, completion: self.handleGeoResponse(success: error:) )
        }
            
        else { //if true, data is already present so, will update the student data
            updateLocationClient.update(newLocation: userAddedLocation, newURL: self.URLText.text!, newLatitude: userTransferLat, newLongitude: userTransferLon, completion: self.handleGeoResponse(success: error:) )
            
        }
        
        dismiss(animated: true, completion: nil) //returning to mapViewController or tableViewController
    }
    
    func UIChange() { //UI look after Find on Map is selected
        
        addLocationMap.isHidden = false
        addButton.isHidden = false
        locationText.isHidden = true
        URLText.isHidden = true
        findButton.isHidden = true
        activityIndicRun(false)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { //creating pin Image
        let reuseIdentifier = "mapPin" // declaring reuse identifier
        
        var pinImage: MKPinAnnotationView? = nil
        pinImage = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        
        if pinImage == nil {
            pinImage = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinImage!.canShowCallout = true //making box appear when pin is tapped
            pinImage!.pinTintColor = .red //making the pin red
        }
        else {
            pinImage!.annotation = annotation
        }
        
        return pinImage //returning the pin image/view
    }
    
    func handleGeoResponse(success: Bool, error: Error?) { //if there is a problem posting to database
        
        if success == false { //alert if posting fails
            let alert = UIAlertController(title: "Error: Posting Failed", message: "Cannot post the location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
            
        else {
            MapViewController.refreshIndicator = 1 //indicating for refresh
            self.dismiss(animated: true, completion: nil) //returning to mapViewController or tableViewController
        }
    }
    
    func activityIndicRun(_ login: Bool) { //Running acitivityIndicator
        activityIndicator.isHidden = !login //activity controller appears when login is tapped
        if login {
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //dismissing keyboard
        locationText.resignFirstResponder()
        URLText.resignFirstResponder()
        return true
    }
}
