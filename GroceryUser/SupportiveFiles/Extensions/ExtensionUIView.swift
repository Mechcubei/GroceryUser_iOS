//
//  Extension.swift
//  TestMart
//
//  Created by Amit Garg on 11/02/20.
//  Copyright © 2020 Amit Garg. All rights reserved.
//

import Foundation
import UIKit

extension Date
{
        static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
            var dates: [Date] = []
            var date = fromDate
            
            while date <= toDate {
                dates.append(date)
                guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
                date = newDate
            }
            return dates
        }
        
        func monthAsString() -> String {
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("MMMM")
            return df.string(from: self)
        }
    
//        func toString( dateFormat format  : String ) -> String
//        {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = format
//            return dateFormatter.string(from: self)
//        }
    
    
    func calenderTimeSinceNow() -> String
    {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        let years = components.year!
        let months = components.month!
        let days = components.day!
        let hours = components.hour!
        let minutes = components.minute!
        let seconds = components.second!
        
        if years > 0 {
            return years == 1 ? "1 year ago" : "\(years) years ago"
        } else if months > 0 {
            return months == 1 ? "1 month ago" : "\(months) months ago"
        } else if days >= 7 {
            let weeks = days / 7
            return weeks == 1 ? "1 week ago" : "\(weeks) weeks ago"
        } else if days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        } else if hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        } else if minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        } else {
            return seconds == 1 ? "1 second ago" : "few seconds ago"
        }
    }
}


extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
        self.layer.borderWidth = 8
        self.layer.borderColor = UIColor.white.cgColor
    }
    
}

extension UIView {
    
    func cornerRound(radius:CGFloat = 10, clipBounds:Bool = true){
        self.layer.cornerRadius = radius
        self.clipsToBounds = clipBounds
    }
    func cornerRoundWithBorderColor(radius:CGFloat = 10, clipBounds:Bool = true){
           self.layer.cornerRadius = radius
           self.clipsToBounds = clipBounds
           self.layer.borderColor = UIColor.lightGray.cgColor
           self.layer.borderWidth = 0.3
       }
    
    func roundCorners(corners: UIRectCorner, radius: Int = 8) {
           let maskPath1 = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: corners,
                                        cornerRadii: CGSize(width: radius, height: radius))
           let maskLayer1 = CAShapeLayer()
           maskLayer1.frame = bounds
           maskLayer1.path = maskPath1.cgPath
           layer.mask = maskLayer1
       }
    
    func setBorderWidth(width:CGFloat = 0.5, borderColor:CGColor = UIColor.lightGray.cgColor){
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor
    }
    func setRound() {
        self.layer.cornerRadius = (self.frame.height / 2)
        self.clipsToBounds = true
    }
    
    func setShadow(color:UIColor = .black){
        self.layer.shadowColor = color.withAlphaComponent(0.6).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 1.0
        self.clipsToBounds = false
    }
    
    func addBottomRoundedEdge(desiredCurve: CGFloat?) {
        let offset: CGFloat = self.frame.width / desiredCurve!
        let bounds: CGRect = self.bounds
        
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height / 2.0)
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        // Create the shape layer and set its path
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        
        // Set the newly created shape layer as the mask for the view's layer
        self.layer.mask = maskLayer
    }
    
    func setGradientBackground(colorOne: CGColor ,colorTwo: CGColor, colorThree: CGColor,position:Int = 0,startPoint:CGPoint = CGPoint(x: 0.0, y: 1.0),endPoint:CGPoint = CGPoint(x: 1.0, y: 1.0)){
        //left light right dark color
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne, colorTwo, colorThree]
        gradientLayer.locations = [0.0,0.4,1.0]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: UInt32(position))
    }
    
    func setGradientTwoBackground(colorOne: CGColor, colorThree: CGColor,position:Int = 0,startPoint:CGPoint = CGPoint(x: 0.0, y: 1.0),endPoint:CGPoint = CGPoint(x: 1.0, y: 1.0)){
        //left light right dark color
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne, colorThree]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: UInt32(position))
    }
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
       let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
       let mask = CAShapeLayer()
       mask.path = path.cgPath
       self.layer.mask = mask
     }
    
  func makeBottomShadow( shadowHeight: CGFloat = 5) {
      let shadowPath = UIBezierPath()
      shadowPath.move(to: CGPoint(x: 0, y: bounds.height))
      shadowPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
      shadowPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height + shadowHeight))
      shadowPath.addLine(to: CGPoint(x: 0, y: bounds.height + shadowHeight))
      shadowPath.close()

      layer.shadowColor = UIColor.lightGray.cgColor
      layer.shadowOpacity = 0.5
      layer.masksToBounds = false
      layer.shadowPath = shadowPath.cgPath
      layer.shadowRadius = 2
  }
    
    func addShadow(position:CGSize = CGSize(width: 0, height: 1),color:UIColor = UIColor.black,opacity:Float = 0.2,radius:CGFloat = 5.0) {
         layer.masksToBounds = false
         layer.shadowColor = color.cgColor
         layer.shadowOffset = position
         layer.shadowOpacity = opacity
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowRadius = radius
    }
    func addShadowToCell(){
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.clipsToBounds = true
    }
    
}
extension UITextField {
  func setBottomBorder() {
    self.borderStyle = .none
    self.layer.backgroundColor = UIColor.white.cgColor

    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.lightGray.cgColor
    self.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
    self.layer.shadowOpacity = 1.0
    self.layer.shadowRadius = 0.0
  }
}
extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: size.height - lineWidth, width: size.width, height: lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
extension UIViewController {
    func setUpBackButtonNav() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_arrow_back_128_28226"), style: .plain, target: self, action: #selector(leftBarTap))
        self.navigationController?.isNavigationBarHidden = false
    }
    @objc func leftBarTap() {
        self.navigationController?.popViewController(animated: true)
    }
}
