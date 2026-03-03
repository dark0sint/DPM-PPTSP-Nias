import Fluent
import Foundation

// Struct untuk menerima input dari Form HTML
struct InfoFormData: Content {
    var title: String
    var content: String
    var category: String
}

// Struct representasi data di Database (Manual mapping karena SQLite driver tertentu)
struct InfoModel {
    var id: Int?
    var title: String
    var content: String
    var category: String
    var createdAt: Date

    init(id: Int? = nil, title: String, content: String, category: String, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.category = category
        self.createdAt = createdAt
    }
}

extension InfoModel: Content { } // Agar bisa di-pass ke Leaf
