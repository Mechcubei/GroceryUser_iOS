//
//  AppConstants.swift
//  DeepDental
//
//  Created by Devoir Macbook on 21/12/19.
//  Copyright © 2019 Devoir Macbook. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AppConstants {
    static var baseURL = "http://134.209.157.211/Carrykoro/public/api/"
    // status User Default key
    static var otpVerificationID = "otpVerificationID"
    static var accountStatus = "accountStatus"
    
    //Login  User Default Key
    static var loginStatus = "loginStatus"

    static var lat = ""
    static var lon = ""
}

@available(iOS 13.0, *)
class Utilities{
    static let shared = Utilities()
    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        if let topController = UIApplication.shared.windows[0].rootViewController {
            topController.present(alert, animated: true, completion: nil)
        }
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

           let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailPred.evaluate(with: email)
    }
    
    func showAlertWithOK(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        if let topController = UIApplication.shared.windows[0].rootViewController {
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    func convertTimestamp(serverTimestamp: Double) -> Date {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        return date as Date
    }
    
    func getCurrentDate(format:String) -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let currentDate = formatter.string(from: date)
        return currentDate
    }
    
    func convertInDate(format:String,date:String) -> Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let currentDate = formatter.date(from: date)
        return currentDate
    }
    
    func convertDateInString(format:String,date:Date) -> String?{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let currentDate = formatter.string(from: date)
        return currentDate
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String, completion:  @escaping(String)->Void) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        var addressString : String = ""
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    //                print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                guard let placemarks = placemarks else{ return }
                let pm = placemarks as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks[0]
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + " "
                    }
                    //                if pm.postalCode != nil {
                    //                    addressString = addressString + pm.postalCode! + " "
                    //                }
                    completion(addressString)
                }
        })
    }
}
