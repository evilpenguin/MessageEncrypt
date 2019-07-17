//
//  String+Helper.swift
//  MessageEncryptExtension
//
//  Created by James Emrich on 7/16/19.
//  Copyright © 2019 Emrich Development. All rights reserved.
//

import Foundation

// MARK: - StringHelper

typealias StringHelper = String
extension StringHelper {
    public var decodebase64: String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    public var encodebase6: String {
        return Data(self.utf8).base64EncodedString()
    }
    
    public var containsNewLine: Bool {
        return self.contains("\n")
    }
}
