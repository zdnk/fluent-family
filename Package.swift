// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Family",
    products: [
        .library(
            name: "Family",
            targets: ["Family"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "Family",
            dependencies: ["Vapor", "Fluent"]),
        .testTarget(
            name: "FamilyTests",
            dependencies: ["Family"]),
    ]
)
