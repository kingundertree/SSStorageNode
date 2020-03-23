//
//  SSCodableItemStorage.swift
//  Pods-SSStorageNodeDemo
//
//  Created by ixiazer on 2020/3/20.
//

import Foundation

public protocol SSCodableItemStorage: SSStorage {
    func setItem<T: Codable>(_ item: T?, forKey key: String) throws
    
    func item<T: Codable>(forKey key: String, as type: T.Type) throws -> T?
}


extension SSCodableItemStorage {
    public subscript<T: Codable>(key: String) -> T? {
        if let itemOrNil = try? item(forKey: key, as: T.self) {
            return itemOrNil
        } else {
            return nil
        }
    }
    
    subscript<T: Codable>(key: String, as type: T.Type) -> T? {
        get {
            do {
                return try item(forKey: key, as: type)
            } catch {
                return nil
            }
        }
        set {
            try? setItem(newValue, forKey: key)
        }
    }
}
