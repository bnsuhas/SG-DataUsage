//
//  UserDefaultsMock.swift
//  SG-DataUsageTests
//
//  Created by Suhas BN on 12/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import Foundation

class UserDefaultsMock: UserDefaults {
    
    override func object(forKey defaultName: String) -> Any? {
        let encodedData = "YnBsaXN0MDDUAQIDBAUGGxxYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKYHCBESExRVJG51bGzUCQoLDA0ODxBfEBV2b2x1bWVfb2ZfbW9iaWxlX2RhdGFTX2lkV3F1YXJ0ZXJWJGNsYXNzgAOAAoAEgAVRMVcxMjMuNDU2VzIwMTQtUTHSFRYXGFokY2xhc3NuYW1lWCRjbGFzc2VzXxAhU0dfRGF0YVVzYWdlLlF1YXJ0ZXJseVVzYWdlUmVjb3JkohkaXxAhU0dfRGF0YVVzYWdlLlF1YXJ0ZXJseVVzYWdlUmVjb3JkWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hpdmVy0R0eVHJvb3SAAQAIABEAGgAjAC0AMgA3AD4ARABNAGUAaQBxAHgAegB8AH4AgACCAIoAkgCXAKIAqwDPANIA9gD/AREBFAEZAAAAAAAAAgEAAAAAAAAAHwAAAAAAAAAAAAAAAAAAARs="
        
        return Data.init(base64Encoded: encodedData)
    }
    
    override func set(_ value: Any?, forKey defaultName: String) {
        return
    }
    
    override func synchronize() -> Bool {
        return true
    }
}
