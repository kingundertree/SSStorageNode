//
//  SSKeychainStorage.swift
//  Pods-SSStorageNodeDemo
//
//  Created by ixiazer on 2020/3/20.
//

import Foundation

public class SSKeychainStorage: SSDataBasedStorage {
    
    public let service: String
    
    public let accessGroup: String?
    
    public init(service: String, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }
    
    public override func setData(_ data: Data?, forKey key: String) throws {
        do {
            let item = SSKeychainDataItem(service: service, account: key, accessGroup: accessGroup)
            if let data = data {
                try item.saveData(data)
            } else {
                _ = try item.deleteItem()
            }
        } catch {
            throw error
        }
    }
    
    public override func data(forKey key: String) throws -> Data? {
        let item = SSKeychainDataItem(service: service, account: key, accessGroup: accessGroup)
        do {
            return try item.readData()
        } catch SSKeychainDataItem.KeychainError.noData {
            return nil
        } catch {
            throw error
        }
    }

    public override func clear() throws {
        do {
            for item in (try SSKeychainDataItem.items(forService: service, accessGroup: accessGroup)) {
                try item.deleteItem()
            }
        } catch {
            throw error
        }
    }
}
