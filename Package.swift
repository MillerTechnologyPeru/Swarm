// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "Swarm",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .executable(
            name: "swarm",
            targets: ["SwarmTool"]
        ),
        .library(
            name: "Swarm",
            targets: ["Swarm"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "1.2.0"
        )
    ],
    targets: [
        .executableTarget(
            name: "SwarmTool",
            dependencies: [
                "Swarm",
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                )
            ]
        ),
        .target(
            name: "Swarm"
        ),
        .testTarget(
            name: "SwarmTests",
            dependencies: ["Swarm"]
        )
    ]
)
