import Fluent
import Foundation
import Vapor
import SQLite

struct WebController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get(use: index)
        routes.get("layanan", use: layanan)
        routes.get("contact", use: contact)
        
        // Route untuk submit form (Contoh: Pengaduan)
        routes.post("submit-pengaduan", use: submitPengaduan)
    }

    // 1. Halaman Utama (Beranda)
    func index(req: Request) async throws -> View {
        let context = [
            "title": "Beranda - DPM-PPTSP Kabupaten Nias",
            "sambutan": "Selamat Datang di Sistem Informasi DPM-PPTSP Kabupaten Nias.",
            "deskripsi": "Dinas Pemberdayaan Masyarakat dan Pelatihan Tenaga Kerja Perlindungan Tenaga Kerja Kabupaten Nias siap melayani Anda."
        ]
        return try await req.view.render("index", context)
    }

    // 2. Halaman Layanan (Mengambil data dari DB SQLite)
    func layanan(req: Request) async throws -> View {
        var infos: [InfoModel] = []
        
        // Koneksi manual ke SQLite untuk contoh ini
        let db = try SQLiteConnection(.file("dpm-pptsp.sqlite"))
        let rows = try db.prepare("SELECT * FROM infos ORDER BY created_at DESC")
        
        for row in rows {
            let info = InfoModel(
                id: row[0] as? Int64,
                title: row[1] as! String,
                content: row[2] as! String,
                category: row[3] as! String,
                createdAt: Date()
            )
            infos.append(info)
        }
        
        // Jika kosong, kasih data dummy agar tidak error view
        if infos.isEmpty {
            infos.append(InfoModel(title: "Lowongan Kerja", content: "Penerimaan tenaga kerja lokal di perusahaan Batak Sukses", category: "Lowongan"))
            infos.append(InfoModel(title: "Pelatihan", content: "Pelatihan menjahit gratis bulan depan", category: "Pelatihan"))
        }

        return try await req.view.render("layanan", ["infos": infos, "title": "Layanan Publik"])
    }

    // 3. Halaman Kontak
    func contact(req: Request) async throws -> View {
        return try await req.view.render("contact", ["title": "Hubungi Kami"])
    }

    // 4. Logic Submit Form
    func submitPengaduan(req: Request) async throws -> Response {
        let data = try req.content.decode(InfoFormData.self)
        
        let db = try SQLiteConnection(.file("dpm-pptsp.sqlite"))
        let stmt = try db.prepare("INSERT INTO infos (title, content, category) VALUES (?, ?, ?)")
        try stmt.run(data.title, data.content, data.category)
        
        return req.redirect(to: "/layanan?success=true")
    }
}
