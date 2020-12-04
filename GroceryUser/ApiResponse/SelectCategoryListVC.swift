//
//  SelectCategoryListVC.swift
//  GroceryUser
//
//  Created by osx on 03/11/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SelectCategoryListVC: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet var collectnView: UICollectionView!
    
    //MARK:- LOCAL VARIABLES
    var categoryID:Int?
    var arrSelectCategory = [SelectMerchantStruct2]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibFileName()
        self.getMerchants()
        
    }
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        self.tabBarController?.tabBar.isHidden = true
        collectnView.register(UINib(nibName: "ProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        
    }
    
    //MARK:- GET MERCHANTS
    func getMerchants() {
        
        Loader.shared.showLoader()
        let params:[String:Any] = ["category_id":categoryID!]
        GetApiResponse.shared.selectMerchant(params: params) { (data:SelectMerchantStruct) in
            print(data)
            Loader.shared.stopLoader()
            self.arrSelectCategory = data.data!
            self.collectnView.reloadData()
        }
    }
    
    //MARK:- ACTION BUTTON
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK:- EXTENSION COLLECTION VIEW
@available(iOS 13.0, *)
extension SelectCategoryListVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSelectCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        let imageUrl = arrSelectCategory[indexPath.row].image
        cell.imgProduct.sd_setImage(with: URL(string: imageUrl!), placeholderImage: UIImage(named: ""))
        let fullName = arrSelectCategory[indexPath.row].first_name! + " " + arrSelectCategory[indexPath.row].last_name!
        cell.lblProductName.text = fullName
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth
        return CGSize(width: yourWidth, height: yourHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ENUM_STORYBOARD<UploadVC>.tabbar.instantiativeVC()
        vc.categoryID = arrSelectCategory[indexPath.row].category_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
