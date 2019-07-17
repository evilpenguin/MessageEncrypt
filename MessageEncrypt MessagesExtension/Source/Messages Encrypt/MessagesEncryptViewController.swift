//
//  MessagesViewController.swift
//  MessageEncrypt MessagesExtension
//
//  Created by James Emrich on 7/16/19.
//  Copyright © 2019 Emrich Development. All rights reserved.
//

import UIKit
import Messages

// MARK: - MessagesEncryptViewController

class MessagesEncryptViewController: MSMessagesAppViewController {
    private lazy var mainView: MessageEncryptView = {
        let view = MessageEncryptView(frame: .zero)
        view.delegate = self
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.mainView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.mainView.frame = self.view.bounds
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        self.requestPresentationStyle(.compact)
    }
    
    override func didBecomeActive(with conversation: MSConversation) {
        if let message = self.activeConversation?.selectedMessage {
            self._handle(message: message)
        }
    }

    override func willSelect(_ message: MSMessage, conversation: MSConversation) {
        self._handle(message: message)
    }

    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        switch presentationStyle {
        case .compact: break
        case .expanded:
            if self.activeConversation?.selectedMessage == nil {
                self.mainView.textField.becomeFirstResponder()
            }
            
            break
        case .transcript: break
        default: break
        }
    }
    
    // MARK: - Private message
    
    private func _handle(message: MSMessage?) {
        guard let message = message,
              let encodedString: String = message.value(forKey: "message_data"),
              let decodedString = encodedString.decodebase64 else {
                return
        }
        
        self.mainView.textField.text = decodedString
    }
}

// MARK: - MessagesEncryptViewControllerViewDelegate

typealias MessagesEncryptViewControllerViewDelegate = MessagesEncryptViewController
extension MessagesEncryptViewControllerViewDelegate : MessageEncryptViewDelegate {
    func messagesEncryptViewTextViewShouldBeginEditing(_ textView: UITextView) {
        self.requestPresentationStyle(.expanded)
    }
    
    func messagesEncryptViewSendMessage(_ messageString: String) {
        let message = MSMessage.message(withString: messageString)
        self.activeConversation?.send(message, completionHandler: nil)
    }
}
