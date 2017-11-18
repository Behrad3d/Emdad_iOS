//
//  Emdad_Helper_Module.swift
//  Emdad
//
//  Created by Behrad Bagheri on 11/18/17.
//  Copyright © 2017 BehradBagheri. All rights reserved.
//

import Foundation
import UIKit

func getIconForRequestStatus (_ status: String) -> UIImageView {
    let imageName = "locationIcon"
    var tintColor = UIColor.orange
    
    switch status {
    case "waiting":
        tintColor = .red
        break
    case "delivered":
        tintColor = .green
        break
    case "on_the_way":
        tintColor = .green
        break
    case "new":
        tintColor = .gray
        break
    default:
        tintColor = .orange
        
        
    }
    
    
    let icon =  UIImage(named: imageName)
    let markerView = UIImageView(image: icon)
    markerView.tintColor = tintColor
    
    return markerView
}



func validatePhoneNumber(_ inputNumber: String?) -> Bool {
    
    //TBD
    return true
    
}

