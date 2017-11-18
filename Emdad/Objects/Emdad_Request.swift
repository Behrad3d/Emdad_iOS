//
//  Emdad_Request.swift
//  Emdad
//
//  Created by Behrad Bagheri on 11/16/17.
//  Copyright © 2017 BehradBagheri. All rights reserved.
//

import Foundation
import ObjectMapper
import MapKit

class Emdad_Reuqest_Response : NSObject, Mappable {
    
    var code : Int?
    var message : String?
    var packageTypes : [Emdad_Package_Type] = []
    var current_Emdad_Requests : [Emdad_Request] = []
    
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        
        self.code <- map["code"]
        self.message <- map["message"]
        self.packageTypes <- map["package_type"]
        self.current_Emdad_Requests <- map["requested"]
        
    }
    
}

class Emdad_Package_Type : NSObject, Mappable  {
    
    var id: Int?
    var title : String?
    var content_per_package : String?
    var created_at : Float? = 0
    
    
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        
        self.id <- map["id"]
        self.title <- map["title"]
        self.content_per_package <- map["content_per_package"]
        self.created_at <- map["created_at"]
        

    }
    
}

class Emdad_Request : NSObject, Mappable, MKAnnotation {
    
    
    
    required init?(map: Map) { }
    
    
    var package_id : Int?
    var lat : Double = 0
    var long : Double = 0
    var address : String?
    var count : Int?
    var deliver_to : String?
    var title : String?
    var status : String = ""
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
    }
    
    init(package_id: Int,lat: Double, long:Double, address: String, count: Int, deliver_to: String? , title : String?) {

        self.package_id = package_id
        self.lat = lat
        self.long = long
        self.address = address
        self.count = count
        self.deliver_to = deliver_to
        self.title = title
        super.init()

    }
    
    func mapping(map: Map) {
        self.package_id <- map["package_id"]
        self.lat <- map["latitude"]
        self.long <- map["longitude"]
        self.address <- map["address"]
        self.count <- map["count"]
        self.deliver_to <- map["deliver_to"]
        self.title <- map["title"]
        self.status <- map["status"]
    }
    
    
    required init(coder aDecoder: NSCoder!) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
