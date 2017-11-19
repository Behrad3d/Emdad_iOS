//
//  InfoBubbleViewController.swift
//  Emdad
//
//  Created by Behrad Bagheri on 11/18/17.
//  Copyright © 2017 BehradBagheri. All rights reserved.
//

import Foundation

class InfoBubbleViewController : UIViewController {
    
    @IBOutlet weak var theInfoView: infoView!
    
    
    var request : Emdad_Request?
    var typeString : String?
    
    override func viewDidLayoutSubviews() {
        setupUI()
    }
    
    func setupUI() {
        
        theInfoView.request = request
        theInfoView.requestTypeString = typeString
        theInfoView.setup()
        
    }
}

class infoView : UIView {
    
    var request : Emdad_Request?
    var requestTypeString : String?
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblType: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblCount: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var lblUpdate: UILabel!
    func setup() {
        lblTitle.text = request?.title ?? " - "
        lblType.text = requestTypeString ?? " - "
        lblAddress.text = request?.address ?? " - "
        lblCount.text = "\(request?.count ?? 0)"
        lblStatus.text = getProperTextForStatus(request?.status ?? " - ")
        let updatetime = Date(timeIntervalSince1970: request?.updateTime ?? 0 )
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        lblUpdate.text = formatter.string(from: updatetime)
        
    }
}
