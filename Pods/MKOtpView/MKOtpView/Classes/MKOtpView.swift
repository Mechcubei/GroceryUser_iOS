//
//  MKOtpView.swift
//  MkOtpView
//
//  Created by Mohit Kumar on 8/28/18.
//  Copyright © 2018 Mohit Kumar. All rights reserved.
//

import UIKit



public class MKOtpView: UIView, UITextFieldDelegate {

    private var numberOfDigits : Int!
    private var peddingVertical : CGFloat!
    private var peddingHorizontal : CGFloat!
    public var onFillDigits = {(number:Int) -> () in}
    var cornerRadius:CGFloat!
    var borderColor:UIColor!
    var borderWidth:CGFloat!
    var isSecure:Bool!
    var inputBackgroundColor:UIColor!
    var allowOnlyNumber:Bool!
    var font:UIFont!

    override public  init(frame: CGRect) {
       
        super.init(frame: frame)
        setDefaultValues()

    }
    
    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        setDefaultValues()

    }
    
    private func setDefaultValues() {
        numberOfDigits = 4
        peddingVertical = 5
        peddingVertical = 5
        cornerRadius = 0
        borderColor = UIColor.black
        borderWidth = 0
        isSecure = false
        inputBackgroundColor = UIColor.clear
        font = UIFont.systemFont(ofSize: 15)
    }
    
    public func setNumberOfDigits(numberOfDigits:Int) {
        self.numberOfDigits = numberOfDigits
    }
    
    public func setVerticalPedding(pedding:CGFloat)  {
        self.peddingVertical = pedding
    }
    
    public func setHorizontalPedding(pedding:CGFloat) {
        self.peddingHorizontal = pedding
    }
    
    public func enableSecureEntries() {
        self.isSecure = true;
    }
    
    public func setCornerRadius(radius:CGFloat) {
        self.cornerRadius = radius
    }
    
    public func setBorderColor(borderColor:UIColor) {
        self.borderColor = borderColor
    }
    
    public func setBorderWidth(borderWidth:CGFloat) {
        self.borderWidth = borderWidth
    }
    
    public func setInputBackgroundColor(inputBackgroundColor:UIColor)  {
        self.inputBackgroundColor = inputBackgroundColor
    }
    
    public func render(){
    
        var xCoord:CGFloat = peddingHorizontal
        
        for i in stride(from: 0, to: numberOfDigits, by: 1){
            
            let view:UIView = UIView(frame: CGRect(x: xCoord, y: peddingVertical, width: getInputSize().width, height: getInputSize().height))
            
            view.layer.cornerRadius = self.cornerRadius
            view.layer.borderWidth = self.borderWidth
            view.layer.borderColor = self.borderColor.cgColor
            view.backgroundColor = self.inputBackgroundColor
            
            let textField:MKTextField = MKTextField(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height));
            textField.isSecureTextEntry = isSecure
            textField.tag = i+1
            textField.delegate = self
            textField.textAlignment = .center
            textField.font = font
            textField.keyboardType = .numberPad
            view.addSubview(textField)
            
            self.addSubview(view)
            
            xCoord += view.frame.size.width + peddingHorizontal
        
        }
        
        
        let nextTextField:UITextField?  = self.viewWithTag(1) as? UITextField
        
        if let t = nextTextField{
            t.becomeFirstResponder()
        }
    }
    
    
    func getInputSize() -> CGSize {
        
        let viewWidth:CGFloat = (self.frame.size.width - ((CGFloat)(numberOfDigits+1) * peddingHorizontal)) / CGFloat(numberOfDigits)
        
        let viewHeight:CGFloat = self.frame.size.height - peddingVertical * 2.0
        
        return CGSize(width: viewWidth, height: viewHeight)
    }
    
    
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if (textField.text?.count)!==1  && string.count>0 {
            
            let nexttag = textField.tag + 1
            
            let nextTextField:UITextField?  = self.viewWithTag(nexttag) as? UITextField
            
            if let t = nextTextField{
                t.becomeFirstResponder()
                t.text = string
                
                if(nexttag==numberOfDigits){
                    sendCompletionAlert()
                    t.resignFirstResponder()
                }
            }
            
          
            
            return false
        }
        else if string.count == 0{
            
            let prevtag = textField.tag - 1

            textField.text = ""
            
            let prevTextField:UITextField?  = self.viewWithTag(prevtag) as? UITextField
            
            if let t = prevTextField{
                t.becomeFirstResponder()
            }
            
            return false
        }
        
        return true
    }
    
    func sendCompletionAlert(){
        
        var number:String = ""
        
        for i in stride(from: 1, to: numberOfDigits+1, by: 1){
            
            let textField:UITextField?  = self.viewWithTag(i) as? UITextField

            if let t = textField{
                
                if let value = t.text{
                    number.append(value)
                }
            }
            
        }
        
        onFillDigits(Int(number)!)
    }
}
