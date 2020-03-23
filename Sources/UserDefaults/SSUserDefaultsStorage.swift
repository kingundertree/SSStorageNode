//
//  SSUserDefaultsStorage.swift
//  Pods-SSStorageNodeDemo
//
//  Created by ixiazer on 2020/3/20.
//

import Foundation

public class SSUserDefaultsStorage: NSObject, SSCodableItemStorage, SSHierarchicStorage {
    
    public let defaults: UserDefaults
    
    public let name: String
    
    @objc
    public func identifier(withKey key: String) -> String? {
        guard !key.contains(".") else { return nil }
        return "\(name).\(key)"
    }
    
    public func setItem<T>(_ item: T?, forKey key: String) throws where T : Decodable, T : Encodable {
        guard let identifier = identifier(withKey: key) else { return }
        if let i = item {
            if self.isUserDefaultsAcceptForSwift(type: T.self) {
                defaults.set(item, forKey: identifier)
            } else {
                let encoder = PropertyListEncoder()
                encoder.outputFormat = .binary
                let data = try encoder.encode(i)
                defaults.set(data, forKey: identifier)
            }
        } else {
            defaults.removeObject(forKey: identifier)
        }
    }
    
    private func isUserDefaultsAcceptForSwift(type: Any.Type) -> Bool {
        switch type {
        case is Int8.Type,
             is UInt8.Type,
             is Int16.Type,
             is UInt16.Type,
             is Int32.Type,
             is UInt32.Type,
             is Int.Type,
             is UInt.Type,
             is Int64.Type,
             is UInt64.Type,
             is Float.Type,
             is Double.Type,
             is Bool.Type,
             is String.Type,
             is Data.Type,
             is Date.Type:
            return true
        default:
            return false
        }
    }
    
    public func item<T>(forKey key: String, as type: T.Type) throws -> T? where T : Decodable, T : Encodable {
        guard let identifier = identifier(withKey: key) else { return nil }
        if let obj = defaults.object(forKey: identifier) {
            switch obj {
            case let d as T:
                return d
            case let data as Data:
                let decoder = PropertyListDecoder()
                return try decoder.decode(type, from: data)
            default:
                return nil
            }
        } else {
            return nil
        }
    }
    
    public convenience init?(superStorage: SSUserDefaultsStorage, name: String) {
        guard !name.contains(".") else { return nil }
        self.init(defaults: superStorage.defaults, uncheckedName: "\(superStorage.name).\(name)")
    }
    
    private init(defaults: UserDefaults, uncheckedName: String) {
        self.defaults = defaults
        self.name = uncheckedName
        super.init()
    }
    
    @objc(initWithDefaults:name:)
    public init?(defaults: UserDefaults, name: String) {
        guard !name.contains(".") else { return nil }
        self.defaults = defaults
        self.name = name
        super.init()
    }
    
    public func donotuse_setObject(_ object: Any?, forKey key: String) -> Bool {
        guard let identifier = identifier(withKey: key) else { return false }
        if let obj = object {
            if self.isUserDefaultsAcceptForOC(type: type(of: obj)) {
                defaults.set(obj, forKey: identifier)
                return true
            } else {
                return false
            }
        } else {
            defaults.removeObject(forKey: identifier)
            return true
        }
    }
    
    private func isUserDefaultsAcceptForOC(type: Any.Type) -> Bool {
        switch type {
        case is NSNumber.Type,
             is NSString.Type,
             is NSData.Type,
             is NSDate.Type:
            return true
        default:
            return false
        }
    }
    
    public func donotuse_object(forKey key: String) -> Any? {
        guard let identifier = identifier(withKey: key) else { return nil }
        return defaults.object(forKey: identifier)
    }
    
    public func clear() throws {
        let name = self.name
        let found = defaults.dictionaryRepresentation().keys.lazy.filter { (key) -> Bool in
            if key.hasPrefix(name) {
                let trailing = key[name.endIndex...]
                if trailing.first == ".", !trailing.dropFirst().contains(".") {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        for key in found {
            defaults.removeObject(forKey: key)
        }
    }
    
    public func clearHierarchy() throws {
        let name = self.name
        let found = defaults.dictionaryRepresentation().keys.lazy.filter { (key) -> Bool in
            return key.hasPrefix("\(name).")
        }
        for key in found {
            defaults.removeObject(forKey: key)
        }
    }
    
    public var superStorage: SSUserDefaultsStorage? {
        if let lastDotIndex = name.reversed().index(of: ".") {
            let prefix = name[..<lastDotIndex.base]
            return SSUserDefaultsStorage(defaults: defaults, uncheckedName: String(prefix))
        } else {
            return nil
        }
    }
    
    public func subStorage(withName newName: String) -> SSUserDefaultsStorage? {
        return SSUserDefaultsStorage(superStorage: self, name: newName)
    }
}


