//
//  ViewController.swift
//  PinCodeTextField
//
//  Created by Alexander Tkachenko on 3/15/17.
//  Copyright © 2017 organization. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PinCodeTextFieldDelegate {

    @IBOutlet weak var pinCodeTextField: PinCodeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinCodeTextField.delegate = self
    }

    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
        
    }
    
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    

}

