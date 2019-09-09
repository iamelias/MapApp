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

class AddLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var LocationText: UITextField!
    @IBOutlet weak var URLText: UITextField!
    @IBOutlet weak var FindButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var addLocationMap: MKMapView!
    @IBOutlet weak var addButton: UIButton!
    
    //var delegate = MKMapViewDelegate.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLocationMap.isHidden = true
        addButton.isHidden = true
        
    }
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
       // dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapFindOnMap(_ sender: Any) {
        let address = LocationText.text!
        let geocode = CLGeocoder()
        geocode.geocodeAddressString(address, completionHandler: { placemarks, error in if (error != nil) { return}
            if let placemark = placemarks?[0]  {
                let lat = placemark.location!.coordinate.latitude
                let transferLat = Double(lat)
                let lon = placemark.location!.coordinate.longitude
                let transferLon = Double(lon)
                let coordinate = placemark.location!.coordinate
                
                
                var mapRegion = MKCoordinateRegion()
                mapRegion.center = coordinate
                mapRegion.span.latitudeDelta = 0.2
                mapRegion.span.longitudeDelta = 0.2
                
                self.addLocationMap.setRegion(mapRegion, animated: true)
                
                let name = placemark.name!
               // let country = placemark.country!
                let region = placemark.administrativeArea!
                
                let addedLocation = "\(name),\(region)" //\(country)
                print(addedLocation)
                
                
                let annotation = MKPointAnnotation() //creating/defining mapkit annotation
                annotation.coordinate = placemark.location!.coordinate
                

                
                let annotationDetail = "\(placemark.name!), \(placemark.administrativeArea!) \(placemark.country!)"
                annotation.title = annotationDetail
                self.addLocationMap.addAnnotation(annotation)
                self.UIChange()
                
                AddLocationClient.postStudentLocation(newLocation: addedLocation, newURL: self.URLText.text!, newLatitude: transferLat, newLongitude: transferLon, completion: self.handleGeoResponse(success: error:) )

            }
        })    }
    
    func UIChange() {
        
        addLocationMap.isHidden = false
        addButton.isHidden = false
        LocationText.isHidden = true
        URLText.isHidden = true
        FindButton.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { //creating pin Image
        let reuseIdentifier = "mapPin" // declaring reuse identifier
        
        var pinImage: MKPinAnnotationView? = nil
        pinImage = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        
        if pinImage == nil {
            pinImage = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinImage!.canShowCallout = true //making box appear when pin is tapped
            pinImage!.pinTintColor = .red //making the pin red
            //pinImage!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) //adding info button
        }
        else {
            pinImage!.annotation = annotation
        }
        
       // pinImage!.isSelected = true
        return pinImage //returning the pin image/view
    }
    
    
    @IBAction func addTapped(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil) //returns to map/table view

//        addButton.isHidden = true
//        addLocationMap.isHidden = true
//        LocationText.isHidden = false
//        URLText.isHidden = false
//        FindButton.isHidden = false
//
//        self.dismiss(animated: true, completion: nil)

    }
    
//    func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
//        let geocode = CLGeocoder()
//        if let data = data?[0] {
//
//        }
//    }
    
    func handleGeoResponse(success: Bool, error: Error?) {

    }
    

}
