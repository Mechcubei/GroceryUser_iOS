//
//  CategoriesVC.swift
//  GroceryUser
//
//  Created by osx on 22/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation

struct MyCurrentLocation {
    static var location:String = ""
}

@available(iOS 13.0, *)
class CategoriesVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var bannerCollectionView: UICollectionView!
    @IBOutlet var productsCollectnView: UICollectionView!
    @IBOutlet var productHeight: NSLayoutConstraint!
    @IBOutlet var recentlyCollectionView: UICollectionView!
    @IBOutlet var secondBannerCollectionView: UICollectionView!
    @IBOutlet var mostCollectionView: UICollectionView!
    @IBOutlet var pagingView: UIPageControl!
    @IBOutlet var secondBannerPageView: UIPageControl!
    @IBOutlet weak var merchantCollectnView: UICollectionView!
    @IBOutlet var btnSeeAll: DesignableButton!
    @IBOutlet var merchantHeight: NSLayoutConstraint!
    @IBOutlet var lblUserCurrentLocation: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet var txtSearchProduct: UITextField!
    @IBOutlet var viewTableviewHidden: UIView!
    @IBOutlet var searchTblView: UITableView!
    @IBOutlet var btnClearSearch: UIButton!
    @IBOutlet var lblNoSearchFound: UILabel!
    @IBOutlet var btnCategorySeeAll: DesignableButton!
    
    //MARK:- LOCAL VARIABLES
    var timer = Timer()
    var counter = 0
    var arrBannersImages = [UIImage(named: "first_banner"), UIImage(named: "second_banner")]
    var currentIndex = 0
    var arrListCategory = [ListCategoryStruct2]()
    var arrBannerList = [BannerListStruct2]()
    var arrRecentView = [ListCategoryStruct2]()
    var arrMostView = [ListCategoryStruct2]()
    var arrSelectMerchant = [SelectMerchantStruct2]()
    var categoryID:Int?
    var locationManager = CLLocationManager()
    let userDefault = UserDefaults.standard
    
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectMerchantCategory()
        self.listCategory()
//        self.setPaging()
        self.bannerList()
        self.recentView()
        self.mostView()
        self.registerNibFileName()
        self.setUpUserCurrentLocation()
        self.getprofile()
        self.imgProfile.cornerRadius = self.imgProfile.frame.size.width/2
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.selectMerchantCategory()
        self.listCategory()
        self.bannerList()
        self.recentView()
        self.mostView()
        self.getprofile()
        self.setUpUserCurrentLocation()
    }
    
    //MARK:- LIST CATEGORY API
    func listCategory() {
        Loader.shared.showLoader()
        let params:[String:Any] = ["":""]
        GetApiResponse.shared.listCategory(params: params) { (data:ListCategoryStruct) in
            print(data)
            Loader.shared.stopLoader()
            self.arrListCategory = data.data!
            self.productsCollectnView.reloadData()
        }
    }
    
    //MARK:- BANNER LIST API
    func bannerList() {
        
        let params:[String:Any] = ["":""]
        GetApiResponse.shared.bannerList(params: params) { (data:BannerListStruct) in
            print(data)
            self.arrBannerList = data.data
            self.bannerCollectionView.reloadData()
            self.secondBannerCollectionView.reloadData()
        }
    }
    
    //MARK:- RECENT VIEW API
    func recentView() {
        
        let params:[String:Any] = ["":""]
        GetApiResponse.shared.recentView(params: params) { (data:ListCategoryStruct) in
            print(data)
            self.arrRecentView = data.data!
            self.setRecentBascketSelectedItems(array: self.arrRecentView.count)
            self.recentlyCollectionView.reloadData()
        }
    }
    
    //MARK:- MOST VIEW API
    func mostView() {
        
        let params:[String:Any] = ["":""]
        GetApiResponse.shared.mostView(params: params) { (data:ListCategoryStruct) in
            print(data)
            self.arrMostView = data.data!
            self.setMostBascketSelectedItems(array: self.arrRecentView.count)
            self.mostCollectionView.reloadData()
        }
    }
    //MARK:- SELECT MERCHANT CATEGORY
    func selectMerchantCategory() {
        
        let params:[String:Any] = ["get_merchants":categoryID]
        GetApiResponse.shared.selectMerchant(params: params) { (data:SelectMerchantStruct) in
            print(data)
            self.arrSelectMerchant = data.data!
            self.merchantCollectnView.reloadData()
        }
    }
    
    func setRecentBascketSelectedItems(array:Int){
        for i in 0..<array {
            if let _ = self.arrRecentView[i].basket_qty{
                self.arrRecentView[i].isSelected  = true
                self.arrRecentView[i].selectedQty = self.arrRecentView[i].basket_qty
            }
        }
    }
    
    func setMostBascketSelectedItems(array:Int){
           for i in 0..<array {
               if let _ = self.arrMostView[i].basket_qty{
                   self.arrMostView[i].isSelected  = true
                   self.arrMostView[i].selectedQty = self.arrMostView[i].basket_qty
               }
           }
       }
    
    
    //MARK:- ADD MOST VIEW TO BASKET API
    func addMostViewToBasket(index:Int) {
        
        let params:[String:Any] = [
            "merchant_user_id":arrMostView[index].marchent_user_id!,
            "merchant_inventory_id":arrMostView[index].merchant_inventory_id!,
            "quantity":arrMostView[index].selectedQty ?? 1
        ]
        
        print(params)
        GetApiResponse.shared.addToBasket(params: params) { (data:AddToBasketStruct) in
            print(data)
        }
        UserDefaults.standard.set(index, forKey: "SaveArray")
    }
    
    //MARK:- ADD RECENT VIEW TO BASKET API
    func addRecentViewToBasket(index:Int) {
        
        let params:[String:Any] = [
            "merchant_user_id":arrRecentView[index].marchent_user_id!,
            "merchant_inventory_id":arrRecentView[index].merchant_inventory_id!,
            "quantity":arrRecentView[index].selectedQty ?? 1
        ]
        print(params)
        GetApiResponse.shared.addToBasket(params: params) { (data:AddToBasketStruct) in
            print(data)
        }
    }
    
    //MARK:- GET PROFILE API
    func getprofile() {
        
        let params:[String:Any] = ["role":"User"]
        GetApiResponse.shared.getProfile(params: params) { (data: EditProfileStruct) in
            print(data)
            self.imgProfile.sd_setImage(with: URL(string:data.data.image ?? ""), placeholderImage: UIImage(named: "Profile-icon"))
            self.lblUserCurrentLocation.text = data.data.address!
        }
    }
    
    //MARK:- SETUP USER CURRENT LOCATION
    func setUpUserCurrentLocation() {
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
   
    //MARK:- GET LOCATION ADDRESS FROM LAT AND LONG
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
                    
                    completion(addressString)
                }
        })
    }
    
    //SET PAGING ON BANNERS
    func setPaging() {
        
        self.pagingView.numberOfPages = arrBannerList.count
        self.pagingView.currentPage = currentIndex
        
        self.secondBannerPageView.numberOfPages = arrBannerList.count
        self.secondBannerPageView.currentPage = currentIndex
        
        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        
    }
    
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        
        self.bannerCollectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionViewCell")
        self.merchantCollectnView.register(UINib(nibName: "ProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        self.productsCollectnView.register(UINib(nibName: "ProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        self.recentlyCollectionView.register(UINib(nibName: "ViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ViewCollectionViewCell")
        self.secondBannerCollectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionViewCell")
        self.mostCollectionView.register(UINib(nibName: "ViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ViewCollectionViewCell")
        self.merchantCollectnView.isScrollEnabled = false
    }
    
    // AUTOSLIDER CHANGE IMAGE
    @objc func changeImage() {
        
        if counter < arrBannersImages.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter += 1
        } else {
            if counter < arrBannersImages.count {
                let index = IndexPath.init(item: counter, section: 0)
                self.secondBannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                counter += 1
            }
        }
    }
    
    //MARK:- DELETE RECENT VIEW BASKET API
    func deleteRecentBasketList(index:Int) {
        
        let params:[String:Any] = [
            "basket_id":arrRecentView[index].basket_id!,
            "merchant_user_id":arrRecentView[index].marchent_user_id!
        ]
        
        GetApiResponse.shared.deleteBasketList(params: params) { (data:DeleteBasketListStruct) in
            print(data)
            
            guard data.statusCode == 200 else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message)
                return
            }
            self.arrRecentView[index].isSelected = false
            self.recentlyCollectionView.reloadData()
        }
    }
    
    //MARK:- DELETE MOST VIEW BASKET API
    func deleteMostBasketList(index:Int) {
        
        let params:[String:Any] = [
            "basket_id":arrMostView[index].basket_id!,
            "merchant_user_id":arrMostView[index].marchent_user_id!
        ]
        
        GetApiResponse.shared.deleteBasketList(params: params) { (data:DeleteBasketListStruct) in
            print(data)
            
            guard data.statusCode == 200 else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message)
                return
            }
            self.arrMostView[index].isSelected = false
            self.mostCollectionView.reloadData()
        }
    }
    
    
    //MARK:- ACTION MOST VIEW ADD TO CART VALUE
    @objc func btnAddMostView(sender:UIButton){
        
        self.addMostViewToBasket(index: sender.tag)
        
        if  self.arrMostView[sender.tag].selectedQty == nil {
            self.arrMostView[sender.tag].selectedQty = 1
        }
        
        if  self.arrMostView[sender.tag].selectedQty == self.arrMostView[sender.tag].qty {
            Utilities.shared.showAlertWithOK(title: "ALERT!", msg: "Stock out of Limit")
            return
        }
        
        self.arrMostView[sender.tag].isSelected = true
        self.mostCollectionView.reloadData()
    }
    
    //MARK:- ACTION RECENT VIEW ADD TO CART VALUE
    @objc func btnAddRecentView(sender:UIButton){
        
        self.addRecentViewToBasket(index: sender.tag)
        
        if  self.arrRecentView[sender.tag].selectedQty == nil {
            self.arrRecentView[sender.tag].selectedQty = 1
            
        }
        
        if  self.arrRecentView[sender.tag].selectedQty == self.arrRecentView[sender.tag].qty {
            Utilities.shared.showAlertWithOK(title: "ALERT!", msg: "Stock out of Limit")
            return
        }

        self.arrRecentView[sender.tag].isSelected = true
        self.recentlyCollectionView.reloadData()
    }
    
    //MARK:- ACTION MOST VIEW PLUS VALUE
    @objc func plusMostView(sender:UIButton){
        
        if  self.arrMostView[sender.tag].selectedQty == nil {
            self.arrMostView[sender.tag].selectedQty = 1
        }
        
        if  self.arrMostView[sender.tag].selectedQty == self.arrMostView[sender.tag].qty {
            Utilities.shared.showAlertWithOK(title: "", msg: "Out of Limit")
            return
        }
        
        self.arrMostView[sender.tag].selectedQty! += 1
        print("now count is", self.arrMostView[sender.tag].selectedQty!)
        self.addMostViewToBasket(index: sender.tag)
        self.mostCollectionView.reloadData()
    }
    
    //MARK:- ACTION RECENT VIEW PLUS VALUE
    @objc func plusRecentView(sender:UIButton){
        
        if  self.arrRecentView[sender.tag].selectedQty == nil {
            self.arrRecentView[sender.tag].selectedQty = 1
        }
        if  self.arrRecentView[sender.tag].selectedQty == self.arrRecentView[sender.tag].qty {
            Utilities.shared.showAlertWithOK(title: "", msg: "Out of Limit")
            return
        }
        
        self.arrRecentView[sender.tag].selectedQty! += 1
        print("now count is", self.arrRecentView[sender.tag].selectedQty!)
        self.addRecentViewToBasket(index: sender.tag)
        self.recentlyCollectionView.reloadData()
    }
    
    //MARK:- ACTION MOST VIEW MINUS VALUE
    @objc func minusMostView(sender:UIButton){
        
        if  self.arrMostView[sender.tag].selectedQty == nil{
            self.arrMostView[sender.tag].selectedQty = 1
        }
        
        guard self.arrMostView[sender.tag].selectedQty!  > 1 else {
            self.arrMostView[sender.tag].isSelected = false
            self.deleteMostBasketList(index: sender.tag)
            self.mostCollectionView.reloadData()
            return
        }
        
        self.arrMostView[sender.tag].selectedQty! -= 1
         print("now count is", self.arrMostView[sender.tag].selectedQty!)
        self.addMostViewToBasket(index: sender.tag)
        self.mostCollectionView.reloadData()
    }
    
    //MARK:- ACTION RECENT VIEW MINUS VALUE
    @objc func minusRecentView(sender:UIButton){
        
        if  self.arrRecentView[sender.tag].selectedQty == nil{
            self.arrRecentView[sender.tag].selectedQty = 1
        }
        
        guard self.arrRecentView[sender.tag].selectedQty!  > 1 else {
            self.arrRecentView[sender.tag].isSelected = false
            self.deleteRecentBasketList(index: sender.tag)
            self.recentlyCollectionView.reloadData()
            return
        }
        
        self.arrRecentView[sender.tag].selectedQty! -= 1
         print("now count is", self.arrRecentView[sender.tag].selectedQty!)
        self.addRecentViewToBasket(index: sender.tag)
        self.recentlyCollectionView.reloadData()
    }
    
    //MARK:- ACTION BUTTON
    @IBAction func btnSeeAll(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            
            print("Selected")
            self.view.layoutIfNeeded()
            self.merchantHeight.constant = self.merchantCollectnView.contentSize.height
            self.merchantCollectnView.reloadData()
            self.btnSeeAll.setTitle("Show Less", for: .normal)
            
        } else {
            print("Unselected")
            self.merchantHeight.constant = 300
            self.btnSeeAll.setTitle("Show All", for: .normal)
        }
    }
    @IBAction func btnProfile(_ sender: Any) {
        let vc = ENUM_STORYBOARD<ProfileEditVC>.tabbar.instantiativeVC()
        vc.isCommingForProfile = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnClearSearch(_ sender: Any) {
    }
    
    @IBAction func btnCategorySeeAll(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            
            print("Selected")
            self.view.layoutIfNeeded()
            self.productHeight.constant = self.productsCollectnView.contentSize.height
            self.productsCollectnView.reloadData()
            self.btnCategorySeeAll.setTitle("Show Less", for: .normal)
            
        } else {
            print("Unselected")
            self.productHeight.constant = 300
            self.btnCategorySeeAll.setTitle("Show All", for: .normal)
        }
    }
    
}

//MARK:- EXTENTION COLLECTIONVIEW
@available(iOS 13.0, *)
extension CategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.bannerCollectionView) {
            return arrBannerList.count
            
        } else if (collectionView == self.merchantCollectnView) {
            return arrSelectMerchant.count
            
        } else if (collectionView == self.productsCollectnView)  {
            return arrListCategory.count
            
        } else if (collectionView == self.recentlyCollectionView) {
            return arrRecentView.count
            
        } else if (collectionView == self.secondBannerCollectionView) {
            return arrBannerList.count
            
        } else {
            return arrMostView.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.bannerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
            let imgUrl = arrBannerList[indexPath.row].banner_image
            cell.imgView.sd_setImage(with: URL(string: imgUrl!), placeholderImage: UIImage(named: ""))
            return cell
            
        } else if (collectionView == self.merchantCollectnView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
            let imageUrl = arrSelectMerchant[indexPath.row].image
            cell.imgProduct.sd_setImage(with: URL(string: imageUrl!), placeholderImage: UIImage(named: ""))
            
            let fullName = arrSelectMerchant[indexPath.row].username!
            cell.lblProductName.text = fullName
            
            return cell
            
            
        } else if (collectionView == self.productsCollectnView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
            let imageUrl = arrListCategory[indexPath.row].category_image
            cell.imgProduct.sd_setImage(with: URL(string: imageUrl!), placeholderImage: UIImage(named: ""))
            cell.lblProductName.text = arrListCategory[indexPath.row].category_name
            self.categoryID = arrListCategory[indexPath.row].category_id!
            return cell
            
        } else if (collectionView == self.recentlyCollectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewCollectionViewCell", for: indexPath) as! ViewCollectionViewCell
            cell.lblProductName.text = arrRecentView[indexPath.row].inventory_name
            cell.lblCategoryName.text = arrRecentView[indexPath.row].category_name
            cell.lblPrice.text = "MRP Rs. \(String(describing: arrRecentView[indexPath.row].price!))"
            let imgUrl = arrRecentView[indexPath.row].category_image
            cell.imgProduct.sd_setImage(with: URL(string: imgUrl ?? ""), placeholderImage: UIImage(named: ""))
            cell.lblAddMinusValue.text = "\(String(describing: self.arrRecentView[indexPath.row].selectedQty ?? 1))"
            
            // check whether add or not
            cell.viewAddBtn.isHidden = arrRecentView[indexPath.row].isSelected == true ?  true : false
            cell.viewAddItems.isHidden = arrRecentView[indexPath.row].isSelected == true ?  false : true
            
            //GIVES TAG TO THE BUTTONS
            cell.btnAdd.tag = indexPath.row
            cell.btnPlus.tag = indexPath.row
            cell.btnMinus.tag = indexPath.row
            
            cell.btnAdd.addTarget(self, action: #selector(btnAddRecentView(sender:)), for: .touchUpInside)
            cell.btnMinus.addTarget(self, action: #selector(minusRecentView(sender:)), for: .touchUpInside)
            cell.btnPlus.addTarget(self, action: #selector(plusRecentView(sender:)), for: .touchUpInside)
            return cell
            
        }  else if (collectionView == self.secondBannerCollectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
            let imgUrl = arrBannerList[indexPath.row].banner_image
            cell.imgView.sd_setImage(with: URL(string: imgUrl!), placeholderImage: UIImage(named: ""))
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewCollectionViewCell", for: indexPath) as! ViewCollectionViewCell
            cell.lblProductName.text = arrMostView[indexPath.row].inventory_name
            cell.lblCategoryName.text = arrMostView[indexPath.row].category_name
            cell.lblPrice.text = "MRP Rs. \(String(describing: arrMostView[indexPath.row].price!))"
            let imgUrl = arrMostView[indexPath.row].category_image
            cell.imgProduct.sd_setImage(with: URL(string: imgUrl ?? ""), placeholderImage: UIImage(named: ""))
            cell.lblAddMinusValue.text = "\(String(describing: self.arrMostView[indexPath.row].selectedQty ?? 1))"
            
            // check whether add or not
            cell.viewAddBtn.isHidden = arrMostView[indexPath.row].isSelected == true ?  true : false
            cell.viewAddItems.isHidden = arrMostView[indexPath.row].isSelected == true ?  false : true
            
            //GIVES TAG TO THE BUTTONS
            cell.btnAdd.tag = indexPath.row
            cell.btnPlus.tag = indexPath.row
            cell.btnMinus.tag = indexPath.row
            
            cell.btnAdd.addTarget(self, action: #selector(btnAddMostView(sender:)), for: .touchUpInside)
            cell.btnMinus.addTarget(self, action: #selector(minusMostView(sender:)), for: .touchUpInside)
            cell.btnPlus.addTarget(self, action: #selector(plusMostView(sender:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.bannerCollectionView {
            return CGSize(width: bannerCollectionView.frame.size.width, height: bannerCollectionView.frame.size.height)
            
        } else if (collectionView == self.merchantCollectnView) {
            let yourWidth = collectionView.bounds.width/3.0
            let yourHeight = yourWidth
            return CGSize(width: yourWidth, height: yourHeight)
            
        } else if (collectionView == self.productsCollectnView) {
            let yourWidth = collectionView.bounds.width/3.0
            let yourHeight = yourWidth
            return CGSize(width: yourWidth, height: yourHeight)
        } else if (collectionView == self.recentlyCollectionView) {
            return CGSize(width: recentlyCollectionView.frame.size.width/2 + 50, height: recentlyCollectionView.frame.size.height)
            
        } else if (collectionView == self.secondBannerCollectionView) {
            return CGSize(width: bannerCollectionView.frame.size.width, height: bannerCollectionView.frame.size.height)
            
        } else {
            return CGSize(width: mostCollectionView.frame.size.width/2 + 50, height: mostCollectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.bannerCollectionView {
            return UIEdgeInsets.zero
        } else if (collectionView == self.merchantCollectnView) {
            return UIEdgeInsets.zero
        } else if (collectionView == self.productsCollectnView) {
            return UIEdgeInsets.zero
        } else if (collectionView == self.recentlyCollectionView) {
            return UIEdgeInsets.zero
        } else if (collectionView == self.secondBannerCollectionView) {
            return UIEdgeInsets.zero
        } else {
            return UIEdgeInsets.zero
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay c: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == self.bannerCollectionView {
            
            currentIndex = indexPath.item
            self.pagingView.currentPage = currentIndex
            
        } else if (collectionView == self.secondBannerCollectionView) {
            
            currentIndex = indexPath.item
            self.secondBannerPageView.currentPage = currentIndex
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.bannerCollectionView {
            return 0
        } else if (collectionView == self.merchantCollectnView) {
            return 0
        } else if (collectionView == self.productsCollectnView) {
            return 0
        } else if (collectionView == self.recentlyCollectionView) {
            return 0
        } else if (collectionView == self.secondBannerCollectionView) {
            return 0
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.bannerCollectionView {
            return 0
        } else if (collectionView == self.merchantCollectnView) {
            return 0
        } else if (collectionView == self.productsCollectnView) {
            return 0
        } else if (collectionView == self.recentlyCollectionView) {
            return 0
        } else if (collectionView == self.secondBannerCollectionView) {
            return 0
        } else {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.productsCollectnView {
            let vc = ENUM_STORYBOARD<SelectCategoryListVC>.tabbar.instantiativeVC()
            vc.categoryID = arrListCategory[indexPath.row].category_id
            //vc.merchantUserID = arrListCategory[indexPath.row].marchent_user_id!
            
            self.navigationController?.pushViewController(vc, animated: true)
            print("Cell Tapped")
        }
            
        else if collectionView == self.merchantCollectnView {
            let vc = ENUM_STORYBOARD<SelectMerchantCategoryVC>.tabbar.instantiativeVC()
            vc.merchantUserID = arrSelectMerchant[indexPath.row].marchent_user_id!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

@available(iOS 13.0, *)
extension CategoriesVC: CLLocationManagerDelegate {
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let coordinate:CLLocationCoordinate2D = manager.location?.coordinate else {return}
      
        self.getAddressFromLatLon(pdblLatitude: "\(coordinate.latitude)", withLongitude: "\(coordinate.longitude)") { (location) in
        self.lblUserCurrentLocation.text = location
            MyCurrentLocation.location = location
        }
    }
}

