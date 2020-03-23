### 引用
```
pod 'SSStorageNode', :git => 'git@github.com:kingundertree/SSStorageNode.git', :tag => '0.0.1'
```

### 概述
1. swift实现iOS项目常规的业务数据本地化存储
2. 支持按照节点存储，Node+key，2个关键词可以实现数据的存和读
3. 包括UserDefaults、file、Keychain存储

### 核心实现
1. SSStorageNode支持按照节点node初始化，持有SSUserDefaultsStorage、SSFileStorage对象
2. SSUserDefaultsStorage支持按照UserDefaults存储
3. SSFileStorage支持文件存储
4. keychain通过系统的Security.SecItem，进行keychain数据存储读取、移除等基本操作
5. SSStorageNode不持有SSKeychainStorage对象，根据业务需要单独创建即可。因为Keychain是多app间共享数据，场景特殊


### SSNodeStorage 设计核心
1. 实现了节点机制，支持按照节点node读写、删除管理。方便多业务隔离、模块化开发
2. 统一UserDefaults、file、Keychain 3种不同模式的数据统一读写调用
3. SSUserDefaultsStorage、SSFileStorage、SSKeychainStorage、继承SSCodableItemStorage Protocol，结合系统提供读写实现，统一调用api
4. SSKeychainDataItem实现Security.SecItem的基本操作

```
// 存入
func setItem<T: Codable>(_ item: T?, forKey key: String) throws
// 获取
func item<T: Codable>(forKey key: String, as type: T.Type) throws -> T?
```

##### 1.SSUserDefaultsStorage存储机制
1. 基本数据格式(Int、Float、Double、Date、Data、String、Bool)，通过UserDefaults存储本地 
2. 非基本数据，支持Codeable的model，encode转成Data，使用UserDefaults存储本地

```
// UserDefaults写入
open func set(_ value: Any?, forKey defaultName: String)
// UserDefaults移除
open func removeObject(forKey defaultName: String)
```

##### 2.SSFileStorage存储机制
1. 数据转Data存储
```
// 按照url写入data
public func write(to url: URL, options: Data.WritingOptions = []) throws
// 按照路径取data
open func removeItem(at URL: URL) throws
```
##### 3.Keychain存储机制
1. 数据转Data存储
2. SSKeychainDataItem实现Security.SecItem的基本方法

```
// 数据更新
public func SecItemUpdate(_ query: CFDictionary, _ attributesToUpdate: CFDictionary) -> OSStatus
// 数据添加
public func SecItemAdd(_ attributes: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
// 数据删除
public func SecItemDelete(_ query: CFDictionary) -> OSStatus
```
##### 4. SSFileStorage和Keychain存储数据处理
1. Data格式数据直接本地文件存储
2. 非Data格式，支持Codeable的model，encode转成Data，本地文件存储

```
// 支持Codeable 对象转Data
let encoder = PropertyListEncoder()
encoder.outputFormat = .binary
let data = try encoder.encode(i)
defaults.set(data, forKey: identifier)
```

### 调用方法
##### 1. 自定义节点node，基于节点可以按照key+node数据读写、删除。整个节点全量删除等
```
// 自定义节点node
fileprivate lazy var storageNode: SSBaseStorageNode! = {
    return SSBaseStorageNode(name: "SSAppService")
}()
```
##### 2. 目前每个SSBaseStorageNode包括一个SSUserDefaultsStorage和一个SSFileStorage对象，实现UserDefaults和file存储
##### 3. 可以选择UserDefaults和file2种模式

```
// UserDefaults方式
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
```

```
// 文件file方式
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
```
##### 4. keychain读写
```
// keychain方式
let keychainGroup: String = Bundle.main.object(forInfoDictionaryKey: "Keychain Sharing") as? String ?? ""
SSKeychainStorage(service: "*******", accessGroup: keychainGroup.isEmpty ? nil : keychainGroup)

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
```
