import Fluent
import FluentSQLiteDriver
import Leaf
import Vapor

public func configure(_ app: Application) async throws {
    // 1. Konfigurasi Database (SQLite)
    app.databases.use(.sqlite(.file("dpm-pptsp.sqlite")), as: .sqlite)

    // 2. Konfigurasi Migrations (Membuat tabel jika belum ada)
    app.migrations.add(CreateInfoTable())
    
    // 3. Konfigurasi View Engine (Leaf)
    app.views.use(.leaf)

    // 4. Serve Static Files (CSS, Gambar)
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // 5. Routing
    try await app.autoMigrate() // Otomatis buat tabel
    try app.register(collection: WebController())
    
    // 6. Konfigurasi Host
    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 8080
}

// Definisi Tabel Database
struct CreateInfoTable: AsyncMigration {
    typealias Database = SQLiteDatabase

    func prepare(on database: Database) async throws {
        try await database.query("""
            CREATE TABLE IF NOT EXISTS infos (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title VARCHAR(255) NOT NULL,
                content TEXT NOT NULL,
                category VARCHAR(50) NOT NULL,
                created_at DATE DEFAULT CURRENT_DATE
            )
        """)
    }

    func revert(on database: Database) async throws {
        try await database.query("DROP TABLE infos")
    }
}
