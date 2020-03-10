//
//  TableView+App.swift
//  Forms
//
//  Created by shishir on 09/03/20.
//  Copyright © 2020 Shishir. All rights reserved.
//

import UIKit

protocol CellIdentifiable {
    static var cellIdentifier: String { get }
}

extension CellIdentifiable where Self: UITableViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension CellIdentifiable where Self: UITableViewHeaderFooterView {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: CellIdentifiable { }

extension UITableViewHeaderFooterView: CellIdentifiable { }

extension UITableView {
    
    func dequeueReuseableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.cellIdentifier, for: indexPath) as? T else {
            fatalError("Could not find table view cell with identifier \(T.cellIdentifier)")
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func dequeueReuseableCell<T: UITableViewCell>(withIdentifier : String, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: withIdentifier, for: indexPath) as? T else {
            fatalError("Could not find table view cell with identifier \(T.cellIdentifier)")
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func dequeueReuseableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let cell = self.dequeueReusableHeaderFooterView(withIdentifier:  T.cellIdentifier) as? T else {
            fatalError("Could not find table view cell with identifier \(T.cellIdentifier)")
        }
        return cell
    }
    
    
    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(view: T.Type) {
        register(UINib(nibName: view.cellIdentifier, bundle : nil), forHeaderFooterViewReuseIdentifier: view.cellIdentifier)
    }
    
    func registerCell<T: UITableViewCell>(cell: T.Type) {
        register(UINib(nibName: T.cellIdentifier, bundle : nil), forCellReuseIdentifier: T.cellIdentifier)
    }
    
    func registerCell(nibName:String) {
        register(UINib(nibName: nibName, bundle : nil), forCellReuseIdentifier: nibName)
    }
    
    func dequeueReuseableCellForIpad<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.cellIdentifier + "IPad", for: indexPath) as? T else {
            fatalError("Could not find table view cell with identifier \(T.cellIdentifier)")
        }
        return cell
    }
    
    func cellForRow<T: UITableViewCell>(at indexPath: IndexPath) -> T {
        guard let cell = cellForRow(at: indexPath) as? T else {
            fatalError("Could not get cell as type \(T.self)")
        }
        return cell
    }
}
