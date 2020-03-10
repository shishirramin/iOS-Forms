//
//  FormViewModel.swift
//  Forms
//
//  Created by shishir on 09/03/20.
//  Copyright © 2020 Shishir. All rights reserved.
//

import Foundation

extension String {
    
    func validatedText(validationType: ItemType) throws -> String {
        let validator = VaildatorFactory.validatorFor(type: validationType)
        return try validator.validated(self)
    }
    
}
class FormViewModel {
    
    private var formItem : DataSourceModel<FormItem>? = nil
    
    init() {
        var items = [FormItem]()
        
        let name = FormItem(type:.userName)
        name.valueCompletion = {
            [weak self](sender) in
            guard let _ = self else { return}
            guard let theValue = sender as? String else { return}
            name.value = theValue
            name.errorString = nil
        }
        
        items.append(name)
        
        let password = FormItem(type:.password)
        password.valueCompletion = {
            [weak self](sender) in
            guard let _ = self else { return}
            guard let theValue = sender as? String else { return}
            password.value = theValue
            password.errorString = nil
        }
        
        items.append(password)
        
        let pincode = FormItem(type: .pincode)
        pincode.valueCompletion = {
            [weak self](sender) in
            guard let _ = self else { return}
            guard let theValue = sender as? String else { return}
            pincode.value = theValue
            pincode.errorString = nil
        }
        
        items.append(pincode)
        
        formItem = DataSourceModel(result: items)
    }
    
    func isError() -> String? {
        var errorString : String?
        if let theItems = formItem?.getResult() {
            for item in theItems {
                if item.isMandatory == true {
                    do {
                        let string = item.value ?? ""
                        let _ = try string.validatedText(validationType: item.type)
                    } catch(let error) {
                        errorString =  (error as! ValidationError).message
                        item.errorString = errorString
                        break
                    }
                }
            }
        }
        return errorString
    }
    
}

extension FormViewModel : DataSourceProtocol {
    
    func numberOfItems(forSection section: Int) -> Int {
        return formItem?.numberOfItems(forSection: section) ?? 0

    }
    
    func viewModel(atIndexPath indexPath: IndexPath) -> Any? {
        return formItem?.viewModel(atIndexPath: indexPath) ?? 0
    }
}
