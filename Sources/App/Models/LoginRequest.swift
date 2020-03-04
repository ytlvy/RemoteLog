//
//  LoginRequest.swift
//  App
//
//  Created by yanjie guo on 2020/3/4.
//

import Vapor

struct LoginRequst : Content{
    var email  : String
    var passwd : String
}
