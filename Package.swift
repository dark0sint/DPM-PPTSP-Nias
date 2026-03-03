// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "DPM-PPTSP-Nias",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 Web Framework
        .package(url: "https://github.com/vapor/vapor.git", from: "4.77.0"),
        // 🍃 Template Engine (Frontend)
        .package(url: "https://github.com/vapor/leaf.git", from: "4.2.4"),
        // 🗄️ Database Driver
        .package(url: "https://github.com/vapor/sqlite-driver.git", from: "4.0.0")
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Leaf", package: "leaf"),
                .product(name: "SQLiteDriver", package: "sqlite-driver")
            ]
        ),
        .testTarget(name: "AppTests", dependencies: [.target(name: "App"), .product(name: "XCTVapor", package: "vapor")]),
    ]
)
