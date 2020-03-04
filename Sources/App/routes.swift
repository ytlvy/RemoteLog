import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    //Index
    let indexVC = IndexController()
    router.get("", use: indexVC.greet)
    router.post("", use: indexVC.post)
//    router.get { req in
//        return try req.view().render("welcome")
//    }
    
    //
    let netVC = NetworkController()
    router.get("/network", use: netVC.greet)
    router.post("/network", use: netVC.post)
    
    let debugVC = DebugController()
    router.get("/debug", use: debugVC.greet)
    router.post("/debug", use: debugVC.post)
    
//    //Login
//    let loginVC = LoginController()
//    router.post("login", use: loginVC.login)
    
    
    // Says hello
//    router.get("hello", String.parameter) { req -> Future<View> in
//        return try req.view().render("hello", [
//            "name": req.parameters.next(String.self)
//        ])
//    }
}
