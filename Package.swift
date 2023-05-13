// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "Swarm",
    platforms: [
        .macOS(.v13),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13),
    ],
    products: [
        .executable(
            name: "swarmtool",
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
        ),
        .package(
            url: "https://github.com/PureSwift/Socket",
            branch: "main"
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
            name: "Swarm",
            dependencies: [
                .product(
                    name: "Socket",
                    package: "Socket",
                    condition: .when(platforms: [.macOS, .macCatalyst, .linux, .android])
                )
            ]
        ),
        .testTarget(
            name: "SwarmTests",
            dependencies: ["Swarm"]
        )
    ]
)
