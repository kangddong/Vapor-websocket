//
//  WebSocketClient.swift
//  Vapor-websocket-iOS
//
//  Created by 강동영 on 4/6/25.
//


import Foundation

class WebSocketClient {
    private var webSocket: URLSessionWebSocketTask?
    private let url = URL(string: "ws://localhost:8080/echo")! // Vapor 서버 주소
    
    var onReceive: ((String) -> Void)?
    
    func connect() {
        let session = URLSession(configuration: .default)
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
        
        print("🛠️ WebSocket 연결 시도 중...")
        listen()
    }
    
    func send(message: String) {
        let wsMessage = URLSessionWebSocketTask.Message.string(message)
        webSocket?.send(wsMessage) { error in
            if let error = error {
                print("❌ 메시지 전송 실패:", error)
            } else {
                print("📤 메시지 전송됨: \(message)")
            }
        }
    }
    
    private func listen() {
        webSocket?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("📨 받은 메시지: \(text)")
                    self?.onReceive?(text)
                case .data(let data):
                    print("📦 바이너리 데이터 수신됨: \(data)")
                @unknown default:
                    break
                }
                // 계속해서 다음 메시지 수신 대기
                self?.listen()
            case .failure(let error):
                print("❌ 수신 중 오류 발생:", error)
            }
        }
    }
    
    func disconnect() {
        webSocket?.cancel(with: .goingAway, reason: nil)
        print("🔌 WebSocket 연결 종료됨")
    }
}
