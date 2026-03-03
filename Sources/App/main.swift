import App
import Vapor

var env = try Environment.detect()
let app = Application(env)
defer { app.shutdown }

do {
    try app.run()
} catch {
    app.logger.error("\$error)")
    throw error
}
