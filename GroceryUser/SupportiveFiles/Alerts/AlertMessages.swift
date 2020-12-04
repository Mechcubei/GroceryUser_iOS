//
//  AlertMessages.swift
//  Learning
//
//  Created by Amandeep tirhima on 2020-04-25.
//  Copyright © 2020 Amandeep tirhima. All rights reserved.
//

import UIKit

enum  AlertMessages: String {
    
    // REGISTRATION ALERTS
    case  emptyFirstName = "Please enter your first name"
    case emptyLastName = "Please enter your last name"
    case emptyEmailId = "Please enter your email."
    case notValidEmailId = "Please enter valid email."
    case emptyPassword = "Please enter your password."
    case emptyConfirmPassword = "Please enter your confirm password."
    case mismatchPassword = "Password does not match"
    case emptyPhoneNumber = "Please enter your phone number."
    case notValidPhonenumber = "Please enter valid phone number"
    case emptyAddress = "Please enter your address"
    case emptyGender = "Please select Gender"
    
}
extension UIAlertController {
    // MARK: - UIAlertController+Present
    
    private struct ButtonsName {
        static let Ok = NSLocalizedString("Submit", comment: "")
        static let Cancel = NSLocalizedString("Cancel", comment: "")
    }
    
    
    class func suggestionAlertViewWithTitle(title:String?, placeholder:String, message:String, presenter:UIViewController, destructive:Bool = false,
                                            okButtonCompletion:((_ enteredSuggestion:String?)->Void)?, cancelButtonCompletion:(()->Void)?, presentCompletion:(()->Void)?) {
        var alertTitle = UIAlertController.appName()
        if let userTitle = title {
            alertTitle = userTitle
        }
        
        let controller = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: ButtonsName.Ok, style: destructive == true ? .destructive : .default) { (action) in
            if let okButtonCompletion = okButtonCompletion {
                let text = controller.textFields?.first?.text
                DispatchQueue.main.async {
                    okButtonCompletion(text)
                }
            }
        }
        let cancelAction = UIAlertAction(title: ButtonsName.Cancel, style: .cancel) { (action) in
            if let cancelButtonCompletion = cancelButtonCompletion {
                DispatchQueue.main.async {
                    cancelButtonCompletion()
                }
            }
        }
        
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        controller.addTextField { (textField) in
            textField.placeholder = placeholder
        }
        
        DispatchQueue.main.async {
            presenter.present(controller, animated: true, completion: presentCompletion)
        }
    }

    // MARK: - Private

    private static func appName () -> String {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }
}
