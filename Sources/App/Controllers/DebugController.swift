//
//  DebugController.swift
//  App
//
//  Created by yanjie guo on 2020/3/5.
//

import Vapor

final class DebugController {
    func greet(_ req: Request) throws -> Future<View> {
       return try req.view().render("debug")
    }
    
    func post(_ req: Request) throws -> HTTPStatus {
        
        let text = [req.http.remotePeer.hostname, req.http.body.description].compactMap{$0}.joined(separator: " =-= ")
        try WebSocketManager.sharedInstance.sendToClients(text)
        return HTTPStatus.ok
    }
}
