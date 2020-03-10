//
//  FormItem.swift
//  Forms
//
//  Created by shishir on 09/03/20.
//  Copyright © 2020 Shishir. All rights reserved.
//

enum ItemType:String {
    case userName
    case password
    case email
    case pincode
    case name
    case phoneNumber
    case otp
    
    
    var maxCharacter : Int {
        let count : Int
        switch self {
        case .pincode,.otp:
            count = 6
        case .phoneNumber:
            count = 10
        default:
            count = 0
        }
        return count
    }
    
    var contentType : UITextContentType? {
        let type : UITextContentType?
        switch self {
        case .userName:
            if #available(iOS 11.0, *) {
                type = .username
            } else {
                type = .none
            }
        case .name:
            type = .name
        case .password:
            if #available(iOS 11.0, *) {
                type = .password
            } else {
                type = .none
            }
        case .email:
            type = .emailAddress
        case .pincode:
            type = .postalCode
        case .phoneNumber:
            type = .telephoneNumber
        case .otp:
            type = nil
        }
        return type
    }
        
        var keyBoardType : UIKeyboardType {
            let type : UIKeyboardType
            switch self {
            case .userName:
                type = .default
            case .name:
                type = .alphabet
            case .password:
                type = .default
            case .email:
                type = .emailAddress
            case .pincode:
                type = .numberPad
            case .phoneNumber:
                type = .numberPad
            case .otp:
                type = .numberPad
            }
            return type
        }
        
        var placeHolder : String {
            let string : String
            switch self {
            case .userName:
                string = "User Name"
            case .name:
                string = "Full Name"
            case .password:
                string = "Password"
            case .email:
                string = "Email"
            case .pincode:
                string = "Area Pincode"
            case .phoneNumber:
                string = "Mobile"
            case .otp:
                string = "OTP"
            }
            return string
        }
        
        var description : String? {
            let string : String?
            switch self {
            case .pincode:
                string = "PIN code can be your company register or correspondence address"
            default:
                string = nil
            }
            return string
        }
}

import UIKit
enum InputType {
    case button
    case textField
}
struct FormItemUIProperties {
    var tintColor = UIColor.red
    var type = InputType.textField
}

class FormItem {
    
    var value: String?
    var type : ItemType
    var errorString : String?
    var valueCompletion: ((Any?) -> Void)?
    
    var isMandatory = true
    
    var uiProperties = FormItemUIProperties()
    var isEditable : Bool
    // MARK: Init
    init(value: String? = nil, type: ItemType,inputType: InputType = .textField,keyboardType :UIKeyboardType = .default,tintColor : UIColor = .red,isEditable:Bool = true) {
        self.type = type
        self.value = value
        self.isEditable = isEditable
        let properties = FormItemUIProperties(tintColor:tintColor, type: inputType)
        self.uiProperties = properties
    }
}

extension FormItem {
    
    var placeHolder : String {
        return type.placeHolder
    }
    
    var description : String? {
        return type.description
    }
    var keyBoardType : UIKeyboardType {
        return type.keyBoardType
    }
    
    var contentType : UITextContentType? {
        return type.contentType
    }
}
