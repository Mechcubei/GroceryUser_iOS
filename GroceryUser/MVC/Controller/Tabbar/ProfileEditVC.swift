//
//  ProfileEditVC.swift
//  GroceryUser
//
//  Created by osx on 29/09/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON
import SDWebImage
import GooglePlaces
import CoreLocation
import MKOtpView

@available(iOS 13.0, *)
class ProfileEditVC: UIViewController,ImagePickerDelegate {
    
    //MARK:- OUTLETS
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var txtFirstname: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPhoneNo: UITextField!
    @IBOutlet var txtAddress: UITextField!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var btnSelectImage: UIButton!
    @IBOutlet var imgEmail: UIImageView!
    @IBOutlet var imgPhoneNo: UIImageView!
    @IBOutlet var btnEmail: UIButton!
    @IBOutlet var btnPhoneNo: UIButton!
    @IBOutlet var viewHidden: UIView!
    @IBOutlet var viewOtp: MKOtpView!
    @IBOutlet var viewOuterOtp: UIView!
    @IBOutlet var lblOtpTimmer: UILabel!
    @IBOutlet var btnResendOtp: UIButton!
    
    //MARK:- LOCAL VARIABLES
    var imagePicker: ImagePicker!
    var userOtp:Int?
    var iD = Int()
    var countryCode = Int()
    var isCommingFrom = ""
    var timer = Timer()
    var totalSecond = 60
    var isCommingForProfile:Bool = false
    var currentEmail = String()
    var phoneNumber = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getUserProfile()
        self.extraCall()
        
    }
    //MARK:- EXTRA CALL FUNCTIONS
    func extraCall() {
        
        self.imgProfile.cornerRadius = imgProfile.frame.size.width/2
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.tabBarController?.tabBar.isHidden = true
        
        //TAP GESTURE
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideViewOnTap(_sender:)))
        viewHidden.addGestureRecognizer(tapGesture)
        
    }
    
    //MARK:- HIDE VIEW ON TAP
    @objc func hideViewOnTap(_sender:UITapGestureRecognizer) {
        self.viewHidden.isHidden = true
    }
    
    //MARK:- SETUP UI
    func setUpUI(firstName:String?,lastname:String,email:String,phoneNumber:Int,address:String,proImage:String) {
        
        self.txtFirstname.text = firstName
        self.txtLastName.text = lastname
        self.txtEmail.text = email
        self.txtPhoneNo.text = "\(phoneNumber)"
        self.txtAddress.text = address
        self.lblName.text = firstName! + " " + lastname
        self.imgProfile.sd_setImage(with: URL(string: proImage), placeholderImage: UIImage(named: "Profile-icon"))
    }
    
    //MARK:- GET USER PROFILE API
    func getUserProfile() {
        
        Loader.shared.showLoader()
        let params:[String:Any] = ["role":"User"]
        GetApiResponse.shared.getUserProfile(params: params) { (data:GetUserProfileStruct) in
            print(data)
            Loader.shared.stopLoader()
            
            guard data.statusCode == 200 else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
                return
            }
            
            self.setUpUI(firstName: data.data.first_name ?? "", lastname: data.data.last_name ?? "", email: data.data.email ?? "", phoneNumber: data.data.phone!, address: data.data.address ?? "", proImage: data.data.image!)
            self.countryCode = data.data.country_code!
            
            self.currentEmail = data.data.email!
            self.phoneNumber = "\(data.data.phone!)"
            
            self.btnEmail.setTitle(data.data.email_status! == 1 ?  "Update?" : "Add New", for: .normal)
            self.imgEmail.isHidden = data.data.email_status! == 1 ? false : true
            
            if data.data.phone_status! == 1 {
                self.btnPhoneNo.setTitle("Update?", for: .normal)
                self.imgPhoneNo.isHidden = false
            }
        }
    }
    
    //MARK:- VERIFICATION EMAIL AND PHONE NUMBER API
    func getVerificationEmailPhoneNo(verificationType:String) {
        
        var params = [String:Any]()
        
        params = isCommingFrom == "Email" ? ["email":txtEmail.text ?? "","verification_type":verificationType]:
            ["country_code": countryCode,"phone":txtPhoneNo.text ?? "","verification_type":verificationType]
        
        Loader.shared.showLoader()
        GetApiResponse.shared.getVerificationEmailPhoneNo(params: params) { (data:RegisterStruct) in
            print(data)
            Loader.shared.stopLoader()
            guard data.statusCode == 200 else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
                return
            }
            self.checkOtpStatus()
            self.iD = (data.data?.id)!
            self.viewHidden.isHidden = false
            self.setUpOTP()
        }
    }
    
    //MARK:- VERIFIED OTP API
    func verifiedOTP() {
        
        var params = [String:Any]()
        
        params = isCommingFrom == "Email" ? ["id":iD,"otp":userOtp!,"verification_type":"Email","email":txtEmail.text ?? ""]:
            ["id":iD,"otp":userOtp!,"verification_type":"phone","phone":txtPhoneNo.text ?? ""]
        
        Loader.shared.showLoader()
        GetApiResponse.shared.veriFiedOtp(params: params) { (data:VerifiedOtpStruct) in
            Loader.shared.stopLoader()
            print(data)
            guard data.statusCode == 200 else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
                return
            }
            self.viewHidden.isHidden = true
            self.imgEmail.isHidden = false
            self.btnEmail.setTitle("Update?", for: .normal)
            self.timer.invalidate()
        }
    }
    
    //MARK:- EDIT USER API
    func editUser() {
        
        var parameters = [String:Any]()
        parameters = [
            "first_name":txtFirstname.text ?? "",
            "last_name":txtLastName.text ?? "",
            "address":txtAddress.text ?? "",
            "fcm_token":UserDefaults.standard.string(forKey: "FCMToken")!
        ]
        
        let headers:[String:String] = [
            "Authorization": createHeaders()
        ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            // for single image
            let imageData = self.imgProfile.image!.jpegData(compressionQuality: 0.6)
            multipartFormData.append(imageData!, withName: "image", fileName: "file.png", mimeType: "image/png")
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        },usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
          
          to: "http://134.209.157.211/Carrykoro/public/api/edit_user",
          method: .post,
          headers: headers
            )
            
        { (result) in
            switch result {
                
            case .success(let upload, _,_ ):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                Loader.shared.showLoader()
                upload.responseJSON { response in
                    Loader.shared.stopLoader()
                    print(response)
                    
                    let respData =    response.result.value
                    let data = respData  as! [String:Any]
                    let status =    data["statusCode"] as! Int
                    let message =   data["message"] as! String
                    
                    guard status == 200 else {
                        Utilities.shared.showAlertWithOK(title: "", msg: message)
                        return
                    }
                    guard self.isCommingForProfile == false else {
                        self.navigationController?.popViewController(animated: true)
                        return
                    }
                    let dashboardVC = self.navigationController!.viewControllers.filter { $0 is MyAccountVC }.first!
                    self.navigationController!.popToViewController(dashboardVC, animated: true)
                }
                
            case .failure(let encodingError):
                print(encodingError)
                
            }
        }
    }
    
    //MARK:- EXPIRE OTP API
    func expireOTP(){
        
        var params = [String:Any]()
        params = isCommingFrom == "Email" ?
            ["verification_type":"email","email":currentEmail,"user_role":"Merchant"]:
            ["verification_type":"phone","phone_number":txtPhoneNo.text ?? "","country_code":"91","user_role":"Merchant"]
        
        GetApiResponse.shared.expiredOtp(params: params) { (data:RegisterStruct) in
            print(data)
            guard data.statusCode == 200 else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
                return
            }
            Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
        }
    }
    
    //MARK:- SET UP OTP
    func setUpOTP() {
        
        viewOtp.setVerticalPedding(pedding: 3)
        viewOtp.setHorizontalPedding(pedding: 20)
        viewOtp.setNumberOfDigits(numberOfDigits: 5)
        viewOtp.setBorderWidth(borderWidth: 1.0)
        viewOtp.setBorderColor(borderColor: ENUMCOLOUR.themeColour.getColour())
        viewOtp.setCornerRadius(radius: 2)
        viewOtp.setInputBackgroundColor(inputBackgroundColor: UIColor.white)
        viewOtp.enableSecureEntries()
        self.viewOuterOtp.addSubview(viewOtp)
        
        viewOtp.onFillDigits = { number in
            print("input number is \(number)")
            self.userOtp = number
        }
        viewOtp.render()
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
            self.lblOtpTimmer.text = "OTP Valid for: 0:\(totalSecond)"
            self.btnResendOtp.isHidden = true
        }else if totalSecond == 0 {
            
            btnResendOtp.isHidden = false
            totalSecond = 30
            timer.invalidate()
            self.expireOTP()
        }
    }
    
    // imagePi8cker  delegate  methods
    func didSelect(image: UIImage?) {
        guard image != nil else {return}
        self.imgProfile.image = image
    }
    
    //MARK:- EMAIL ADDRESS CHANGE
    func changeEmail() {
        
        
        guard btnEmail.currentTitle != "Add new" else {
            if self.txtEmail.text == "" {
                self.txtEmail.becomeFirstResponder()
            }else {
                self.getVerificationEmailPhoneNo(verificationType: "Email")
            }
            return
        }
        
        if txtEmail.text == currentEmail || txtEmail.text == "" {
            self.txtEmail.becomeFirstResponder()
        } else  {
            if Validations.shareInstance.validateEmail(email: txtEmail.text!) {
                self.getVerificationEmailPhoneNo(verificationType: "Email")
            } else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: "PLEASE ENTER VALID EMAIL ")
            }
        }
        
    }
    
    //MARK:- PHONE NUMBER UPDATE
    func changePhoneNumber() {
        
        if txtPhoneNo.text == phoneNumber {
            self.txtPhoneNo.becomeFirstResponder()
        }else  {
            
            if Validations.shareInstance.validatePhoneNumber(value: txtPhoneNo.text!) {
                self.getVerificationEmailPhoneNo(verificationType: "phone")
            } else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: "PLEASE ENTER VALID PHONE NUMBER ")
            }
        }
    }
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        self.editUser()
    }
    @IBAction func btnOpenCamera(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
    @IBAction func btnAddress(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    @IBAction func btnUpdateEmail(_ sender: Any) {
        self.isCommingFrom = "Email"
        self.changeEmail()
    }
    
    @IBAction func btnUpdatePhoneNo(_ sender: Any) {
        self.isCommingFrom = "PhoneNumber"
        self.changePhoneNumber()
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        self.userOtp == nil ? Utilities.shared.showAlertWithOK(title: "ALERT!", msg: "Please enter OTP to continue"): self.verifiedOTP()
    }
    
    @IBAction func btnResendOtp(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}

@available(iOS 13.0, *)
extension ProfileEditVC:GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.txtAddress.text = place.formattedAddress
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
        
    }
}
