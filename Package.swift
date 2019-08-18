// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SpotKeychain",
    products: [
        .library(
            name: "SpotKeychain",
            targets: ["SpotKeychain"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SpotKeychain",
            dependencies: []),
    ]
)
