//
//  SelectMerchantCategoryVC.swift
//  GroceryUser
//
//  Created by osx on 03/11/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SelectMerchantCategoryVC: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet var collectnView: UICollectionView!
    
    //MARK:- LOCAL VARIABLES
    var merchantUserID:Int?
    var arrListCategory = [ListCategoryStruct2]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibFileName()
        self.listCategory()
        
    }
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        collectnView.register(UINib(nibName: "ProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        
    }
    //MARK:- LIST CATEGORY API
    func listCategory() {
        Loader.shared.showLoader()
        let params:[String:Any] = ["merchant_user_id":merchantUserID!]
        GetApiResponse.shared.listCategory(params: params) { (data:ListCategoryStruct) in
            print(data)
            Loader.shared.stopLoader()
            self.arrListCategory = data.data!
            self.collectnView.reloadData()
        }
    }
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK:- EXTENSION COLLECTION VIEW
@available(iOS 13.0, *)
extension SelectMerchantCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrListCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        let imageUrl = arrListCategory[indexPath.row].category_image
        cell.imgProduct.sd_setImage(with: URL(string: imageUrl!), placeholderImage: UIImage(named: ""))
        cell.lblProductName.text = arrListCategory[indexPath.row].category_name
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
        vc.categoryID = arrListCategory[indexPath.row].category_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
