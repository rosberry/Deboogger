// swift-tools-version:5.2
import PackageDescription
let package = Package(
    name: "Deboogger",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "Deboogger",
            targets: ["Deboogger"]),
    ],
    targets: [
        .target(
            name: "Deboogger",
            path: "Sources")
    ]
)
