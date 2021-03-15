//
//  DeliveryOptionVC.swift
//  GroceryUser
//
//  Created by osx on 28/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation
import SkyFloatingLabelTextField

@available(iOS 13.0, *)
class DeliveryOptionVC: UIViewController,UITextFieldDelegate {
    
    enum RadioImages:String {
        case Select = "Select"
        case Unselect = "icons8-round-48"

    }
    
    //MARK:- OUTLETS
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var imgInstant: UIImageView!
    @IBOutlet var imgSchedule: UIImageView!
    @IBOutlet var viewPickUpTime: UIView!
    @IBOutlet var txtPickUpTime: SkyFloatingLabelTextField!
    @IBOutlet var txtPickUpDate: SkyFloatingLabelTextField!
    @IBOutlet var viewPickUpDate: UIView!
    @IBOutlet var viewDelivery: DesignableView!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblGst: UILabel!
    @IBOutlet var lblDeliveryCharges: UILabel!
    @IBOutlet var lblAppliedCoupan: UILabel!
    @IBOutlet var lblTotalAmount: UILabel!
    
    
    //MARK:- LOCAL VARIABLES
    var arrProduct = [ListCategoryStruct2]()
    var latitude = Double()
    var longitude = Double()
    let datePicker = UIDatePicker()
    var buyNow:Bool = false
    var currentLocation = MyCurrentLocation.location
    var deliveryType:String = ""
    var reviewBasketQuantity = 0
    var isCommingFrom:Bool = false
    var price = Int()
    var deliveryCharges = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.extraFunctionCall()
        
    }

    func setUpBilling(price:Int,deliveryCharges:Int,totalPrice:Int) {
        self.lblAmount.text = "Rs.\(price)/-"
        self.lblDeliveryCharges.text = "Rs.\(deliveryCharges)/-"
        self.lblTotalAmount.text = "Rs.\(totalPrice)/-"
        
    }
    
    //MARK:- EXTRA FUNCTION CALL
    func extraFunctionCall() {
        
        self.tabBarController?.tabBar.isHidden = true
        self.setImage(instant: RadioImages.Select.rawValue, schedule: RadioImages.Unselect.rawValue)
        self.hideShowView(viewPickUpDate: true, viewPickUpTime: true)
        self.deliveryType = "Instant"
        self.lblAddress.text = currentLocation
        self.viewDelivery.isHidden = isCommingFrom == true ? true :false
        self.setUpBilling (
            price: price,
            deliveryCharges: buyNow == false ?
                arrProduct[0].delivery_charge!
                : deliveryCharges,
            totalPrice:  buyNow == true ? price : price + arrProduct[0].delivery_charge!
        )
    }
    
    func addTotalAmount() {
        let a = price
        let b = arrProduct[0].delivery_charge!
        let c = a + b
        print(c)
    }
    
    
    //MARK:- ORDER REQUEST API
    func orderRequest() {
        
        var subProductArr = [[String:Any]]()
        for i in 0..<arrProduct.count {
            let data:[String:Any] =
                [
        
                    "quantity":buyNow == true ? arrProduct[i].selectedQty ?? 1 : arrProduct[i].quantity!,
                    "merchant_inventory_id": arrProduct[i].merchant_inventory_id!
            ]
            subProductArr.append(data)
            print(subProductArr)
        }
        
        let dataDict:[String:Any] = [
            "data":subProductArr
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject:dataDict)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        let params:[String:Any] = [
            
            "address":lblAddress.text!,
            "latitude":latitude,
            "longitude":longitude,
            "delivery_type":deliveryType,
            "pickup_date":txtPickUpDate.text ?? "",
            "pickup_time":txtPickUpTime.text ?? "",
            "product":jsonString!
        ]
        print(params)
        Loader.shared.showLoader()
        GetApiResponse.shared.order_request(params: params) { (data: OrderRequestStruct) in
            print(data)
            Loader.shared.stopLoader()
            if data.statusCode == 200 {
                
                if let viewControllers = self.navigationController?.viewControllers {
                    for vc in viewControllers {
                        if vc.isKind(of: CategoriesVC.classForCoder()) {
                            self.navigationController!.popToViewController(vc, animated: true)
                        }else {
                            self.tabBarController?.selectedIndex =  0
                        }
                    }
                }
                Utilities.shared.showAlertWithOK(title: "", msg: data.message!)
            } else {
                Utilities.shared.showAlertWithOK(title: "", msg: data.message!)
            }
        }
    }
    
    //MARK:- DELETE BASKET API
    func deleteBasketList(index:Int) {
   
        let params:[String:Any] = [
            "basket_id":arrProduct[index].basket_id!,
            "merchant_user_id":arrProduct[index].marchent_user_id!
        ]
        GetApiResponse.shared.deleteBasketList(params: params) { (data:AddToBasketStruct) in
            print(data)
        }
    }
    
    //MARK:- VALIDATIONS
    func valid() -> Bool{
        
        let valid = Validations.shareInstance.validTimeAndDate(pickUpDate: txtPickUpDate.text ?? "", pickUpTime: txtPickUpTime.text ?? "")
        switch valid {
        case .success:
            return true
        case .failure(let error):
            Toast.show(text: error, type: .error)
            return false
        }
    }
    
    //MARK:- SET RADIO BUTTON IMAGE
    func setImage(instant:String, schedule:String) {
        self.imgInstant.image = UIImage(named: instant)
        self.imgSchedule.image = UIImage(named: schedule)
    }
    
    //MARK:- HIDE/SHOW VIEW
    func hideShowView(viewPickUpDate:Bool, viewPickUpTime:Bool) {
        self.viewPickUpDate.isHidden = viewPickUpDate
        self.viewPickUpTime.isHidden = viewPickUpTime
    }
    
    //MARK:- DATE AND TIME PICKER
    func showDatePicker(mode:UIDatePicker.Mode){
        //Formate Date
        datePicker.datePickerMode = mode
        datePicker.minimumDate = datePicker.date.convertInDate(format: "yyyy", date: "2021")
        datePicker.maximumDate = datePicker.date.convertInDate(format: "yyyy", date: "4000")
    
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: Selector(("donedatePicker")))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("cancelDatePicker")))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        switch mode {
        case .time:
            self.txtPickUpTime.inputAccessoryView = toolbar
            self.txtPickUpTime.inputView = datePicker
        case .date:
            self.txtPickUpDate.inputAccessoryView = toolbar
            self.txtPickUpDate.inputView = datePicker
        default:
            self.txtPickUpDate.inputView = datePicker
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.showDatePicker(mode:textField == txtPickUpTime ? .time  : .date)
        
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        
        guard  txtPickUpDate.isFirstResponder == true  else {
            formatter.dateFormat = "hh:mm a"
            txtPickUpTime.text = formatter.string(from: datePicker.date)
            self.view.endEditing(true)
            return
        }
        formatter.dateFormat = "yyyy/MM/dd"
        txtPickUpDate.text = formatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    //MARK:- ACTION BUTTON
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnProceedToPay(_ sender: Any) {
        
        if self.deliveryType == "Schedule" {
            guard valid() else {return}
            self.orderRequest()
        }
        self.orderRequest()
    }
    @IBAction func btnChangeLocation(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func btnSelectAndUnselectRadioButton(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            self.setImage(instant: RadioImages.Select.rawValue, schedule: RadioImages.Unselect.rawValue)
            self.hideShowView(viewPickUpDate: true, viewPickUpTime: true)
            self.deliveryType = "Instant"
        case 1:
            self.setImage(instant: RadioImages.Unselect.rawValue, schedule: RadioImages.Select.rawValue)
            self.hideShowView(viewPickUpDate: false, viewPickUpTime: false)
            self.deliveryType = "Schedule"
        default:
            break
        }
    }
}

@available(iOS 13.0, *)
extension DeliveryOptionVC:GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.lblAddress.text = place.formattedAddress
        self.latitude = place.coordinate.latitude
        self.longitude = place.coordinate.longitude
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
