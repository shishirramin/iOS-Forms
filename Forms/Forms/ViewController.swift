//
//  ViewController.swift
//  Forms
//
//  Created by shishir on 09/03/20.
//  Copyright © 2020 Shishir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel = FormViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        
        tableView.reloadData()
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    func registerTableView() {
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCell(cell: TextFieldTableViewCell.self)
    }
  
    //MARK: - Keyboard Methods
    @objc func keyboardWillChange(notification:Notification)  {
        if let newFrame = (notification.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            
            var insets: UIEdgeInsets = UIEdgeInsets( top: 0, left: 0, bottom: 0, right: 0 )
            
            if tableView.contentInset.bottom == 0 {
                //Show Keyboard
                insets = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height, right: 0 )
            } else {
                //Hide Keyboard -> Reset TableView insets
                 insets = UIEdgeInsets( top: 0, left: 0, bottom: 0, right: 0 )
            }
            
            tableView.contentInset = insets
            tableView.scrollIndicatorInsets = insets
        }
    }
    
}

extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let textFieldCell: TextFieldTableViewCell = tableView.dequeueReuseableCell(for: indexPath)
        textFieldCell.delegate = self
        let item = viewModel.viewModel(atIndexPath: indexPath) as? FormItem
        textFieldCell.update(with: item)
        return textFieldCell
    }
    
}

extension ViewController : TextFieldTableViewCellProtocol {
    
    func didChangeValueInTextField() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
}

