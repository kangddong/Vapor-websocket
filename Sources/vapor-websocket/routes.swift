import Vapor

func routes(_ app: Application) throws {
    app.webSocket("echo") { req, ws in
        print("🔌 WebSocket connected")
        
        ws.onText { ws, text in
            print("📩 Received: \(text)")
            ws.send("Echo: \(text)")
        }
        
        ws.onClose.whenComplete { _ in
            print("❌ WebSocket disconnected")
        }
    }
    
    app.get { req async in
        "It works!"
    }
    
    app.get("hello") { req async -> String in
        "Hello, world!"
    }
}
