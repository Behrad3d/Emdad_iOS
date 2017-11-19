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

var user_token = ""
//"014f65f019af17da82907df31cb0fdad0d0d93e95b27a54a862eea20988e1580" //Temporary

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

func submit_phone_number(_ phoneNumber: String, _ coordinates: CLLocationCoordinate2D, completion: @escaping (_ result: Bool, _ errorCode: Int? ) -> () ) {
    
    let requestBody: [String: Any] = ["mobile": phoneNumber,
                                      "lat" : coordinates.latitude,
                                      "long" : coordinates.longitude
                                    ]
    Alamofire.request("\(Server_URL)login", method: .post, parameters: requestBody).responseJSON { response in
        
        // Remove Request from Queue
        print("Validation Successful")
        var theJson = [String:Any]()
        if let json = response.result.value as? [String: Any] {
            print("JSON: \(json)") // serialized json response
            print(json["token"] ?? "-")
            theJson = json
        }
        
        
        switch response.result {
            case .success:
                
                if let token = theJson["token"] as? String {
                    user_token = token
                    
                    completion(true, nil)
                } else {
                    
                    completion(false, -103)
                }
            
            
            case .failure(let error):
                print(error)
                if let code = theJson["code"] as? Int {
                    completion(false,code)
                } else {
                    completion(false,-103)
                }
            
        }

    }
}

func confirm_code(_ code : String , completion: @escaping (_ result: Bool, _ errorCode: Int? ) -> ()) {
    
     let requestBody: [String: Any] = ["confirm_code": code,
                                       "token" : user_token]
    
    Alamofire.request("\(Server_URL)confirm", method: .post, parameters: requestBody).responseJSON { response in
        
        // Remove Request from Queue
        print("Code Validation Successful")
        var theJson = [String:Any]()
        if let json = response.result.value as? [String: Any] {
            print("JSON: \(json)") // serialized json response
            theJson = json
        }
        
        
        switch response.result {
        case .success:
            
            if let code = theJson["code"] as? Int {
                if (code == 200) {
                    saveToken(user_token)
                    completion(true, nil)
                } else {
                    completion(false,code)
                }
                
            } else {
                completion(false,-106)
            }
            
            
            
        case .failure(let error):
            print(error)
                completion(false,-106)
            
        }
        
    }
    
}

func submit_request(_ request: Emdad_Request, completion: @escaping (_ result: Bool, _ errorCode: Int? ) -> ()) {

    
    
    //add Request to Queue
    

    
    
    let requestBody: [String: Any] = ["token": user_token,
                                      "package_id": request.package_id!,
                                      "lat" : request.lat,
                                      "long": request.long,
                                      "address" : request.address ?? "",
                                      "count" : request.count ?? 1,
                                      "deliver_to" : request.deliver_to ?? "",
                                      "title" : request.title ?? "" ]
    
    
    
    
    Alamofire.request("\(Server_URL)add_request", method: .post, parameters: requestBody).responseJSON { response in
        switch response.result {
        case .success:
            
            // Remove Request from Queue
            print("Validation Successful")
            completion(true, nil)
        case .failure(let error):
            completion(false, 0)
            print(error)
        }
    }
        
    
    
}


func saveToken( _ token: String) {
    
    let defaults = UserDefaults.standard
    defaults.set(token, forKey: "emdad_token")
    
}

func loadToken() -> Bool {
    let defaults = UserDefaults.standard
    
    if let token = defaults.object(forKey: "emdad_token") as? String {
        user_token = token
        return true
    }
    
    return false
    
}
