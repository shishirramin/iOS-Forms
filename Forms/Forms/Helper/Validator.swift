//
//  Validator.swift
//  Forms
//
//  Created by shishir on 09/03/20.
//  Copyright © 2020 Shishir. All rights reserved.
//

import UIKit

protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
}

class ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

enum VaildatorFactory {

    static func validatorFor(type: ItemType) -> ValidatorConvertible {
        switch type {
        case .userName: return UserNameValidator()
        case .password: return PasswordValidator()
        case .email: return EmailValidator()
        case .pincode: return NumberValidator()
        case .name: return NameValidator()
        case .phoneNumber: return PhoneNumberValidator()
        case .otp: return OTPValidator()
        }
    }
}

struct UserNameValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count >= 3 else {
            throw ValidationError("Username must contain more than three characters" )
        }
        guard value.count < 18 else {
            throw ValidationError("Username shoudn't conain more than 18 characters" )
        }
        
        do {
            if try NSRegularExpression(pattern: "^[a-z]{1,18}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Invalid username, username should not contain whitespaces, numbers or special characters")
            }
        } catch {
            throw ValidationError("Invalid username, username should not contain whitespaces,  or special characters")
        }
        return value
    }
}

struct NameValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value != "" else {throw ValidationError("Name is Required")}
        guard value.count >= 3 else {
            throw ValidationError("Name must contain more than three characters" )
        }
        guard value.count < 50 else {
            throw ValidationError("Name shoudn't conain more than 50 characters" )
        }
        
        do {
            if try NSRegularExpression(pattern: "^[\\p{L} .'-]+$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Invalid Name")
            }
        } catch {
            throw ValidationError("Invalid Name")
        }
        return value
    }
}


struct PasswordValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value != "" else {throw ValidationError("Password is Required")}
        guard value.count >= 8 else { throw ValidationError("Password must have at least 8 characters") }
        // You can have more validations here
        return value
    }
}

struct NumberValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value != "" else {throw ValidationError("Area code is Required")}
        guard value.count > 0 else { throw ValidationError("Area code is Required") }
        
        do {
            if try NSRegularExpression(pattern: "^[0-9]",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Not a valid Area code")
            }
        } catch {
            throw ValidationError("Not a valid Area code")
        }
        return value
    }
}


struct PhoneNumberValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value != "" else {throw ValidationError("Please enter your 10 digit Phone number")}
//        guard value.count != 10 else { throw ValidationError("Not a valid Phonenumber") }
        
        do {
            if try NSRegularExpression(pattern: "^[0-9]\\d{9}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Please enter your 10 digit phone number")
            }
        } catch {
            throw ValidationError("Not a valid Phone number")
        }
        return value
    }
}

struct OTPValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value != "" else {throw ValidationError("OTP is Required")}
        //        guard value.count != 10 else { throw ValidationError("Not a valid Phonenumber") }
        
        do {
            if try NSRegularExpression(pattern: "^[0-9]\\d{5}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Not a valid OTP")
            }
        } catch {
            throw ValidationError("Not a valid OTP")
        }
        return value
    }
}

struct EmailValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
         guard value != "" else {throw ValidationError("Email is Required")}
        do {
            let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
            if try NSRegularExpression(pattern: emailRegEx, options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Email is not valid")
            }
        } catch {
            throw ValidationError("Email is not valid")
        }
        return value
    }
}

func isValidEmailAddress(emailAddressString: String) -> Bool {
    
    var returnValue = true
    let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    
    do {
        let regex = try NSRegularExpression(pattern: emailRegEx)
        let nsString = emailAddressString as NSString
        let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
        
        if results.count == 0
        {
            returnValue = false
        }
        
    } catch let error as NSError {
        print("invalid regex: \(error.localizedDescription)")
        returnValue = false
    }
    
    return  returnValue
}
