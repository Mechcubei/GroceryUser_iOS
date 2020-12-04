//
//  FilterVC.swift
//  GroceryUser
//
//  Created by osx on 03/11/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var lblOne: UILabel!
    @IBOutlet var lblTwo: UILabel!
    @IBOutlet var lblThree: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblSecondRating: UILabel!
    @IBOutlet var lblLeft: UILabel!
    @IBOutlet var lblRight: UILabel!
    @IBOutlet var viewHidden: UIView!
    @IBOutlet var viewRadioButton: DesignableView!
    @IBOutlet var viewSeakBar: DesignableView!
    @IBOutlet var btnRadioOne: UIButton!
    @IBOutlet var BtnRadioTwo: UIButton!
    @IBOutlet var btnRadioThree: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        
    }
    //MARK:- SETUP UI
    func setUpUI() {
        self.tabBarController?.tabBar.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideViewOnTap(_sender:)))
        viewHidden.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func hideViewOnTap(_sender:UITapGestureRecognizer) {
        
        self.viewHidden.isHidden = true
        self.viewRadioButton.isHidden = true
        self.viewSeakBar.isHidden = true
    }
    
    
    //MARK:- ACTION BUTTON
    @IBAction func btnBrand(_ sender: Any) {
        
    }
    @IBAction func btnProductRating(_ sender: Any) {
        self.lblSecondRating.text = "Select Rating"
        self.viewHidden.isHidden = false
        self.viewSeakBar.isHidden = false
    }
    @IBAction func btnPrice(_ sender: Any) {
        self.lblSecondRating.text = "Select your price range"
        self.viewHidden.isHidden = false
        self.viewSeakBar.isHidden = false
    }
    @IBAction func btnDiscount(_ sender: Any) {
        self.lblSecondRating.text = "Select Discount Range"
        self.viewHidden.isHidden = false
        self.viewSeakBar.isHidden = false
        
    }
    @IBAction func btnPackSize(_ sender: Any) {
        self.lblRating.text = "Select Packages"
        self.viewHidden.isHidden = false
        self.viewRadioButton.isHidden = false
    }
    
    @IBAction func btnFoodPreference(_ sender: Any) {
        self.lblRating.text = "Food Preferences"
        self.lblOne.text = "Veg"
        self.lblTwo.text = "Non-Veg"
        self.lblThree.text = "Both"
        self.viewHidden.isHidden = false
        self.viewRadioButton.isHidden = false
        
    }
    @IBAction func btnClearAll(_ sender: Any) {
        
    }
    @IBAction func btnDone(_ sender: Any) {
        
    }
    @IBAction func btnRadioButtonAction(_ sender: UIButton){
        
        switch sender.tag {
        case 1:
            btnRadioOne.isSelected = true
            BtnRadioTwo.isSelected = false
            btnRadioThree.isSelected = false
            
        case 2:
            btnRadioOne.isSelected = false
            BtnRadioTwo.isSelected = true
            btnRadioThree.isSelected = false
            
        case 3:
            btnRadioOne.isSelected = false
            BtnRadioTwo.isSelected = false
            btnRadioThree.isSelected = true
            
        default:
            ""
        }
        
    }
    
    @IBAction func btnFirstNext(_ sender: Any) {
        
    }
    
    @IBAction func btnSecondNext(_ sender: Any) {
        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnFirstClose(_ sender: Any) {
        self.viewHidden.isHidden = true
        self.viewRadioButton.isHidden = true
    }
    @IBAction func btnSecondClose(_ sender: Any) {
        self.viewHidden.isHidden = true
        self.viewSeakBar.isHidden = true
    }
}
