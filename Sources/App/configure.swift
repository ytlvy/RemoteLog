import Leaf
import Vapor
import NIOWebSocket

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(LeafProvider())
    
    // You must set the preferred renderer:
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)

    services.register { worker in
        return  LeafErrorMiddleware(environment: worker.environment)
    }

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Use Leaf for rendering views
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    middlewares.use(LeafErrorMiddleware.self)
    services.register(middlewares)
    
    
//    // Configure a SQLite database
//    // Configure a database
//    var databases = DatabasesConfig()
//    // 3
//    let databaseConfig = PostgreSQLDatabaseConfig(
//        hostname: "localhost",
//        port: 5433,
//        username: "gauger",
//        database: "gauger",
//        password: "password"
//    )
//
//    let database = PostgreSQLDatabase(config: databaseConfig)
//    databases.add(database: database, as: .psql)
//    services.register(databases)
//
//    /// Configure migrations
//    var migrations = MigrationConfig()
//    migrations.add(model: User.self, database: .psql)
//    migrations.add(model: Status.self, database: .psql)
//    migrations.add(model: Token.self, database: .psql)
//    migrations.add(migration: AdminUser.self, database: .psql)
//    services.register(migrations)
//
//    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)
//    User.defaultDatabase = DatabaseIdentifier<PostgreSQLDatabase>.psql
//
    let serverConfig = NIOServerConfig.default(hostname: "0.0.0.0", port:19909)
    services.register(serverConfig)
//    let websockets = NIOWebSocketServer.default()
//    websockets.get("socket", use: socketHandler)
//    services.register(websockets, as: WebSocketServer.self)
//
    let wss = NIOWebSocketServer.default()
    wss.get("ws", use: WebSocketManager.sharedInstance.socketHandler)
    // Register our server
    services.register(wss, as: WebSocketServer.self)
}
