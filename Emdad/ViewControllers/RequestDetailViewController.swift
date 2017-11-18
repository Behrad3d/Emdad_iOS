//
//  RequestDetailViewController.swift
//  Emdad
//
//  Created by Behrad Bagheri on 11/17/17.
//  Copyright © 2017 BehradBagheri. All rights reserved.
//

import UIKit

class RequestDetailViewController : UIViewController {
    
    var packageTypes : [Emdad_Package_Type] = []
    var currentReqeust : Emdad_Request?
    var delegate: ModalDelegate?
 
    
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtReceiver: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var stepperCount: UIStepper!
    
    @IBOutlet weak var OK_Button: UIButton!
    
    
     var completionHandler : ((Emdad_Request?) -> Void)?

    
    //==== IB Actions
    @IBAction func OkButtonClicked(_ sender: Any) {
        
        if let delegate = self.delegate {
            self.finalizeRequest()
            delegate.newRequest(request: currentReqeust)
        }
        self.dismiss(animated: true) 
        
        
    }
    
    
    @IBAction func CancelButtonClicked(_ sender: Any) {
        
        
        self.dismiss(animated: true)
        
        
    }
    
    
    
    
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        
        currentReqeust?.count =  Int(stepperCount.value)
        lblCount.text = "تعداد: \(currentReqeust?.count ?? 0 )"
    }
    
    
   //=== View Controller Functions
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        
        if currentReqeust == nil {
            currentReqeust = Emdad_Request(package_id: -1, lat: 0, long: 0, address: "", count: 0, deliver_to: "", title: "")
        }
        
    }
    //= Custom Functions
    
    func finalizeRequest() {
        
        currentReqeust?.title = txtTitle.text
        currentReqeust?.address = txtAddress.text
        currentReqeust?.deliver_to = txtReceiver.text
        
        print("This is our current request: \(currentReqeust!)")
    }
    
    
}


extension RequestDetailViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packageTypes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PackageTableViewCell
        
        cell.lblTitle.text = "\(packageTypes[indexPath.row].title ?? "")-\(packageTypes[indexPath.row].content_per_package ?? "")"
        cell.lblTitle.font = UIFont(name: "X_Yekan.ttf", size: 16)
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        currentReqeust?.package_id = indexPath.row
        
    }
    
}

extension RequestDetailViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func keyboardWillAppear() {
        //Do something here
        handleKeyboard(true)
    }
    
    @objc func keyboardWillDisappear() {
        handleKeyboard(false)
    }
    
    func handleKeyboard(_ keyboardShowing: Bool) {
        
        
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
}

