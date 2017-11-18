//
//  EmdadBackend.swift
//  Emdad
//
//  Created by Behrad Bagheri on 11/16/17.
//  Copyright © 2017 BehradBagheri. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

let Server_URL = "https://emdad.upsym.com/api/"

var user_token = "014f65f019af17da82907df31cb0fdad0d0d93e95b27a54a862eea20988e1580" //Temporary

func get_all_requests( completion: @escaping (_ result: Bool, _ errorCode: Int?, _ packageTypes: [Emdad_Package_Type]?, _ requested: [Emdad_Request]?)->()) {
    
    let requestBody: [String: Any] = ["token": user_token]
    
    Alamofire.request("\(Server_URL)get_requests", method: .post, parameters: requestBody).responseObject { (response: DataResponse<Emdad_Reuqest_Response>) in
        
        let emdadResponse = response.result.value
        print("Requests loaded with code: \(emdadResponse?.code ?? -1)")
    
        if emdadResponse == nil {
            completion(false, -1, nil, nil)
        } else {
            
            switch (emdadResponse!.code!) {
            case 200:
                completion(true,200,emdadResponse?.packageTypes, emdadResponse?.current_Emdad_Requests)
                break
            default:
                completion(false, emdadResponse?.code, nil, nil)
            }
            
        }
        
    }
}

func submit_phone_number(_ phoneNumber: String, completion: @escaping (_ result: Bool, _ errorCode: Int? ) -> () ) {
    
    // TBC
    
    
    completion(true, nil)
}

