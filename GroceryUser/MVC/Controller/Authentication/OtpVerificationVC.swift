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
    @IBOutlet var btnResendOtp: UIButton!
    
    var phoneNumber:String?
    var userOtp:Int?
    var countryCode:String?
    var timer = Timer()
    var totalSecond = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpOTP()

        self.lblPhoneNumber.text = "+\(String(describing: countryCode!))" + " " + "\(String(describing: phoneNumber!))"
        self.checkOtpStatus()
    }
    
    //MARK:- VERIFY-OTP API
    func verifyOtp() {
        
        let params:[String:Any] = ["phone_number":phoneNumber!,"user_role":"User","country_code":countryCode!,"user_otp":userOtp!]
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
        let params:[String:Any] = ["role":"User"]
        GetApiResponse.shared.getProfile(params: params) { (data: EditProfileStruct) in
            print(data)
            Loader.shared.stopLoader()
            
            if data.statusCode == 200 {
                if data.data.first_name != "" && data.data.last_name != "" {
                    let vc = ENUM_STORYBOARD<TabbarVC>.tabbar.instantiativeVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.timer.invalidate()
                    
                } else {
                    let vc = ENUM_STORYBOARD<SignUpVC>.login.instantiativeVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.timer.invalidate()
                }
            }
        }
    }
    
    func expireOTP(){
        
        let params:[String:Any] = ["verification_type":"phone","phone_number":phoneNumber!,"country_code":countryCode!,"user_role":"User"]
    
        GetApiResponse.shared.expiredOtp(params: params) { (data:RegisterStruct) in
            print(data)
            guard data.statusCode == 200 else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
                return
            }
            Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
        }
    }
    
    // MARK:- SEND OTP API's
    func sendOtp() {
        let params:[String:Any] = ["phone_number": phoneNumber! ,
                                   "user_role":"User",
                                   "country_code":countryCode!
        ]
        GetApiResponse.shared.sendOtp(params: params) { (data: LoginStruct) in
            print(data)
            guard  data.statusCode == 200 else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
                return
            }
            Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
            self.checkOtpStatus()
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
    
  //MARK:- Otp resend methods
  func checkOtpStatus(){
      DispatchQueue.main.async {
          self.timer =   Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector( self.updateTimee), userInfo: nil, repeats: true)
      }
  }
  
  @objc func updateTimee() {
      if totalSecond > 0 {
          totalSecond -= 1
          self.lblOtpSec.text = "OTP Valid for: 0:\(totalSecond)"
          self.btnResendOtp.isHidden = true
      }else if totalSecond == 0 {
          
          btnResendOtp.isHidden = false
          totalSecond = 30
          timer.invalidate()
          self.expireOTP()
      }
  }
    
    //MARK:- ACTION BUTTON
    @IBAction func btnResendOtp(_ sender: Any) {
        self.sendOtp()
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnContinue(_ sender: Any) {
        if userOtp == nil {
            Utilities.shared.showAlertWithOK(title: "ALERT!", msg: "Please enter Otp to continue")
        } else {
            self.verifyOtp()
        }
        
        
    }
    
}
