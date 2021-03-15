//
//  OrderDetailVC.swift
//  GroceryUser
//
//  Created by osx on 28/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class OrderDetailVC: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet var ImageCollectionView: UICollectionView!
    @IBOutlet var lblTotalPrice: UILabel!
    
    //MARK:- LOCAL VARIABLES
    var merchantUploadImage = String()
    var totalBill = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(merchantUploadImage)
        
        self.registerNibFileName()
        self.ImageCollectionView.cornerRadius = 20
        self.lblTotalPrice.text = "Rs.\(totalBill)/-"
 
    }
    
    //MARK:- REGISTER NIB FILE NAME
       func registerNibFileName() {
           self.ImageCollectionView.register(UINib(nibName: "OrderImageDetailCell", bundle: nil), forCellWithReuseIdentifier: "OrderImageDetailCell")
       }

    //MARK:- ACTION BUTTONS
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnMakepayment(_ sender: Any) {
    }
    @IBAction func btnDeclined(_ sender: Any) {
    }
}

extension OrderDetailVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderImageDetailCell", for: indexPath) as! OrderImageDetailCell
        
        let imgUrl = merchantUploadImage
        cell.imgView.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: ""))
        cell.imgView.cornerRadius = 20
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ImageCollectionView.frame.size.width/2
        let height = ImageCollectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
