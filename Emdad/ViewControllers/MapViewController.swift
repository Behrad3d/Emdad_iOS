//
//  MapViewController.swift
//  Emdad
//
//  Created by Behrad Bagheri on 11/18/17.
//  Copyright © 2017 BehradBagheri. All rights reserved.
//

//
//  MapViewController.swift
//  Emdad
//
//  Created by Behrad Bagheri on 11/16/17.
//  Copyright © 2017 BehradBagheri. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

protocol ModalDelegate {
    func newRequest(request: Emdad_Request?)
}

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    
    var mapView: GMSMapView!
    var centerMapCoordinate:CLLocationCoordinate2D!
    var first = true
    
    //let regionRadius: CLLocationDistance = 1000
    var currentRequests : [Emdad_Request] = []
    var packageTypes : [Emdad_Package_Type] = []
    
    let locationManager = CLLocationManager()
    var temporaryMarker : GMSMarker?
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        addNewAnnotation()
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        updateRequests()
    }
    
    @IBOutlet weak var locationActionBar: UIView!
    @IBOutlet weak var  mapUIView : UIView!

    
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.first {
            self.first = false
            self.initiateMap()
        }
    }
    
    func initiateMap() {
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.86, longitude: 51.20, zoom: 3.0)
        mapView = GMSMapView.map(withFrame: self.mapUIView.bounds, camera: camera)
        mapView.delegate = self
        self.mapUIView.addSubview(mapView)
        //mapUIView = mapView
        
        updateRequests()
        
    
    }
    override func viewDidLoad() {
       
        
        
        registerAnnotationViewClasses()
        
    }
    
    func updateRequests() {
        get_all_requests { (success, errorCode, packageTypes, requests) in
            
            if (success) {
                
                self.packageTypes = packageTypes == nil ? [] : packageTypes!
                self.currentRequests = requests == nil ? [] : requests!
                self.updateMap()
                
            }
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "addNewRequest") {
            if let destination = segue.destination as? RequestDetailViewController {
                destination.packageTypes = self.packageTypes
                destination.delegate = self
            }
            
        }
        
        
    }
    
    
    func updateMap() {
        
        mapView.clear()
        for request in currentRequests {
            
           // self.mapView.addAnnotation(request)
            let marker = GMSMarker()
            marker.position = request.coordinate
            marker.title = request.title
            
            marker.iconView = getIconForRequestStatus(request.status)
            
            //marker.snippet =
            marker.map = mapView

        }
        
        
    }
    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        
        
        
    }
    
    func addNewAnnotation() {
        
        
        let marker = GMSMarker()
        marker.position = centerMapCoordinate
        
        marker.isDraggable = true
        marker.map = mapView
        marker.iconView = getIconForRequestStatus("new")
        
        temporaryMarker = marker
        self.preparViewForAddingNew(active: true)
        
    }
    
    func preparViewForAddingNew(active: Bool) {
        
        locationActionBar.isHidden = !active
        
        if (active) {
            
        } else {
            
            //temporaryMarker?.map = nil
            temporaryMarker = nil
            
        }
        
    }
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    

    
    
    
    
    func centerMapOnLocation(location: CLLocation) {
       // let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,                                                                  regionRadius, regionRadius)
        //mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func registerAnnotationViewClasses() {
        //mapView.register(BikeView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        //     /   mapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    
    
}

extension MapViewController : ModalDelegate {
    
    func newRequest(request: Emdad_Request?) {

        //sendRequest()
        self.preparViewForAddingNew(active: false)
        
        if (request == nil) {
            
            // we don't do anything.
            
        } else {
            
            // we submit the location details
            self.currentRequests.append(request!)
            self.updateMap()
        }
        
        
    }
    
    @IBAction func clocseAddLocation(_ sender: NSObject) {
        self.preparViewForAddingNew(active: false)
    }
    
    @IBAction func acceptLocation(_ sender: NSObject) {
        
       self.performSegue(withIdentifier: "addNewRequest", sender: nil)
    }
    
    
}




