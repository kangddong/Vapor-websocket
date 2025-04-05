//
//  ViewController.swift
//  Vapor-websocket-iOS
//
//  Created by 강동영 on 4/6/25.
//

import UIKit

class ChatViewController: UIViewController {
    
    private let textView = UITextView()
    private let textField = UITextField()
    private let sendButton = UIButton(type: .system)
    
    private let socket = WebSocketClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        socket.connect()
        
        // 수신 콜백 등록
        socket.onReceive = { [weak self] message in
            DispatchQueue.main.async {
                self?.appendMessage("서버: \(message)")
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // TextView
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 16)
        view.addSubview(textView)
        
        // TextField
        textField.borderStyle = .roundedRect
        textField.placeholder = "메시지를 입력하세요"
        view.addSubview(textField)
        
        // Send Button
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        view.addSubview(sendButton)
        
        // Layout
        textView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -12),
            
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -8),
            
            sendButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func sendTapped() {
        guard let message = textField.text, !message.isEmpty else { return }
        socket.send(message: message)
        appendMessage("나: \(message)")
        textField.text = ""
    }
    
    private func appendMessage(_ message: String) {
        textView.text.append("\(message)\n")
    }
}


