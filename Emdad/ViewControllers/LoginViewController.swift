//
//  ViewController.swift
//  Emdad
//
//  Created by Behrad Bagheri on 11/16/17.
//  Copyright © 2017 BehradBagheri. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var lblGuide: UILabel!
    @IBOutlet weak var txtPhonenumber: UITextField!
    
    @IBOutlet weak var prog: UIActivityIndicatorView!
    @IBOutlet weak var centerLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnLoginConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtActivationCode: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    let locationManager = CLLocationManager()
    var loginStep = 0
    var currentLocation : CLLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        checkLocationAuthorizationStatus()
        locationManager.delegate = self
        
        setupInitialUI(nil)
       
        checkForLogin()
        
    }
    
    
    func checkForLogin() {
        
        if (loadToken()) {
            
            self.performSegue(withIdentifier: "showView", sender: nil)
            
        }
        
    }
    
    // Location Stufff
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //mapView.showsUserLocation = true
            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last
   //     self.locationManager.stopUpdatingLocation()
        
    }
    
    
    
    // UI Stuff
    func setupInitialUI (_ message: String? ) {
        
        lblGuide.text = message ?? "لطفا برای ورود/ثبت نام شماره تماس خود را وارد نمایید."
        lblGuide.isHidden = false
        
        txtActivationCode.isHidden = true
        prog.stopAnimating()
        btnCancel.isHidden = true
        btnCancel.alpha = 0
        txtActivationCode.text = ""
        txtPhonenumber.alpha = 1
        txtPhonenumber.isEnabled = true
        
    }
    
    func prepareViewForCode(_ message: String?) {
        // After finish
        loginStep = 1
        btnCancel.isHidden = false
        txtPhonenumber.isEnabled = false
        txtActivationCode.isHidden = false
        txtActivationCode.becomeFirstResponder()
        
        prog.stopAnimating()
        
        UIView.animate(withDuration: 0.5) {
            self.lblGuide.isHidden = false
            self.lblGuide.text = message ?? "لطفا کد دریافت شده در پیامک را وارد نمایید"
            self.txtPhonenumber.alpha = 0.5
            self.txtActivationCode.alpha = 1
        }
        
        
    }
    
    
    //#=== Custom Functions
    
    func submitPhoneNumber() {
        prog.startAnimating()
        lblGuide.isHidden = true
        if (!validatePhoneNumber(txtPhonenumber.text)) {
            setupInitialUI("شماره تلفن وارد شده صحیح نمی‌باشد")
            return
        }
        
        
        var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        if (currentLocation != nil) {
           coordinate = currentLocation!.coordinate
        }
        
        submit_phone_number(txtPhonenumber.text!, coordinate) { (success, errorCode) in
            
            if (success) {
                
                self.prog.startAnimating()
                self.lblGuide.isHidden = true
                
                self.prepareViewForCode(nil)
                
            } else {
                
                switch (errorCode!) {
                case -100:
                    self.setupInitialUI("شمارد موبایل وارد شدد فرمت صحیح ندارد")
                    break;
                case -101,-102:
                    self.setupInitialUI("موقعیت کاربر مشخص نیست. لطفا Location Service را فعال کنید")
                    break;
                case -100:
                    self.setupInitialUI("خطای ارتباط با سرور")
                    break;
                    
                default:
                    break;
                }
                
            }
            

        }
        
        
        
    }
    

    func submitActivationCode() {
        prog.startAnimating()
        lblGuide.isHidden = true
        if (!validateConfirmationCode(txtActivationCode.text)) {
            prepareViewForCode("کد فعال سازی باید ۴ رقم باشد")
            return
        }
        
        
        confirm_code(txtActivationCode.text!) { (success, errorCode) in
            
            if (success) {
                
                self.performSegue(withIdentifier: "showView", sender: nil)
                
            } else {
                
                switch (errorCode!) {
                case -103:
                    self.prepareViewForCode("ساختار کد تایید اشتباه است")
                    break;
                case -104:
                    self.prepareViewForCode("توکن ارسال شده اشتباه است")
                    break;
                case -105:
                    self.prepareViewForCode("کد وارد شده اشتباه است")
                    break;
                case -106:
                    self.prepareViewForCode("خطای ارتباط با سرور")
                    break;
                    
                default:
                    break;
                }
            }
            
            
        }
        
        
    }
    
    
    @IBAction func CancelClicked(_ sender: Any) {
        
        setupInitialUI(nil)
        
    }
    
    @IBAction func LoginAction(_ sender: Any) {
        
        switch loginStep {
        case 0:
            
            submitPhoneNumber()
            
            break
        case 1:
            
            submitActivationCode()
            
            break
            
        default:
            print("We should have not got here! ")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//Handling Keybaord Stuff
extension LoginViewController {
    
    
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
        
        var constraintValue : CGFloat = 0
        var btnLoginConstraintValue : CGFloat = 0
        if (keyboardShowing) {
            
            constraintValue = -100
            btnLoginConstraintValue = 10
            
        } else {
            
            constraintValue = 0
            btnLoginConstraintValue = 60
            
        }
        
        UIView.animate(withDuration: 1.0) {
            self.centerLayoutConstraint.constant = constraintValue
            self.btnLoginConstraint.constant = btnLoginConstraintValue
            self.view.layoutIfNeeded()
        }
        
        
        
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        //tap.cancelsTouchesInView = false
        self.containerView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
}
