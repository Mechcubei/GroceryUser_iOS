//
//  LoginVC.swift
//  GroceryUser
//
//  Created by osx on 21/07/20.
//  Copyright © 2020 osx. All rights reserved.

import UIKit
import CountryPickerView

@available(iOS 13.0, *)
class LoginVC: UIViewController,CountryPickerViewDelegate, CountryPickerViewDataSource {
    //MARK:- OUTLETS
   
    //MARK:- OUTLETS
    @IBOutlet var txtPhoneNumber: UITextField!
    @IBOutlet var countryPickerView: CountryPickerView!
    
    //MARK:- LOCAL VARIABLES
    var countryPickView = CountryPickerView()
    var countryCode = ""
    
    //MARK:- Life cycle methods
     override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCountryCode()
        
    }
    //MARK:- SETUP COUNTRY CODE UI
    func setUpCountryCode() {
        
        let country = countryPickView.selectedCountry.phoneCode
        print(country)
        countryCode = country
        countryPickerView.showCountryCodeInView = false
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        countryPickerView.textColor = .black
        //countryPickerView.font = UIFont(name: "Roboto-Bold", size: 14.0)
        
    }
    
    //MARK:- SEND OTP API
    func sendOtp() {
        if let number = txtPhoneNumber.text {
            if number == ""{
                Utilities.shared.showAlertWithOK(title: "", msg: "Please enter your phone number")
                return
            }
            if number.count == 10 {
                let newString = countryCode.replacingOccurrences(of: "+", with: "", options: .literal, range: nil)
                let params:[String:Any] = ["phone_number":txtPhoneNumber.text!,"user_role":"User","country_code":newString]
                GetApiResponse.shared.sendOtp(params: params) { (data: LoginStruct) in
                    print(data)
                    
                    UserDefaults.standard.set(data.data?.token, forKey: "token")
                    
                    if data.statusCode == 200 {
                        let vc = ENUM_STORYBOARD<OtpVerificationVC>.login.instantiativeVC()
                        vc.phoneNumber = self.txtPhoneNumber.text
                        vc.countryCode = newString
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    } else {
                        print(data.message!)
                    }
                }
                 
            } else {
                Utilities.shared.showAlertWithOK(title: "", msg: "Please enter correct phone number")
            }
        }
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
           print(country.phoneCode)
           countryCode = country.phoneCode
    }
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnLogin(_ sender: Any) {
        self.sendOtp()
    }
    
}
