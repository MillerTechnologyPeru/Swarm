// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "Swarm",
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
