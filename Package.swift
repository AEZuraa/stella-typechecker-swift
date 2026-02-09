// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StellaSwift",
    
    products: [
        .executable(
            name: "StellaSwift",
            targets: ["StellaSwift"]
        )
    ],
    
    dependencies: [
        .package(url: "https://github.com/antlr/antlr4.git", from: "4.13.0")
    ],
    
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "StellaSwift",
            dependencies: [
                .product(name: "Antlr4", package: "antlr4")
            ],
            path: "Sources/StellaSwift",
//            swiftSettings: [
//                // для игнорирования concurrency-варнингов с ANTLR
//                .unsafeFlags([
//                    "-Xfrontend", "-disable-availability-checking",
//                    "-Xfrontend", "-warn-concurrency"
//                ])
//            ]
        )
    ]
)
