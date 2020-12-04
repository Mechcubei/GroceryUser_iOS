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
    
    //MARK:- LOCAL VARIABLES
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getUserProfile()
        self.imgProfile.cornerRadius = imgProfile.frame.size.width/2
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
    }
    
    //MARK:- SETUP UI
    func setUpUI(firstName:String?,lastname:String,email:String,phoneNumber:Int,address:String) {
        
        self.txtFirstname.text = firstName
        self.txtLastName.text = lastname
        self.txtEmail.text = email
        self.txtPhoneNo.text = "\(phoneNumber)"
        self.txtAddress.text = address
        self.lblName.text = firstName! + " " + lastname
        
    }
    
    //MARK:- GET USER PROFILE API
    func getUserProfile() {
        
        Loader.shared.showLoader()
        let params:[String:Any] = ["role":"User"]
        GetApiResponse.shared.getUserProfile(params: params) { (data:GetUserProfileStruct) in
            print(data)
            Loader.shared.stopLoader()
            
            self.setUpUI(firstName: data.data.first_name ?? "", lastname: data.data.last_name ?? "", email: data.data.email ?? "", phoneNumber: data.data.phone!, address: data.data.address ?? "")
            
        }
    }
    
    //MARK:- EDIT USER API
    func editUser() {
        
        var parameters = [String:Any]()
        parameters = [
            "first_name":txtFirstname.text ?? "",
            "last_name":txtLastName.text ?? "",
            "address":txtAddress.text ?? ""
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
                    print(response)
                    Loader.shared.stopLoader()
                    let data = JSON(response).dictionary
//                    let status = data["statusCode"].intValue
//                    let message = data["message"].string
                    
//                    guard status == 200 else {
//                        Utilities.shared.showAlertWithOK(title: "", msg: message ?? "" )
//                        return
//                    }
//                     let dashboardVC = self.navigationController!.viewControllers.filter { $0 is MyAccountVC }.first!
//                     self.navigationController!.popToViewController(dashboardVC, animated: true)
            }
            
            case .failure(let encodingError):
                print(encodingError)
                
                
            }
        }
        
    }
    
    // imagePi8cker  delegate  methods
    func didSelect(image: UIImage?) {
        self.imgProfile.image = image
        
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
    
}
