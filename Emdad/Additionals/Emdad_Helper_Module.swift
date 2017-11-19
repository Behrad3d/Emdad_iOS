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

func getProperTextForStatus(_ status : String) -> String {
    switch status {
    case "waiting":
        return "در حال انتظار..."
        
    case "delivered":
        return "دریافت شده"
        
    case "on_the_way":
        return "ارسال شده"
        
    case "new":
        return "جدید"
        
    default:
        return "نا مشخص"
        
    }
    
}



func validatePhoneNumber(_ inputNumber: String?) -> Bool {
    
    if (inputNumber == nil) { return false }
    
    if (inputNumber!.count < 11) { return false}
    
    if (inputNumber!.count > 13) { return false}
    
    if (inputNumber!.count > 11) {
        let index = inputNumber!.index(inputNumber!.startIndex, offsetBy: 0)
        let startingCharacter = inputNumber![index]
        if (startingCharacter != "+") { return false}
    }
    if (inputNumber!.count == 11) {
        
        let index1 = inputNumber!.index(inputNumber!.startIndex, offsetBy: 0)
        let startingCharacter = inputNumber![index1]
        let index2 = inputNumber!.index(inputNumber!.startIndex, offsetBy: 1)
        let startingCharacter2 = inputNumber![index2]
        
        if (startingCharacter != "0" || startingCharacter2 != "9") {
            return false
            
        }
    }
    
    return true
    
}

func validateConfirmationCode(_ confirmCode: String?) -> Bool {
    
    if (confirmCode == nil) { return false}
    
    if (confirmCode!.count != 4) { return false }
    
    
    return true
}


