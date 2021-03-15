//
//  MyAccountVC.swift
//  GroceryUser
//
//  Created by osx on 22/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation
import SDWebImage

@available(iOS 13.0, *)
class MyAccountVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var lblName: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPhoneNumber: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
  
    //VARIABLES
    var arrImg = [UIImage(named: "Payment-Background-Image"),UIImage(named: "Rating-Background-Image"),UIImage(named: "Notifcation-icon"),UIImage(named: "gift-icon"),UIImage(named: "log-out-icon")]
    var arrName = ["My Payments","My Ratings & Reviews","Notification","My Gift Cards","Log Out"]
    var userPhoneNumber:String?
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibFileName()
        self.getprofile()
        self.imgProfile.cornerRadius = self.imgProfile.frame.size.width/2
    
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.getprofile()
    }
    
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        tblView.register(UINib(nibName: "MyAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAccountTableViewCell")
    }
    
    //MARK:- GET PROFILE API
    func getprofile() {
        
        let params:[String:Any] = ["role":"User"]
        GetApiResponse.shared.getProfile(params: params) { (data: EditProfileStruct) in
            print(data)
            self.setData(firstName: data.data.first_name ?? "", lastname: data.data.last_name ?? "", email: data.data.email ?? "", phoneNumber: "\(String(describing: data.data.phone!))", address: data.data.address ?? "", image: data.data.image ?? "")
        }
    }
  
    func setData(firstName:String,lastname:String,email:String,phoneNumber:String,address:String,image:String) {
        self.lblName.text = firstName + " " + lastname
        self.lblEmail.text = email
        self.lblEmail.isUserInteractionEnabled = true
        self.lblPhoneNumber.text = phoneNumber
        self.lblAddress.text = address
        self.imgProfile.sd_setImage(with: URL(string:image), placeholderImage: UIImage(named: "Profile-icon"))
    }
    func logOut() {
        
        UserDefaults.standard.set("", forKey: "token")
        let tabBarStoryBoard = UIStoryboard.init(name: "Login", bundle: nil)
        let dashboard = tabBarStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(dashboard, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnEditProfile(_ sender: Any) {
        let vc = ENUM_STORYBOARD<ProfileEditVC>.tabbar.instantiativeVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func btnChangeLocation(_ sender: Any) {
        let vc = ENUM_STORYBOARD<ProfileEditVC>.tabbar.instantiativeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
    }
}

//MARK:- EXTENSTION TABLEVIEW
@available(iOS 13.0, *)
extension MyAccountVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrImg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAccountTableViewCell", for: indexPath) as! MyAccountTableViewCell
        cell.imgView.image = arrImg[indexPath.row]
        cell.lblName.text = arrName[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        if indexPath.row == 0 {
        //            let vc = ENUM_STORYBOARD<MyOrderVC>.tabbar.instantiativeVC()
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        } else
        
        if (indexPath.row == 0) {
            let vc = ENUM_STORYBOARD<MyPaymentVC>.tabbar.instantiativeVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if (indexPath.row == 1 ){
            let vc = ENUM_STORYBOARD<RatingAndReviewVC>.tabbar.instantiativeVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if (indexPath.row == 2) {
            let vc = ENUM_STORYBOARD<NotificationVC>.tabbar.instantiativeVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }  else if (indexPath.row == 3) {
            
        } else {
            let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure, you want to logout? ", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                self.logOut()
                
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                refreshAlert .dismiss(animated: true, completion: nil)
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }
    }
}

@available(iOS 13.0, *)
extension MyAccountVC:GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
       func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
           self.lblAddress.text = place.formattedAddress
           
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
