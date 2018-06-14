//
//  MapViewController.swift
//  d05
//
//  Created by Audrey ROEMER on 4/2/18.
//  Copyright © 2018 Audrey ROEMER. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var MapSegmentedControl: UISegmentedControl!
    
    var locationManager = CLLocationManager()
    
    
    @IBAction func MapType(_ sender: UISegmentedControl!) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            MapView.mapType = .standard
        case 1:
            MapView.mapType = .satellite
        default:
            MapView.mapType = .hybrid
        }
    }
    @IBAction func showLocation(_ sender: UIButton) {
        if let locValue = locationManager.location?.coordinate {
        centerMapOnLocation(location: locValue)
        }
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius, regionRadius)
        MapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView.canShowCallout = true
        pinView.pinTintColor = (annotation as! ColorPointAnnotation).color
        return pinView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        
       
        let annotations = Place.places.map { location -> MKAnnotation in
            let annotation = ColorPointAnnotation()
            annotation.title = location.locationName
            annotation.subtitle = location.locationDesc
            annotation.coordinate = location.coordinate
            annotation.color = location.color
            return annotation
        }
        MapView.addAnnotations(annotations)
        MapView.showsUserLocation = true
        let school = Place.places.first(where: { $0.locationName == "42" })
        let initialLocation = school?.coordinate
        centerMapOnLocation(location: initialLocation!)
        

        

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

