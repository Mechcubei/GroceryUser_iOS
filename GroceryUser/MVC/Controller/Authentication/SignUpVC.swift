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
    @IBOutlet var txtEmail: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    //MARK:- EDIT PROFILE API
    func editProfile() {
        
        let params:[String:Any] = ["firstname":txtFirstName.text ?? "","lastname":txtLastName.text ?? ""]
        GetApiResponse.shared.editProfile(params: params) { (data: RegisterStruct) in
        print(data)
            if data.statusCode == 200 {
                let vc = ENUM_STORYBOARD<TabbarVC>.tabbar.instantiativeVC()
            
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    //MARK:- VALIDATIONS
    func valid() -> Bool{
           
        let valid = Validations.shareInstance.validateSignUp(firstName: txtFirstName.text ?? "", lastName: txtLastName.text ?? "", email: txtEmail.text ?? "")
           
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
