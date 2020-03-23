//
//  SSStorage.swift
//  Pods-SSStorageNodeDemo
//
//  Created by ixiazer on 2020/3/20.
//

import Foundation

@objc
public protocol SSStorage {
    @objc(setObject:forKey:)
    func donotuse_setObject(_ object: Any?, forKey key: String) -> Bool
    
    @objc(objectForKey:)
    func donotuse_object(forKey key: String) -> Any?
    
    func clear() throws
}

public protocol SSHierarchicStorage: SSStorage {
    associatedtype Node: SSStorage
    
    var superStorage: Node? { get }
    
    func subStorage(withName name: String) -> Node?
    
    func clearHierarchy() throws
}


extension SSStorage {
    @discardableResult
    public func clear(key: String) -> Bool {
        return donotuse_setObject(nil, forKey: key)
    }
}
