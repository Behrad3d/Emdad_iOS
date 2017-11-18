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
    
    var loginStep = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
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
        
        if (!validatePhoneNumber(txtPhonenumber.text)) {
            lblGuide.text = "شماره تلفن وارد شده صحیح نمی‌باشد"
            prog.stopAnimating()
        }

    }
    
    func submitActivationCode() {
    
    }
    
    func handleKeyboard(keyboardShowing: Bool) {
        
        var constraintValue = 0
        
        if (keyboardShowing) {
            
            constraintValue = 200
            
        } else {
            
            constraintValue = 0
            
        }
        
        
        
        
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

