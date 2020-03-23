//
//  ViewController.swift
//  SSStorageNodeDemo
//
//  Created by ixiazer on 2020/3/20.
//  Copyright © 2020 FF. All rights reserved.
//

import UIKit
import SSStorageNode

class ViewController: UIViewController {

    fileprivate lazy var storageNode: SSBaseStorageNode! = {
        return SSBaseStorageNode(name: "SSAppService")
    }()
    
    static let willSaveStringKeyDefault = "willSaveStringKeyDefault"
    static let willSaveModelKeyDefault = "willSaveModelKeyDefault"
    static let willSaveStringKey = "willSaveStringKey"
    static let willSaveModelKey = "willSaveModelKey"
    static let willSaveKeyChainKey = "willSaveKeyChainKey"

    var willSaveStringDefault: String? {
        set {
            try? self.storageNode?.defaultStorage?.setItem(newValue, forKey: ViewController.willSaveStringKeyDefault)
        }
        
        get {
            guard let willSaveStringD = try? self.storageNode.defaultStorage?.item(forKey: ViewController.willSaveStringKeyDefault, as: String.self) else {
                return nil
            }
            
            return willSaveStringD
        }
    }
    
    var willSaveModelDefault: UserModel? {
        set {
            try? self.storageNode?.defaultStorage?.setItem(newValue, forKey: ViewController.willSaveModelKeyDefault)
        }
        
        get {
            guard let saveModelD =  try? self.storageNode.defaultStorage?.item(forKey: ViewController.willSaveModelKeyDefault, as: UserModel.self) else {
                return nil
            }
            
            return saveModelD
        }
    }
    
    var willSaveString: String? {
        set {
            try? self.storageNode?.fileStorage?.setItem(newValue, forKey: ViewController.willSaveStringKey)
        }
        
        get {
            guard let willSaveString = try? self.storageNode.fileStorage?.item(forKey: ViewController.willSaveStringKey, as: String.self) else {
                return nil
            }
            
            return willSaveString
        }
    }
    
    var willSaveModel: UserModel? {
        set {
            try? self.storageNode?.fileStorage?.setItem(newValue, forKey: ViewController.willSaveModelKey)
        }
        
        get {
            guard let saveModel =  try? self.storageNode.fileStorage?.item(forKey: ViewController.willSaveModelKey, as: UserModel.self) else {
                return nil
            }
            
            return saveModel
        }
    }

    var keychainStorage : SSKeychainStorage! = {
        let keychainGroup: String = Bundle.main.object(forInfoDictionaryKey: "Keychain Sharing") as? String ?? ""
        return SSKeychainStorage(service: "YA96Z6TJG6", accessGroup: keychainGroup.isEmpty ? nil : keychainGroup)
    }()
    
    
    var keychainStr: String! {
        set {
            try? self.keychainStorage?.setItem(newValue, forKey: ViewController.willSaveKeyChainKey)
        }
        get {
            guard let saveStr = try? self.keychainStorage?.item(forKey: ViewController.willSaveKeyChainKey, as: String.self) else {
                return nil
            }
            return saveStr
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.willSaveStringDefault = "我是一只来自东北的pig default"
        self.willSaveModelDefault = UserModel.init("夏至Default", "0299312949")

        self.willSaveString = "我是一只来自东北的pig"
        self.willSaveModel = UserModel.init("夏至", "0299312949")

        print("self.willSaveStringDefault==>>", self.willSaveStringDefault ?? "test")
        print("self.willSaveModelDefault==>>", self.willSaveModelDefault?.userName ?? "test")
        print("self.willSaveString==>>", self.willSaveString ?? "test")
        print("self.willSaveModel==>>", self.willSaveModel?.userName ?? "test")
        
        clearAllLocalData()

        print("self.willSaveStringDefault==>>", self.willSaveStringDefault ?? "testDefault")
        print("self.willSaveModelDefault==>>", self.willSaveModelDefault?.userName ?? "testDefault")
        print("self.willSaveString==>>", self.willSaveString ?? "remove")
        print("self.willSaveModel==>>", self.willSaveModel?.userName ?? "remove")
    
        self.keychainStr = "one password"
        print("self.keychainStr==>>", self.keychainStr ?? "")
        try? self.keychainStorage.clear()
        print("self.keychainStr==>>", self.keychainStr ?? "")
    }
    
    func clearAllLocalData() {
        // 按照node删除
        try? self.storageNode?.clearHierarchy()
        // 全部删除
        try? self.storageNode?.clear()
    }
}


class UserModel: Codable {
    var userName: String?
    var userId: String?
    
    init(_ name: String, _ id: String) {
        self.userName = name
        self.userId = id
    }
}

