//
//  MKTextField.swift
//  MkOtpView
//
//  Created by Mohit Kumar on 8/28/18.
//  Copyright © 2018 Mohit Kumar. All rights reserved.
//

import UIKit

class MKTextField: UITextField {

    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }

}
