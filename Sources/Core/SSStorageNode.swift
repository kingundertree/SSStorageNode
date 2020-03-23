//
//  SSStorageNode.swift
//  Pods-SSStorageNodeDemo
//
//  Created by ixiazer on 2020/3/20.
//

import Foundation

@objc
public class SSStorageNode: NSObject {
    
    @objc
    public var name: String { fatalError() }
    
    @objc(ocDefaultStorage)
    public var __objective_c_interface__defaultStorage: SSStorage? { return self.defaultStorage }
    public var defaultStorage: SSUserDefaultsStorage? { fatalError() }
    
    @objc(ocFileStorage)
    public var __objective_c_interface__fileStorage: SSStorage? { return self.fileStorage }
    public var fileStorage: SSFileStorage? { fatalError() }
    
    @objc(ocChildNodeWithName:)
    public func __objective_c_interface__childNode(withName name: String) -> SSStorageNode? {
        return self.childNode(withName: name)
    }
    public func childNode(withName name: String) -> SSBaseStorageNode { fatalError() }
    
    @objc
    public func clear() throws {
        try self.defaultStorage?.clear()
        try self.fileStorage?.clear()
    }
    
    @objc
    public func clearHierarchy() throws {
        try self.defaultStorage?.clearHierarchy()
        try self.fileStorage?.clearHierarchy()
    }
}

public class SSBaseStorageNode: SSStorageNode {
    
    private let _name: String
    public override var name: String { return self._name }
    
    // UserDefaults方式存储
    private let _defaultStorage: SSUserDefaultsStorage?
    public override var defaultStorage: SSUserDefaultsStorage? { return self._defaultStorage }
    
    // 本地file存储
    private let _fileStorage: SSFileStorage?
    public override var fileStorage: SSFileStorage? { return self._fileStorage }
    
    public override func childNode(withName name: String) -> SSBaseStorageNode {
        let subDefaultsStorage = self._defaultStorage?.subStorage(withName: name)
        let subFileStorage = self._fileStorage?.subStorage(withName: name)
        return SSBaseStorageNode(
            name: name,
            defaultsStorage: subDefaultsStorage,
            fileStorage: subFileStorage
        )
    }
    
    public convenience init(name: String, accessGroup: String? = nil) {
        let defaultStorage = UserDefaults(suiteName: accessGroup).flatMap { SSUserDefaultsStorage(defaults: $0, name: name) }
        let fileStorage = SSFileStorage(accessGroup: accessGroup)
        self.init(name: name, defaultsStorage: defaultStorage, fileStorage: fileStorage)
    }
    
    init(name: String, defaultsStorage: SSUserDefaultsStorage?, fileStorage: SSFileStorage?) {
        self._name = name
        self._defaultStorage = defaultsStorage
        self._fileStorage = fileStorage
    }
}
