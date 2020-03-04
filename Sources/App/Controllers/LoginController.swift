//
//  TestController.swift
//  App
//
//  Created by yanjie guo on 2020/3/4.
//

import Vapor

final class LoginController {
    func login(_ req: Request) throws -> Future<HTTPStatus> {
      return try req.content
        .decode(LoginRequst.self)
        .map(to: HTTPStatus.self) { loginRequest in
            
            print(loginRequest.email)
            print(loginRequest.passwd)
            
            return .ok;
        }
    }
}
