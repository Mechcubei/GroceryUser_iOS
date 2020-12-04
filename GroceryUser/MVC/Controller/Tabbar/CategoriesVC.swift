//
//  CategoriesVC.swift
//  GroceryUser
//
//  Created by osx on 22/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import SDWebImage

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
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectMerchantCategory()
        self.listCategory()
       // self.setPaging()
        self.bannerList()
        self.recentView()
        self.mostView()
        self.registerNibFileName()
        
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
            self.view.layoutIfNeeded()
            self.productHeight.constant = self.productsCollectnView.contentSize.height
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
            self.recentlyCollectionView.reloadData()
        }
    }
    
    //MARK:- MOST VIEW API
    func mostView() {
   
        let params:[String:Any] = ["":""]
        GetApiResponse.shared.mostView(params: params) { (data:ListCategoryStruct) in
            print(data)
            self.arrMostView = data.data!
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
            
            let fullName = arrSelectMerchant[indexPath.row].first_name! + " " + arrSelectMerchant[indexPath.row].last_name!
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
