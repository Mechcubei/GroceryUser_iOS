//
//  UploadPhotoVC.swift
//  GroceryUser
//
//  Created by osx on 27/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


@available(iOS 13.0, *)
class UploadPhotoVC: UIViewController,ImagePickerDelegate {
    
    //MARK:- OUTLETS
    @IBOutlet var uploadPhotoCollectionView: UICollectionView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnSelectImage: UIButton!
    
    var imagePicker: ImagePicker!
    var arrImg = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.registerNibFileName()
        self.setImage()
        
    }
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        
        self.uploadPhotoCollectionView.register(UINib(nibName: "UploadProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UploadProfileCollectionViewCell")
    }
    
    func setImage() {
        
        self.imgView.isHidden = arrImg.count == 0 ? false : true
  
    }
    
    // imagePi8cker  delegate  methods
    func didSelect(image: UIImage?) {
       // self.imgView.image = image
        
        self.arrImg.append(image!)
        print(arrImg)
        self.imgView.isHidden = true
        self.btnSelectImage.isUserInteractionEnabled = false
        self.uploadPhotoCollectionView.reloadData()
    }

    //MARK:- ACTION BUTTONS
    @IBAction func btnUploadPhoto(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
    
    @IBAction func btnSend(_ sender: Any) {
        self.UploadPhoto()
    }
    @IBAction func btnBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAdd(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
        
    }
    @objc func deleteCell(sender:UIButton) {
        
        
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure, you want to remove this Item", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            
            let i = sender.tag
            self.arrImg.remove(at: i)
            self.uploadPhotoCollectionView.reloadData()
            
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            refreshAlert .dismiss(animated: true, completion: nil)
        }))
        self.present(refreshAlert, animated: true, completion: nil)
        
        
    }
    
    //MARK:- Upload photo
    func UploadPhoto() {
        
        var parameters = [String:Any]()
        parameters = [
            "count":arrImg.count,
            "address":"Sector 76, Sahibzada Ajit Singh Nagar, Punjab 140308",
            "latitude":"30.700238",
            "longitude":"76.702186"
        ]
        
        let headers:[String:String] = [
            "Authorization": createHeaders()
        ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
                        
            // For images
            for i in 0..<self.arrImg.count{
                let imgData = self.arrImg[i].jpegData(compressionQuality: 0.2)!
                let image = i + 1
                multipartFormData.append(imgData, withName: "image_" + "\(image)",fileName:"file.jpg", mimeType: "image/png")
                print("image_" + "\(image)")
            }
            
            // for other paramaters
           for (key, value) in parameters {
            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
           }
            
        },usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
          
          to: "http://134.209.157.211/Carrykoro/public/api/grocery_image",
          method: .post,
          headers: headers
            )
                        
        { (result) in
            switch result {
                
            case .success(let upload, _,_ ):
                
                Loader.shared.showLoader()
                
                upload.uploadProgress(closure: { (progress) in
                    
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response)
                    let data = JSON(response)
                    let status = data["statusCode"].intValue
                    let message = data["message"].string
                                        
                    guard status == 200 else {
                        Utilities.shared.showAlertWithOK(title: "", msg: message ?? "" )
                        return
                    }
                    
                    let dashboardVC = self.navigationController!.viewControllers.filter { $0 is CategoriesVC }.first!
                    self.navigationController!.popToViewController(dashboardVC, animated: true)
                    Loader.shared.stopLoader()
                }
                
               
            case .failure(let encodingError):
                
                print(encodingError)
                
                
            }
        }
    }
}

@available(iOS 13.0, *)
extension UploadPhotoVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadProfileCollectionViewCell", for: indexPath) as! UploadProfileCollectionViewCell
        
        cell.imgView.image = arrImg[indexPath.row]
        cell.btnDeleteCell.tag = indexPath.row
        cell.btnDeleteCell.addTarget(self, action: #selector(deleteCell(sender:)), for: .touchUpInside)
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = uploadPhotoCollectionView.frame.size.width/2
        let height = uploadPhotoCollectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
