//
//  DataSourceViewModel.swift
//  Forms
//
//  Created by shishir on 09/03/20.
//  Copyright © 2020 Shishir. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

protocol  DataSourceProtocol{
    func numberOfItems(forSection section: Int) -> Int
    func viewModel(atIndexPath indexPath : IndexPath) -> Any?
}

class DataSourceModel <T> {
    
    private var result : [T]?
    
    init(result : [T]) {
        self.result = result
    }
    
    func append(items:[T]) {
        result?.append(contentsOf: items)
    }
    
    func reset() {
        self.result?.removeAll(keepingCapacity: false)
    }
    
    func getResult() -> [T]? {
        return result
    }
}

extension DataSourceModel : DataSourceProtocol {
    func numberOfItems(forSection section: Int) -> Int {
        return result?.count ?? 0
    }
    
    func viewModel(atIndexPath indexPath: IndexPath) -> Any? {
        return result?[safe:indexPath.row]
    }
}
