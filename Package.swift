// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Yoshi",
    platforms: [.iOS(.v8)],
    products: [
        .library(
            name: "Yoshi",
            type: .static,
            targets: ["Yoshi"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Yoshi",
            dependencies: [],
            path: "Yoshi"
        )
    ]
)
