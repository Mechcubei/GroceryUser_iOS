//
//  SignUpVC.swift
//  GroceryUser
//
//  Created by osx on 21/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SignUpVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    
    var fcmToken:String = UserDefaults.standard.string(forKey: "FCMToken")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    //MARK:- EDIT PROFILE API
    func editProfile() {

        let params:[String:Any] = [
            "first_name":txtFirstName.text ?? "",
            "last_name":txtLastName.text ?? "",
            "fcm_token": fcmToken
        ]
        print(params)
        GetApiResponse.shared.editProfile(params: params) { (data: RegisterStruct) in
        print(data)
            if data.statusCode == 200 {
                let vc = ENUM_STORYBOARD<TabbarVC>.tabbar.instantiativeVC()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
            }
        }
    }

    //MARK:- VALIDATIONS
    func valid() -> Bool{
           
        let valid = Validations.shareInstance.validateSignUp(firstName: txtFirstName.text ?? "", lastName: txtLastName.text ?? "")
           
           switch valid {
               
           case .success:
               
               return true
               
           case .failure(let error):
               
               Toast.show(text: error, type: .error)
               
               return false
           }
       }
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnSignUp(_ sender: Any) {
        guard valid() else { return }
        self.editProfile()
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
