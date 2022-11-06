//
//  KeychainWrapper.swift
//  TopRatedMovies
//
//  Created by Андрей Исаев on 06.11.2022.
//

import Foundation

struct KeychainWrapper {
    
    @discardableResult
    static func set(_ value: String?, forKey key: String) -> Bool {
        if let value = value {
            return KeychainWrapper.set(value, forKey: key)
        } else {
            return KeychainWrapper.remove(forKey: key)
        }
    }
    
    static func string(forKey key: String) -> String? {
        var query = KeychainWrapper.genericQuery(key)
        query[kSecReturnAttributes as String] = true
        query[kSecReturnData as String] = true
        
        var item: CFTypeRef?
        
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            return nil
        }
    
        return item
            .flatMap { $0 as? [String: Any] }
            .flatMap { $0[kSecValueData as String] as? Data }
            .flatMap { String(data: $0, encoding: .utf8) }
    }
}

fileprivate extension KeychainWrapper {
    
    static func set(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else {
            return false
        }
        
        var query = KeychainWrapper.genericQuery(key)
        query[kSecValueData as String] = data
        
        let setStatus = SecItemAdd(query as CFDictionary, nil)
        if setStatus == errSecSuccess {
            return true
        } else {
            let attributes = [kSecValueData as String: data]
            let updateStatus = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            return updateStatus == errSecSuccess
        }
    }

    static func remove(forKey key: String) -> Bool {
        let query = KeychainWrapper.genericQuery(key)
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
    
    static func genericQuery(_ key: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key
        ]
    }
}
