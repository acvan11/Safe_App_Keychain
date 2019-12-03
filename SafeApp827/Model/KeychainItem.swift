//
//  KeychainItem.swift
//  SafeApp827
//
//  Created by mac on 9/25/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import Security

struct KeychainItem {
    
    /* Keychain Items are saved in CFDictionary, for keychain items to be accessed later they have 3 main attributes.
     1. Service Name (App Name)
     2. Account Name (Individual Item's name)
     3. Access Group (applications that are allowed to access the keychain)
    */
    
    let service = "SafeApp"
    private(set) var account: String! //getter only is accessible
    
    init(account: String) {
        self.account = account
    }
    
    //MARK: Save
    
    func save(password: String) {
        var item = createKeychainItem()
        let encoded = password.data(using: .utf8) //encode the string to utf8
        
        item[kSecValueData as String] = encoded as AnyObject? //set the value into our keychain
        
        SecItemAdd(item as CFDictionary, nil) //encrypts keychain
        
        print("Saved Item to Keychain")
    }
    
    //MARK: Load/Validate Password
    
    func validate(pass: String) -> Bool {
        
        var item = createKeychainItem()
        
        item[kSecReturnData as String] = kCFBooleanTrue // return item as data
        item[kSecReturnAttributes as String] = kCFBooleanTrue //return attributes of item
        
        var result: AnyObject?
        SecItemCopyMatching(item as CFDictionary, &result) //retrieve item with matching service and account name
        
        guard let returnedItem = result as? [String:AnyObject], //cast result back into dictionary
            let passwordData = returnedItem[kSecValueData as String] as? Data, //retrieve password
            let decoded = String(data: passwordData, encoding: .utf8) else { //decode password
            return false
        }
        
        print("Passcode was successful: \(decoded == pass)")
        return decoded == pass
    }
    
    /* InOut Parameter - Example
     
     static var numbers = [1, 2, 3]
    
    static func modifyInPlace(arr: inout [Int]) {
        arr = [3]
    }
    
    let newNumbers = modifyInPlace(arr: KeychainItem.modifyInPlace(arr: &KeychainItem.numbers))
     */
    
 
    
    //MARK: Helper
    func createKeychainItem() -> [String:AnyObject] {
        
        var item = [String:AnyObject]()
        
        item[kSecClass as String] = kSecClassGenericPassword //this keychain has an encoded password
        item[kSecAttrService as String] = service as AnyObject? //set the service for item
        item[kSecAttrAccount as String] = account as AnyObject? //set the account name for item
        
        return item
    }
    
    
}
