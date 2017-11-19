//
//  ClusterObject.swift
//  Emdad
//
//  Created by Behrad Bagheri on 11/18/17.
//  Copyright © 2017 BehradBagheri. All rights reserved.
//

import Foundation

class EmdadClusterableItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    var request : Emdad_Request!
    
    init(position: CLLocationCoordinate2D, request: Emdad_Request) {
        self.position = position
        self.name = ""
        self.request = request
    }
}
