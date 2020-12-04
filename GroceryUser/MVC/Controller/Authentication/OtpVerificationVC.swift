//
//  OtpVerificationVC.swift
//  GroceryUser
//
//  Created by osx on 21/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import MKOtpView

@available(iOS 13.0, *)
class OtpVerificationVC: UIViewController {

    
    //MARK:- OUTLETS
    @IBOutlet var viewOTP: MKOtpView!
    @IBOutlet var lblPhoneNumber: UILabel!
    @IBOutlet var lblOtpSec: UILabel!
    
    var phoneNumber:String?
    var userOtp:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpOTP()
        
        self.lblPhoneNumber.text = phoneNumber
        
    }
    
    //MARK:- VERIFY-OTP API
    func verifyOtp() {
        
        let params:[String:Any] = ["phone_number":phoneNumber!,"user_role":"User","country_code":"91","user_otp":userOtp!]
        GetApiResponse.shared.verifyOtp(params: params) { (data: LoginStruct) in
            print(data)
            
            if data.statusCode == 200 {
                 UserDefaults.standard.set(data.data?.token, forKey: "token")
                
                self.getprofile()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    //MARK:- GET PROFILE API
    
    func getprofile() {
        
        Loader.shared.showLoader()
        let params:[String:Any] = ["user_type":"User"]
        GetApiResponse.shared.getProfile(params: params) { (data: LoginStruct) in
            print(data)
            Loader.shared.stopLoader()
            
            if data.statusCode == 200 {
                if data.data?.first_name != "" && data.data?.last_name != "" {
                    let vc = ENUM_STORYBOARD<TabbarVC>.tabbar.instantiativeVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    let vc = ENUM_STORYBOARD<SignUpVC>.login.instantiativeVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    //MARK:- SET UP OTP
    func setUpOTP() {
        
        viewOTP.setVerticalPedding(pedding: 3)
        viewOTP.setHorizontalPedding(pedding: 20)
        viewOTP.setNumberOfDigits(numberOfDigits: 5)
        viewOTP.setBorderWidth(borderWidth: 1.0)
        viewOTP.setBorderColor(borderColor: ENUMCOLOUR.themeColour.getColour())
        viewOTP.setCornerRadius(radius: 2)
        viewOTP.setInputBackgroundColor(inputBackgroundColor: UIColor.white)
        viewOTP.enableSecureEntries()
        self.view.addSubview(viewOTP)
        
        viewOTP.onFillDigits = { number in
        print("input number is \(number)")
            self.userOtp = number
            
        }
        viewOTP.render()
    }
    
    //MARK:- ACTION BUTTON
    @IBAction func btnResendOtp(_ sender: Any) {
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnContinue(_ sender: Any) {
        self.verifyOtp()
    }
    
}
