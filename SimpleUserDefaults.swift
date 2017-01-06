//
//  SimpleUserDefaults.swift
//
//  Created by Emily Ivie on 1/6/17.
//  Copyright © 2017 Emily Ivie. 
//
//  Licensed under The MIT License
//  For full copyright and license information, please see http://opensource.org/licenses/MIT
//  Redistributions of files must retain the above copyright notice.
//

import Foundation

/// A simplified way to get/set user defaults.
///
/// Accepts pretty much anything. Always allows and returns an *optional* value.
///
/// Note: **name** parameter should be unique to entire application.
///
/// ## Usage Examples: ##
/// ````
/// var myLocalPreference = SimpleUserDefaults<String>(name: "myLocalPreference", defaultValue: "none")
/// var myLocalImage = SimpleUserDefaults<NSURL>(name: "myLocalImage")
/// var myLocalToken = SimpleUserDefaults<CKServerChangeToken>(name: "myLocalToken")
///
/// let preference: String? = myLocalPreference.invalidateCache().get() // returns "none"
///
/// let changeToken: CKServerChangeToken = tokenFetchedFromCKCompletionBlock
/// myLocalToken.set(changeToken)
public struct SimpleUserDefaults<Type> {
    let name: String
    var value: Type?
    var defaultValue: Type?
    var hasCachedValue: Bool = false
    
    /// Creates a cacheable UserDefaults entry of generic type.
    ///
    /// - Parameter name: The key to use when storing to UserDefaults. Should be unique.
    /// - Parameter defaultValue: A default for when there is no stored data, or stored data is nil.
    public init(name: String, defaultValue: Type? = nil) {
        self.name = name
        self.defaultValue = defaultValue
    }
    
    /// Clears any prior cached values. (Chainable)
    ///
    /// - Returns: this SimpleUserDefaults object
    public mutating func invalidateCache() -> SimpleUserDefaults {
        value = nil
        hasCachedValue = false
        return self
    }
    
    /// Retrieves the current UserDefaults stored value.
    ///
    /// Returns:
    /// 1. The cached value, if found.
    /// 2. The stored UserDefaults value, if found.
    /// 3. The default value, if found.
    /// 4. nil.
    public mutating func get() -> Type? {
        if !hasCachedValue {
            if defaultValue is NSURL {
                hasCachedValue = true
                value = UserDefaults.standard.url(forKey: name) as? Type
            } else if defaultValue is Bool {
                hasCachedValue = true
                value = UserDefaults.standard.bool(forKey: name) as? Type
            } else if defaultValue is Int {
                hasCachedValue = true
                value = UserDefaults.standard.integer(forKey: name) as? Type
            } else if defaultValue is Double {
                hasCachedValue = true
                value = UserDefaults.standard.double(forKey: name) as? Type
            } else if defaultValue is Float {
                hasCachedValue = true
                value = UserDefaults.standard.float(forKey: name) as? Type
            } else if defaultValue is String {
                hasCachedValue = true
                value = UserDefaults.standard.string(forKey: name) as? Type
            } else {
                // we don't always have to archive Array and Dictionary
                // but this is easier
                hasCachedValue = true
                if let data = UserDefaults.standard.object(forKey: name) as? Data {
                    value = (NSKeyedUnarchiver.unarchiveObject(with: data) as? Type)
                }
            }
        }
        return value ?? defaultValue
    }
    
    /// Stores a new value to UserDefaults and caches it locally.
    ///
    /// - Parameter value: The new value to store.
    public mutating func set(_ value: Type?) {
        self.value = value
        hasCachedValue = true
        if defaultValue is NSURL
            || defaultValue is Bool
            || defaultValue is Int 
            || defaultValue is Double
            || defaultValue is Float 
            || defaultValue is String {
            hasCachedValue = true
            if let value = value {
                UserDefaults.standard.set(value, forKey: name)
            } else {
                UserDefaults.standard.set(nil, forKey: name)
            }
        } else {
            hasCachedValue = true
            if let value = value {
                UserDefaults.standard.set(
                    NSKeyedArchiver.archivedData(withRootObject: value),
                    forKey: name
                )
            } else {
                UserDefaults.standard.set(nil, forKey: name)
            }
        }
    }
}

