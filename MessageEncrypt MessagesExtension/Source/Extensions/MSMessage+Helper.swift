//
//  MSMessage+Helper.swift
//  MessageEncryptExtension
//
//  Created by James Emrich on 7/16/19.
//  Copyright © 2019 Emrich Development. All rights reserved.
//

import Messages

// MARK: - MSMessageSetData

typealias MSMessageHelper = MSMessage
extension MSMessageHelper {
    // MARK: - Public methods
    
    public class func message(withString string: String) -> MSMessage {
        let convertString = MSMessage._convertString(string)
        let message = MSMessage()
        message.layout = MSMessageTemplateLayout.templatelayout
        message.shouldExpire = true
        message.set(value: convertString, forKey: "message_data")
        
        return message
    }
    
    public func set(value: Any, forKey key: String) {
        self._serialize(data: [key: value])
    }
    
    public func value<T: LosslessStringConvertible>(forKey key: String) -> T? {
        guard let data = self._currentData(),
            let value = data[key] as? T else {
                return nil
        }
        
        return value
    }
    
    // MARK: - Private methods
    
    private class func _convertString(_ string: String) -> String {
        // Add code here to encrypt or encode string
        return string.encodebase6
    }
    
    private func _currentData() -> [String : Any]? {
        guard let url = self.url,
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let queryItems = urlComponents.queryItems, (queryItems.count > 0),
            let data = self._deserialize(jsonText: (queryItems.first?.value)!) else {
                return nil
        }
        
        return data
    }
    
    private func _deserialize(jsonText: String) -> [String : Any]? {
        let jsonData = jsonText.data(using: .utf8)!
        if let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : AnyObject] {
            return jsonResult
        }
        return nil
    }
    
    private func _serialize(data: [String : Any]) {
        var mergedData = data
        
        if var currentData = self._currentData() {
            data.forEach { (key, value) in currentData[key] = value }
            mergedData = currentData
        }
        
        if let json = try? JSONSerialization.data(withJSONObject: mergedData, options: []),
            let jsonText = String(data: json, encoding: .utf8) {
            
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "emrichs.com"
            urlComponents.path = "/"
            urlComponents.queryItems = [URLQueryItem(name: "data", value: jsonText)]
            
            if let url = urlComponents.url {
                self.url = url
            }
        }
    }
}
