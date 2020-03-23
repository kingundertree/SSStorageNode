//
//  SSDataBasedStorage.swift
//  Pods-SSStorageNodeDemo
//
//  Created by ixiazer on 2020/3/20.
//

import Foundation

public class SSDataBasedStorage: SSCodableItemStorage {

    struct PropertyListBox<T: Codable>: Codable {
        let wrapped: T
    }

    func setData(_ data: Data?, forKey key: String) throws {
        fatalError("Unimplemented")
    }

    func data(forKey key: String) throws -> Data? {
        fatalError("Unimplemented")
    }

    public func clear() throws {
        fatalError("Unimplemented")
    }

    public func donotuse_setObject(_ object: Any?, forKey key: String) -> Bool {
        do {
            if let object = object {
                if let data = object as? Data {
                    try setData(data, forKey: key)
                } else {
                    return false
                }
            } else {
                try setData(nil, forKey: key)
            }
            return true
        } catch {
            return false
        }
        
    }
    
    public func donotuse_object(forKey key: String) -> Any? {
        if let data = try? data(forKey: key) {
            return data
        } else {
            return nil
        }
    }

    
    // SSFileStorage
    public func setItem<T>(_ item: T?, forKey key: String) throws where T : Decodable, T : Encodable {
        let data: Data?
        if let value = item {
            if T.self is Data.Type {
                data = (value as! Data)
            } else {
                do {
                    let box = PropertyListBox(wrapped: value)
                    let plistEncoder = PropertyListEncoder()
                    plistEncoder.outputFormat = .binary
                    data = try plistEncoder.encode(box)
                } catch {
                    return
                }
            }
        } else {
            data = nil
        }
        try? setData(data, forKey: key)
    }

    public func item<T>(forKey key: String, as type: T.Type) throws -> T? where T : Decodable, T : Encodable {
        guard let data = try data(forKey: key) else { return nil }
        if T.self is Data.Type {
            return (data as! T)
        } else {
            if let box = try? PropertyListDecoder().decode(PropertyListBox<T>.self, from: data) {
                return box.wrapped
            } else {
                return nil
            }
        }
    }
}
