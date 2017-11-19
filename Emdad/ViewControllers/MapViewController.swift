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
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var KCamera : GMSCameraPosition!
    var mapView: GMSMapView!
    var centerMapCoordinate:CLLocationCoordinate2D!
    var first = true
    private var clusterManager: GMUClusterManager!
    let kClusterItemCount = 10000
    
    //let regionRadius: CLLocationDistance = 1000
    var currentRequests : [Emdad_Request] = []
    var packageTypes : [Emdad_Package_Type] = []
    
    
    var temporaryMarker : GMSMarker?
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        addNewAnnotation()
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        updateRequests()
    }
    
    @IBOutlet weak var locationActionBar: UIView!
    @IBOutlet weak var  mapUIView : UIView!

    
    

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.first {
            self.first = false
            self.initiateMap()
        }
    }
    
    func initiateMap() {
        
        
        KCamera = GMSCameraPosition.camera(withLatitude: 37.86, longitude: 51.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: self.mapUIView.bounds, camera: KCamera)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        self.mapUIView.addSubview(mapView)
        //mapUIView = mapView
        
        updateRequests()
        setupClusterManager()
        
    
    }
    override func viewDidLoad() {
       
        
        self.navigationController?.navigationBar.tintColor = UIColor.green
        
        
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
                if temporaryMarker != nil {
                    let temporaryRequest = Emdad_Request(package_id: -1, lat: temporaryMarker!.position.latitude, long: temporaryMarker!.position.longitude, address: "", count: 0, deliver_to: "", title: "")
                    destination.currentReqeust = temporaryRequest
                }
                
                destination.delegate = self
            }
            
        }
        
        
    }
    
    
    
    
    func updateMap() {
        
        mapView.clear()
        for request in currentRequests {
            
           // self.mapView.addAnnotation(request)
            //let marker = GMSMarker()
            //marker.position = request.coordinate
            //marker.title = request.title
            
            //marker.iconView = getIconForRequestStatus(request.status)
            
            //marker.snippet =
            //marker.map = mapView
            let clusterItem = EmdadClusterableItem(position: request.coordinate, request: request)
            clusterManager.add(clusterItem)

        }
        
        
    }
    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        
        switch (sender.selectedSegmentIndex) {
        case 0:
            mapView.mapType = .normal
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
        }
        
    
        
    }
    
    func addNewAnnotation() {
        
        
        let marker = GMSMarker()
        marker.position = centerMapCoordinate
        
        marker.isDraggable = true
//        marker.map = mapView
        marker.iconView = getIconForRequestStatus("new")
        
        temporaryMarker = marker
        temporaryMarker?.map = mapView
        self.preparViewForAddingNew(active: true)
        
    }
    
    func preparViewForAddingNew(active: Bool) {
        
        

        self.navigationController?.setNavigationBarHidden(active, animated: true)
        
        if (active) {
            bottomConstraint.constant  = -100
            
        } else {
            
            
            bottomConstraint.constant = 0
            temporaryMarker?.map = nil
            temporaryMarker = nil
            
            
        }
        self.locationActionBar.isHidden = false
        
        self.view.layoutIfNeeded()
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomConstraint.constant = active ? 0 : -100
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.locationActionBar.isHidden = !active
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        temporaryMarker?.position = position.target
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
            submit_request(request!, completion: { (success, errorCode) in
                
                print("Submission success: \(success)")
                //TBD
            })
            
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

extension MapViewController :  GMUClusterManagerDelegate, GMUClusterRendererDelegate  {
    
    

    
    func setupClusterManager() {
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        
        renderer.delegate = self
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                           renderer: renderer)
        
        // Generate and add random items to the cluster manager.
        
        
        // Call cluster() after items have been added to perform the clustering
        // and rendering on map.
        clusterManager.cluster()
        
    }
    

    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        
        if marker.userData is EmdadClusterableItem{
            let user_data = marker.userData as! EmdadClusterableItem
            marker.iconView = getIconForRequestStatus(user_data.request.status)
            
            //marker.title = user_data.request.title
            //marker.snippet = user_data.request.address
            
            //marker.icon = UIImage(named: "locationicon")
        }
    }
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
    
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        
        if let infoBubbleVC = storyboard.instantiateViewController(withIdentifier: "infoBubble") as? InfoBubbleViewController{
            
            if marker.userData is EmdadClusterableItem{
                
                let user_data = marker.userData as! EmdadClusterableItem
                let request = user_data.request
                infoBubbleVC.request = request
                
                infoBubbleVC.typeString = " - "
                if (request?.package_id != nil) {
                    
                    if ( request!.package_id! > -1 && request!.package_id! < packageTypes.count) {
                        let targetPackageType = packageTypes[request?.package_id ?? 0]
                        infoBubbleVC.typeString = "\(targetPackageType.title ?? "")-\(targetPackageType.content_per_package ?? "")"
                        
                    }
                }
                
                
                let targetView = infoBubbleVC.view
                let frm = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.7, height: 300)
                
                targetView?.frame = frm
                targetView?.layoutIfNeeded()
                
                return targetView
            } else {
                
                print (marker.userData)
                
                
                return nil
            }
            
            
            
            
            
            
        }
        
        return nil
        
        
        
    }
    
}





