//
//  TextFieldTableViewCell.swift
//  Forms
//
//  Created by shishir on 09/03/20.
//  Copyright © 2020 Shishir. All rights reserved.
//

import UIKit

protocol FormItemUpdatable {
    func update(with item: FormItem?)
}

protocol TextFieldTableViewCellProtocol:class {
    func didChangeValueInTextField()
}

extension TextFieldTableViewCellProtocol {
    func searchName(number:String?) {

    }
}

class TextFieldTableViewCell: UITableViewCell {
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var secureButton: UIButton!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    var itemViewModel: FormItem?
    weak var delegate : TextFieldTableViewCellProtocol? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField?.delegate = self
        textField?.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        formatView()
        
    }
    
    @objc
    func textFieldDidChanged(_ textField: UITextField) {
        itemViewModel?.valueCompletion?(textField.text)
        configDescriptionLabel()
        delegate?.didChangeValueInTextField()
    }
    
    @objc func doneButtonAction() {
        textField?.resignFirstResponder()
    }
    
    
    func addToolBar() {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.textField.inputAccessoryView = doneToolbar
    }
    
    func formatView() {
        textFieldView?.layer.borderWidth = 1.0
    }
    
    func configDescriptionLabel() {
        if let theErrorString = itemViewModel?.errorString {
            descriptionLabel.text = theErrorString
        } else {
            descriptionLabel.text = itemViewModel?.description
        }
    }
    
    @IBAction func secureButtonAction(_ sender: Any) {
        let button = sender as? UIButton
        button?.isSelected = !(button?.isSelected ?? false)
        textField.isSecureTextEntry = !(button?.isSelected ?? true)
    }
}

extension TextFieldTableViewCell : FormItemUpdatable {
    
    func update(with item: FormItem?) {
        guard let theViewModel = item else {
            fatalError("ItemViewModel nil")
        }
        itemViewModel = item
        placeHolderLabel.text = theViewModel.placeHolder
        
        configDescriptionLabel()
        
        textField.keyboardType = theViewModel.keyBoardType
        textField.textContentType  = theViewModel.contentType ?? .none
        textField.isSecureTextEntry = theViewModel.type == .password
//            = theViewModel.contentType ?? .
        textField.text = theViewModel.value
//        textField.isEnabled = item?.uiProperties.type == .textField
        
        if  textField.keyboardType == UIKeyboardType.numberPad {
            addToolBar()
        } else {
            textField.inputAccessoryView = nil
        }
    }
    
}

extension TextFieldTableViewCell : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if itemViewModel?.uiProperties.type == .textField && itemViewModel?.isEditable == true {
            return true
        } else {
            return false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let maxCount = itemViewModel?.type.maxCharacter ?? 0
        return maxCount == 0 ? true : updatedText.count <= maxCount
    }
}
