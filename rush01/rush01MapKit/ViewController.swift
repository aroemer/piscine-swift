//
//  ViewController.swift
//  rush01MapKit
//
//  Created by Audrey ROEMER on 4/7/18.
//  Copyright © 2018 Audrey ROEMER. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var searchLocationTextField: UITextField!
    @IBOutlet weak var sourceLocationTextField: UITextField!
    @IBOutlet weak var destinationLocationTextField: UITextField!
    @IBOutlet weak var MapSegmentedControl: UISegmentedControl!
    @IBOutlet weak var placeSearchErrorLabel: UILabel!
    @IBOutlet weak var sourceLocationErrorLabel: UILabel!
    @IBOutlet weak var destinationLocationErrorLabel: UILabel!
    @IBOutlet weak var distanceTimeLabel: UILabel!
    
    var currentCoordinate: CLLocationCoordinate2D!
    var locationManager = CLLocationManager()
    
    @IBAction func MapType(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            myMapView.mapType = .standard
        case 1:
            myMapView.mapType = .satellite
        default:
            myMapView.mapType = .hybrid
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //for the location search field
        if let search = searchLocationTextField.text {
            let searchRequest = MKLocalSearchRequest()
            searchRequest.naturalLanguageQuery = search
            let activeSearch = MKLocalSearch(request: searchRequest)
            activeSearch.start { (response, error) in
                //Remove annotations
                let annotations = self.myMapView.annotations
                self.myMapView.removeAnnotations(annotations)
                
                //Getting data
                guard let latitude =  response?.boundingRegion.center.latitude else { self.placeSearchErrorLabel.text = "Location not found" ; return }
                guard let longitude = response?.boundingRegion.center.longitude else { self.placeSearchErrorLabel.text = "Location not found" ; return }
                
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = search
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                annotation.coordinate = coordinate
                self.myMapView.addAnnotation(annotation)
                
                //Zooming in on annotation
                self.centerMapOnLocation(location: coordinate)
            }
            
        }
        //hide keyboard
        self.view.endEditing(true)
        return false
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius, regionRadius)
        myMapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func showLocation(_ sender: Any) {
        guard let locValue = locationManager.location?.coordinate else { self.sourceLocationErrorLabel.text = "Unknow geographic location" ;return}
            currentCoordinate = locValue
            centerMapOnLocation(location: locValue)
            self.sourceLocationErrorLabel.text = ""
            self.sourceLocationTextField.text = "My Location"
    }
    
    @IBAction func getDirections(_ sender: Any) {
        //Remove overlays
        let overlays = self.myMapView.overlays
        self.myMapView.removeOverlays(overlays)
        //Remove annotations
        let annotations = self.myMapView.annotations
        self.myMapView.removeAnnotations(annotations)
        
        let localSearchRequest = MKLocalSearchRequest()
        if destinationLocationTextField.text != nil && destinationLocationTextField.text != ""
        {
            localSearchRequest.naturalLanguageQuery = destinationLocationTextField.text
        }
        else
        {
            destinationLocationErrorLabel.text = "Please enter a destination"
        }
        if sourceLocationTextField.text == "My Location"
        {
            let sourcePlacemark = MKPlacemark(coordinate: currentCoordinate)
            let region = MKCoordinateRegion(center: currentCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            localSearchRequest.region = region
            let localSearch = MKLocalSearch(request: localSearchRequest)
            localSearch.start { (response, _) in
                guard let response = response else { self.destinationLocationErrorLabel.text = "Location not found"; return }
                guard let firstMapItem = response.mapItems.first else { self.destinationLocationErrorLabel.text = "Location not found"; return }
                self.drawDirections(from: sourceMapItem,to: firstMapItem)
            }
        }
        else
        {
            if let search = sourceLocationTextField.text {
                if search.isEmpty || search == ""
                {
                    sourceLocationErrorLabel.text = "Please enter a start location"
                    return
                }
                let searchRequest = MKLocalSearchRequest()
                searchRequest.naturalLanguageQuery = search
                let activeSearch = MKLocalSearch(request: searchRequest)
                activeSearch.start { (response, error) in

                    //Getting data
                    guard let latitude = response?.boundingRegion.center.latitude else { self.sourceLocationErrorLabel.text = "Location not found" ; return }
                    guard let longitude = response?.boundingRegion.center.longitude else { self.sourceLocationErrorLabel.text = "Location not found"; return }

                    let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                    let sourcePlacemark = MKPlacemark(coordinate: coordinate)
                    let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                    let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
                    localSearchRequest.region = region
                    let localSearch = MKLocalSearch(request: localSearchRequest)
                    localSearch.start { (response, _) in
                        guard let response = response else { self.destinationLocationErrorLabel.text = "Location not found"; return }
                        guard let firstMapItem = response.mapItems.first else { self.destinationLocationErrorLabel.text = "Location not found"; return  }
                        self.drawDirections(from: sourceMapItem,to: firstMapItem)
                    }
                }
            }
        }
    }
    
    func drawDirections(from source: MKMapItem, to destination: MKMapItem)
    {
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = source
        directionsRequest.destination = destination
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { (response, _) in
            guard let response = response else { self.distanceTimeLabel.text = "Sorry, could not find an itinerary"; return }
            guard let primaryRoute = response.routes.first else { self.distanceTimeLabel.text = "Sorry, could not find an itinerary"; return }
            let time = self.secondsToHoursMinutesSeconds(seconds: Int(primaryRoute.expectedTravelTime))
            self.distanceTimeLabel.text = "Distance: \(String(format: "%.2f", Double((primaryRoute.distance) / 1000))) km Time: \(time.0)h \(time.1)m \(time.2)s"
            self.myMapView.add(primaryRoute.polyline)
            self.myMapView.setVisibleMapRect(primaryRoute.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 45.0,left: 45.0,bottom: 45.0,right: 45.0), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = .orange
        renderer.lineWidth = 6
        return renderer
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        //reset error messages
        distanceTimeLabel.text = ""
        if textField.tag == 1
        {
            placeSearchErrorLabel.text = ""
        }
        if textField.tag == 2
        {
            sourceLocationErrorLabel.text = ""
            
        }
        if textField.tag == 3
        {
            destinationLocationErrorLabel.text = ""
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func setUpLocation()
    {
        myMapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        myMapView.showsUserLocation = true
        searchLocationTextField.delegate = self
        sourceLocationTextField.delegate = self
        destinationLocationTextField.delegate = self
        
    }
}
