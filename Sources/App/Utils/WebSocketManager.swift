//
//  WebSocketManager.swift
//  App
//
//  Created by yanjie guo on 2020/3/4.
//

import Vapor
import WebSocket
import NIOWebSocket

final class WebSocketManager {
    static let sharedInstance = WebSocketManager()
    var clients : [WebSocket]
    
    private init() {
        clients = [];
    }
    
    func socketHandler(_ ws:WebSocket, _ req: Request) throws {
        clients.append(ws)
        ws.onText { ws, text in
            ws.send(text)
        }
    }
    
    func sendToClients(_ text: String) throws {
        for ws in clients {
            ws.send(text)
        }
    }
    
    func setupWebSocket() throws {
        let webUpgrader = HTTPServer.webSocketUpgrader(shouldUpgrade: { (req) -> (HTTPHeaders?) in
            // Returning nil in this closure will reject upgrade
            if req.url.path == "/deny" { return nil }
            // Return any additional headers you like, or just empty
            return [:]
            
        }) { (ws, req) in
            // This closure will be called with each new WebSocket client
            ws.send("Connected")
            ws.onText { ws, string in
                ws.send(string.reversed())
            }
        }
        
        /// Echoes the request as a response.
        struct EchoResponder: HTTPServerResponder {
            /// See `HTTPServerResponder`.
            func respond(to req: HTTPRequest, on worker: Worker) -> Future<HTTPResponse> {
                // Create an HTTPResponse with the same body as the HTTPRequest
                let res = HTTPResponse(body: req.body)
                // We don't need to do any async work here, we can just
                // se the Worker's event-loop to create a succeeded future.
                return worker.eventLoop.newSucceededFuture(result: res)
            }
        }
        
        // Create an EventLoopGroup with an appropriate number
        // of threads for the system we are running on.
        let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        // Make sure to shutdown the group when the application exits.
        defer { try! group.syncShutdownGracefully() }
        
        // Start an HTTPServer using our EchoResponder
        // We are fine to use `wait()` here since we are on the main thread.
        let server = try HTTPServer.start(
            hostname: "localhost",
            port: 19908,
            responder: EchoResponder(),
            upgraders: [webUpgrader],
            on: group
        ).wait()

        // Wait for the server to close (indefinitely).
        try server.onClose.wait()
    }
    
}
