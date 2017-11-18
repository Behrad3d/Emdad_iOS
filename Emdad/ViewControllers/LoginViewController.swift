//
//  ViewController.swift
//  Emdad
//
//  Created by Behrad Bagheri on 11/16/17.
//  Copyright © 2017 BehradBagheri. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var lblGuide: UILabel!
    @IBOutlet weak var txtPhonenumber: UITextField!
    
    @IBOutlet weak var prog: UIActivityIndicatorView!
    @IBOutlet weak var centerLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtActivationCode: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    
    var loginStep = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.hideKeyboardWhenTappedAround()
        setupUI()
        
        
    }
    func setupUI () {
        
        lblGuide.text = "لطفا برای ورود/ثبت نام شماره تماس خود را وارد نمایید."
        
    txtActivationCode.isHidden = true
    //prog.isHidden = true
    
    
    
        
    }
    
    
    //#=== Custom Functions
    
    func submitPhoneNumber() {
        prog.startAnimating()
        lblGuide.isHidden = true
        if (!validatePhoneNumber(txtPhonenumber.text)) {
            lblGuide.text = "شماره تلفن وارد شده صحیح نمی‌باشد"
            prog.stopAnimating()
            lblGuide.isHidden = false
            
        }

        txtPhonenumber.isEnabled = false
        txtActivationCode.isHidden = false
        
        prog.startAnimating()
        lblGuide.isHidden = true
        
    }
    
    func submitActivationCode() {
        
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
        
        if (keyboardShowing) {
            
            constraintValue = -150
            
        } else {
            
            constraintValue = 0
            
        }
        
        UIView.animate(withDuration: 1.0) {
            self.centerLayoutConstraint.constant = constraintValue
            self.view.layoutIfNeeded()
        }
        
        
        
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.containerView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
}
