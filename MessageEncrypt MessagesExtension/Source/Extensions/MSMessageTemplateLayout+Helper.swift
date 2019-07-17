//
//  MSMessageTemplateLayout+Helper.swift
//  MessageEncryptExtension
//
//  Created by James Emrich on 7/17/19.
//  Copyright © 2019 Emrich Development. All rights reserved.
//

import Messages

// MARK: - MSMessageTemplateLayoutHelper

typealias MSMessageTemplateLayoutHelper = MSMessageTemplateLayout
extension MSMessageTemplateLayoutHelper {
    // MARK: - Static methods
    public static var templatelayout: MSMessageTemplateLayout {
        let layout = MSMessageTemplateLayout()
        layout.caption = "MessageEncrypt"
        layout.subcaption = "You got something!"
        
        return layout
    }
}

