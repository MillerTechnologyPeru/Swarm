// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "Swarm",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Swarm",
            targets: ["Swarm"]
        ),
    ],
    targets: [
        .target(
            name: "Swarm"
        ),
        .testTarget(
            name: "SwarmTests",
            dependencies: ["Swarm"]
        )
    ]
)
