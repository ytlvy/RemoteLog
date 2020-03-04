//
//  IndexController.swift
//  App
//
//  Created by yanjie guo on 2020/3/4.
//

import Vapor

final class IndexController {
    func greet(_ req: Request) throws -> Future<View> {
       return try req.view().render("index")
    }
    
    func post(_ req: Request) throws -> HTTPStatus {
        
        let text = [req.http.remotePeer.hostname, req.http.body.description].compactMap{$0}.joined(separator: " =-= ")
        try WebSocketManager.sharedInstance.sendToClients(text)
        return HTTPStatus.ok
    }
}

