//
//  FilterVC.swift
//  GroceryUser
//
//  Created by osx on 03/11/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import RangeSeekSlider

enum LabelText:String {
    case rating = "Select Rating"
    case price = "Select your price range"
    case discount = "Select Discount Range"
    case liter = "Liter"
    case kg = "Kg"
    case both = "Both"
    case veg = "Veg"
    case nonVeg = "Non-Veg"
    case package = "Select Packages"
    case food = "Food Preferences"
}

enum setSeekBarVAlue:String {
    case pricee = "Price"
    case discount = "Discount"
}

enum setRadioButtonValue:String {
    case packSize = "Pack Size"
}

struct setSelectedValue {
    var type = ""
    var value = ""
}

protocol FilteredDataShow {
    func filterResult(data:[ListCategoryStruct2])
}


@available(iOS 13.0, *)
class FilterVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var lblOne: UILabel!
    @IBOutlet var lblTwo: UILabel!
    @IBOutlet var lblThree: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblSecondRating: UILabel!
    @IBOutlet var viewHidden: UIView!
    @IBOutlet var viewRadioButton: DesignableView!
    @IBOutlet var viewSeakBar: DesignableView!
    @IBOutlet var btnRadioOne: UIButton!
    @IBOutlet var BtnRadioTwo: UIButton!
    @IBOutlet var btnRadioThree: UIButton!
    @IBOutlet var rangeSeekBar: RangeSeekSlider!
    @IBOutlet var viewHideTblView: UIView!
    @IBOutlet var filterTblView: UITableView!
    @IBOutlet var lblNoDataFound: UILabel!
    @IBOutlet var btnFilter: UIButton!
    @IBOutlet var selectedValueTableView: UITableView!
    @IBOutlet var heightSelectTableview: NSLayoutConstraint!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnAddToCart: UIButton!
    @IBOutlet var btnDone: DesignableButton!
    
    
    //MARK:- LOCAL VARIABLES
    var minPriceValue = Int()
    var minDiscountValue = Int()
    var maxPriceValue = Int()
    var maxDiscountValue = Int()
    var isCommingFromSeekBarView = ""
    var isCommingFromRadioButtonView = ""
    var isSelectRadioButton = ""
    var arrFilter = [ListCategoryStruct2]()
    var arrSelectedVAlue = [setSelectedValue]()
    var myIndex = Int()
    var delegateFilter:FilteredDataShow?
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        self.registerNibFileName()
        
    }
    
    //MARK:- SETUP UI
    func setUpUI() {
        
        //SET RANGE SEEK BAR
        self.rangeSeekBar.delegate = self
        self.rangeSeekBar.numberFormatter.numberStyle = .none
        
        self.tabBarController?.tabBar.isHidden = true
        self.btnDoneStatus(btnDoneUserInteraction: false, btnColor: ENUMCOLOUR.ButtonUserInteractionColorDisable.getColour())
        
        //TAP GESTURE
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideViewOnTap(_sender:)))
        viewHidden.addGestureRecognizer(tapGesture)
        
        //SET BY DEFAULT PACK SIZE VALUE
//        self.isSelectRadioButton = "kg"
//        setRadioButtonAction(btnRadioOne: false, btnRadioTwo: true, btnRadioThree: false)
    }
    
    //MARK:- DONE BUTTON STATUS
    func btnDoneStatus(btnDoneUserInteraction:Bool, btnColor:UIColor) {
        self.btnDone.isUserInteractionEnabled = btnDoneUserInteraction
        self.btnDone.backgroundColor = btnColor
    }
    
    
    //MARK:- SET TABLEVIEW HEIGHT
    func setHeightTblView() {
        self.view.layoutIfNeeded()
        self.heightSelectTableview.constant = self.selectedValueTableView.contentSize.height
        self.selectedValueTableView.reloadData()
        
    }
    
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        self.selectedValueTableView.register(UINib(nibName: "SelectedValueTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectedValueTableViewCell")
    }
    
    //MARK:- FILTER PRODUCT API
    func filterProduct() {
        let params:[String:Any] = ["min_price":minPriceValue,"max_price":maxPriceValue,"min_discount":minDiscountValue,"max_discount":maxDiscountValue,"pack_size":isSelectRadioButton]
        print(params)
        Loader.shared.showLoader()
        GetApiResponse.shared.filterProduct(params: params) { (data:ListCategoryStruct) in
            Loader.shared.stopLoader()
            print(data)
            guard data.statusCode == 200 else{
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
                return
            }

            self.arrFilter = data.data!
            self.delegateFilter?.filterResult(data:self.arrFilter)
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    func setUpFilterListHideShow(viewHideTblView:Bool,btnFilterShow:Bool,btnBack:Bool,btnAddToCart:Bool) {
        self.viewHideTblView.isHidden = viewHideTblView
        self.btnFilter.isHidden = btnFilterShow
        self.btnBack.isHidden = btnBack
        self.btnAddToCart.isHidden = btnAddToCart
    }
    
    func setUpViewHideShowOnTapView(viewHidden:Bool,viewRadioButton:Bool,viewSeakBar:Bool) {
        self.viewHidden.isHidden = viewHidden
        self.viewRadioButton.isHidden = viewRadioButton
        self.viewSeakBar.isHidden = viewSeakBar
        
    }
    
    //MARK:- HIDE VIEW ON TAP
    @objc func hideViewOnTap(_sender:UITapGestureRecognizer) {
        self.setUpViewHideShowOnTapView(viewHidden: true, viewRadioButton: true, viewSeakBar: true)
        
    }
    
    //MARK:- SETUP SEEKBAR VIEW
    func setSeekBar(text:String,viewHidden:Bool,viewSeakbar:Bool) {
        
        self.lblSecondRating.text = text
        self.viewHidden.isHidden = viewHidden
        self.viewSeakBar.isHidden = viewSeakbar
    }
    
    //MARK:- SETUP RADIO BUTTON VIEW
    func setRadioButton(textRating:String,textOne:String,textTwo:String,textThree:String,viewHidden:Bool,viewRadioButton:Bool) {
        self.lblRating.text = textRating
        self.lblOne.text = textOne
        self.lblTwo.text = textTwo
        self.lblThree.text = textThree
        self.viewHidden.isHidden = viewHidden
        self.viewRadioButton.isHidden = viewRadioButton
        
    }
    
    //MARK:- SET RADIO BUTTON ACTION
    func setRadioButtonAction(btnRadioOne:Bool,btnRadioTwo:Bool,btnRadioThree:Bool) {
        
        self.btnRadioOne.isSelected = btnRadioOne
        self.BtnRadioTwo.isSelected = btnRadioTwo
        self.btnRadioThree.isSelected = btnRadioThree
    }

    //MARK:- DELETE CELL OF SELECTED TABLE VIEW
    @objc func deleteSelectedValueCell(sender:UIButton) {
        self.arrSelectedVAlue.remove(at: sender.tag)
        self.selectedValueTableView.reloadData()
        if arrSelectedVAlue.count == 0 {
            self.selectedValueTableView.isHidden = true
            self.btnDoneStatus(btnDoneUserInteraction: false, btnColor: ENUMCOLOUR.ButtonUserInteractionColorDisable.getColour())
        }
    }
    
    //MARK:- ACTION BUTTON
    @IBAction func btnProductRating(_ sender: Any) {
        self.setSeekBar(text: LabelText.rating.rawValue, viewHidden: false, viewSeakbar: false)
    }
    
    @IBAction func btnPrice(_ sender: Any) {
    
        self.isCommingFromSeekBarView = setSeekBarVAlue.pricee.rawValue
        self.rangeSeekBar.minValue = 0
        self.rangeSeekBar.selectedMinValue = 20
        self.rangeSeekBar.selectedMaxValue = 100
        self.rangeSeekBar.maxValue = 200
        
        self.setSeekBar(text: LabelText.price.rawValue, viewHidden: false, viewSeakbar: false)
        
    }
    
    @IBAction func btnDiscount(_ sender: Any) {
        self.isCommingFromSeekBarView = setSeekBarVAlue.discount.rawValue
        self.rangeSeekBar.minValue = 0
        self.rangeSeekBar.selectedMinValue = 20
        self.rangeSeekBar.maxValue = 200
        self.rangeSeekBar.selectedMaxValue = 100
        
        self.setSeekBar(text: LabelText.discount.rawValue, viewHidden: false, viewSeakbar: false)
    }
    
    @IBAction func btnPackSize(_ sender: Any) {
        
        self.isCommingFromRadioButtonView = setRadioButtonValue.packSize.rawValue
        self.setRadioButton(textRating: LabelText.package.rawValue,textOne: LabelText.liter.rawValue,textTwo: LabelText.kg.rawValue,textThree: LabelText.both.rawValue, viewHidden: false, viewRadioButton: false)
        
    }
    
    @IBAction func btnFoodPreference(_ sender: Any) {
        self.setRadioButton(textRating: LabelText.food.rawValue,textOne: LabelText.veg.rawValue,textTwo: LabelText.nonVeg.rawValue,textThree: LabelText.both.rawValue, viewHidden: false, viewRadioButton: false)
        
    }
    
    @IBAction func btnClearAll(_ sender: Any) {
        self.arrSelectedVAlue.removeAll()
        self.selectedValueTableView.reloadData()
        self.btnDoneStatus(btnDoneUserInteraction: false, btnColor: ENUMCOLOUR.ButtonUserInteractionColorDisable.getColour())
        if arrSelectedVAlue.count == 0 {
            self.selectedValueTableView.isHidden = true
        }
    }
    
    @IBAction func btnDone(_ sender: Any) {
        self.filterProduct()
    }
    
    @IBAction func btnRadioButtonAction(_ sender: UIButton){
       
        switch sender.tag {
        case 1:
            self.isSelectRadioButton = "ltr"
            setRadioButtonAction(btnRadioOne: true, btnRadioTwo: false, btnRadioThree: false)
            
        case 2:
            self.isSelectRadioButton = "kg"
            setRadioButtonAction(btnRadioOne: false, btnRadioTwo: true, btnRadioThree: false)
            
        case 3:
            self.isSelectRadioButton = "both"
            setRadioButtonAction(btnRadioOne: false, btnRadioTwo: false, btnRadioThree: true)
            
        default:
            ""
        }
    }
    
    @IBAction func btnFirstNext(_ sender: Any) {
  
        switch isCommingFromRadioButtonView {
        case setRadioButtonValue.packSize.rawValue:
            
            guard isSelectRadioButton != "" else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: "Please select One option")
                return
            }
            
            if let selectPackSize = self.arrSelectedVAlue.firstIndex(where: { selectedPackSize -> Bool in
                return selectedPackSize.type == "Pack Size"
            })  {
                self.arrSelectedVAlue[selectPackSize].value = isSelectRadioButton
            } else {
                self.arrSelectedVAlue.append(setSelectedValue.init(type: setRadioButtonValue.packSize.rawValue, value: isSelectRadioButton))
                self.btnDoneStatus(btnDoneUserInteraction: true, btnColor: ENUMCOLOUR.themeColour.getColour())
            }
        default:
            break
        }
        self.selectedValueTableView.isHidden = false
        self.viewRadioButton.isHidden = true
        self.viewHidden.isHidden = true
        self.selectedValueTableView.reloadData()
        self.setHeightTblView()
    }
    
    @IBAction func btnSecondNext(_ sender: Any) {
   
        switch isCommingFromSeekBarView {

        case setSeekBarVAlue.pricee.rawValue:
            
            if let selectPrice = self.arrSelectedVAlue.firstIndex(where: { selectedPrice -> Bool in
                return selectedPrice.type == "Price"
            })  {
                self.arrSelectedVAlue[selectPrice].value = "\(minPriceValue)" + "-" + "\(maxPriceValue)"
                
            } else {
                self.arrSelectedVAlue.append(setSelectedValue.init(type: setSeekBarVAlue.pricee.rawValue, value: "\(minPriceValue)" + "-" + "\(maxPriceValue)" ))
                self.btnDoneStatus(btnDoneUserInteraction: true, btnColor: ENUMCOLOUR.themeColour.getColour())
            }
 
        case setSeekBarVAlue.discount.rawValue:
            
            if let selectDiscount = self.arrSelectedVAlue.firstIndex(where: { selectedDiscount -> Bool in
                return selectedDiscount.type == "Discount"
            })  {
                self.arrSelectedVAlue[selectDiscount].value = "\(minDiscountValue)" + "-" + "\(maxDiscountValue)"
            } else {
                self.arrSelectedVAlue.append(setSelectedValue.init(type: setSeekBarVAlue.discount.rawValue, value: "\(minDiscountValue)" + "-" + "\(maxDiscountValue)" ))
                self.btnDoneStatus(btnDoneUserInteraction: true, btnColor: ENUMCOLOUR.themeColour.getColour())
            }
    
        default:
            break
        }
        self.selectedValueTableView.isHidden = false
        self.viewSeakBar.isHidden = true
        self.viewHidden.isHidden = true
        self.selectedValueTableView.reloadData()
        self.setHeightTblView()
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
    
    @IBAction func btnFilter(_ sender: Any) {
    }
    
    @IBAction func btnAddToCart(_ sender: Any) {
    }
}

@available(iOS 13.0, *)
extension FilterVC:RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
        
        switch isCommingFromSeekBarView {
        case setSeekBarVAlue.pricee.rawValue:
            self.maxPriceValue = Int(maxValue)
            self.minPriceValue = Int(minValue)
            
        case setSeekBarVAlue.discount.rawValue:
            self.maxDiscountValue = Int(maxValue)
            self.minDiscountValue = Int(minValue)
        default:
            break
        }
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}

//MARK:- EXTENTION TABLE VIEW
@available(iOS 13.0, *)
extension FilterVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSelectedVAlue.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedValueTableViewCell", for: indexPath) as! SelectedValueTableViewCell
        cell.btnDeleteCell.tag = indexPath.row
        cell.lblNameValue.text = arrSelectedVAlue[indexPath.row].value
        cell.lblNameKey.text =  arrSelectedVAlue[indexPath.row].type + ":-"
        cell.btnDeleteCell.addTarget(self, action: #selector(deleteSelectedValueCell(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
