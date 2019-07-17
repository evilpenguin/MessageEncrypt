//
//  MessageEncryptView.swift
//  MessageEncryptExtension
//
//  Created by James Emrich on 7/16/19.
//  Copyright © 2019 Emrich Development. All rights reserved.
//

import UIKit

// MARK: - MessageEncryptViewDelegate

protocol MessageEncryptViewDelegate: NSObjectProtocol {
    func messagesEncryptViewTextViewShouldBeginEditing(_ textView: UITextView)
    func messagesEncryptViewSendMessage(_ message: String)
}

// MARK: - MessageEncryptView

class MessageEncryptView: UIView {
    weak var delegate: MessageEncryptViewDelegate?
    
    public lazy var textField: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.delegate = self;
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 30.0)
        textView.textColor = .white
        textView.returnKeyType = .send
        textView.autocapitalizationType = .sentences
        textView.autocorrectionType = .no
        
        return textView
    }()

    required init?(coder: NSCoder) { super.init(coder: coder) }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.textField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textField.frame = self.bounds
    }
}

// MARK: - MessageEncryptViewTextViewDelegate

typealias MessageEncryptViewTextViewDelegate = MessageEncryptView
extension MessageEncryptViewTextViewDelegate : UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        self.delegate?.messagesEncryptViewTextViewShouldBeginEditing(textView)
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text.containsNewLine) {
            if let message = self.textField.text {
                self.textField.text = nil
                self.delegate?.messagesEncryptViewSendMessage(message)
            }
            
            return false
        }
        
        return true
    }
}
