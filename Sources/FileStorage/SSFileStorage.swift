//
//  SSFileStorage.swift
//  Pods-SSStorageNodeDemo
//
//  Created by ixiazer on 2020/3/20.
//

import Foundation

public class SSFileStorage: SSDataBasedStorage, SSHierarchicStorage {

    public convenience init?(accessGroup: String?) {
        let url: URL?
        let fm = FileManager.default
        if let group = accessGroup {
            if let containerURL = fm.containerURL(forSecurityApplicationGroupIdentifier: group) {
                url = containerURL.appendingPathComponent("Applcation Supports")
            } else {
                url = nil
            }
        } else {
            do {
                url = try fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            } catch {
                url = nil
            }
        }
        
        guard let baseURL = url else { return nil }
        
        self.init(baseURL: baseURL)
    }
    
    public func fileURL(withName name: String) -> URL {
        return self.baseURL.appendingPathComponent(name)
    }

    public override func setData(_ data: Data?, forKey key: String) throws {
        do {
            let url = fileURL(withName: key)
            if let data = data {
                try data.write(to: url, withIntermediateDirectories: true)
            } else {
                do {
                   try FileManager.default.removeItem(at: url)
                } catch CocoaError.fileNoSuchFile {
                } catch {
                    throw error
                }
            }
        } catch {
            throw error
        }
    }
    
    public override func data(forKey key: String) throws -> Data? {
        do {
            return try Data(contentsOf: fileURL(withName: key))
        } catch CocoaError.fileReadNoSuchFile {
            return nil
        } catch {
            throw error
        }
    }
    
    public override func clear() throws {
        do {
            let fm = FileManager.default
            let keys: Set<URLResourceKey> = [.isRegularFileKey]
            let contents = try fm.contentsOfDirectory(at: self.baseURL, includingPropertiesForKeys: Array(keys), options: [.skipsHiddenFiles])
            for file in contents {
                guard let attrs = try? file.resourceValues(forKeys: keys), attrs.isRegularFile ?? false else { continue }
                try fm.removeItem(at: file)
            }
        } catch {
            throw error
        }
    }
    
    public typealias Node = SSFileStorage

    public var baseURL: URL
    
    public init?(baseURL: URL) {
        guard baseURL.isFileURL else { return nil }
        self.baseURL = baseURL
    }
    
    private init(uncheckURL: URL) {
        self.baseURL = uncheckURL
    }
    
    public func subStorage(withName name: String) -> SSFileStorage? {
        let url = baseURL.appendingPathComponent(name, isDirectory: true)
        let fm = FileManager.default
        var isDir: ObjCBool = false
        if !fm.fileExists(atPath: url.path, isDirectory: &isDir) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
            }
            return SSFileStorage(uncheckURL: url)
        } else {
            if isDir.boolValue {
                return SSFileStorage(uncheckURL: url)
            } else {
                return nil
            }
        }
    }
    
    public var superStorage: SSFileStorage? {
        let parentURL = baseURL.deletingLastPathComponent()
        if parentURL != self.baseURL {
            return SSFileStorage(uncheckURL: parentURL)
        } else {
            return nil
        }
    }
    
    public func clearHierarchy() throws {
        do {
            let fm = FileManager.default
            let keys: Set<URLResourceKey> = [.isDirectoryKey, .isRegularFileKey]
            let contents = try fm.contentsOfDirectory(at: self.baseURL, includingPropertiesForKeys: Array(keys), options: [.skipsHiddenFiles])
            for file in contents {
                let attrs = try file.resourceValues(forKeys: keys)
                if (attrs.isDirectory ?? false) || (attrs.isRegularFile ?? false) {
                    try fm.removeItem(at: file)
                }
            }
        } catch {
//            LogBridge.shared.buglyLog(error: error as NSError)
            throw error
        }
    }
}

extension Data {
    func write(to url: URL, withIntermediateDirectories createIntermediates: Bool) throws {
        if createIntermediates {
            let fm = FileManager.default
            let parentDirectoryURL = url.deletingLastPathComponent()
            var isDir: ObjCBool = false
            if fm.fileExists(atPath: parentDirectoryURL.path, isDirectory: &isDir) {
                if !isDir.boolValue {
                    let underlyingError = NSError(domain: POSIXError.errorDomain, code: Int(POSIXError.ENOTDIR.rawValue))
                    throw CocoaError.error(.fileWriteUnknown, userInfo: [NSUnderlyingErrorKey: underlyingError], url: url)
                }
            } else {
                try fm.createDirectory(at: parentDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            }
        }
        
        try self.write(to: url)
    }
}
