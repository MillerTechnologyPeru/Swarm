// swift-tools-version: 5.7

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

var package = Package(
    name: "SwarmApp",
    platforms: [
        .iOS("15.2")
    ],
    products: [
        .iOSApplication(
            name: "SwarmApp",
            targets: ["AppModule"],
            bundleIdentifier: "com.colemancda.Swarm",
            teamIdentifier: "4W79SG34MW",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .outgoingNetworkConnections()
            ],
            appCategory: .utilities,
            additionalInfoPlistContentFilePath: "Info.plist"
        )
    ],
    dependencies: [
        .package(url: "https://github.com/MillerTechnologyPeru/Swarm.git", "0.1.0"..<"1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: [
                .product(name: "Swarm", package: "Swarm"),
            ],
            path: "."
        )
    ]
)

// Xcode only settings
#if os(macOS)
package.dependencies[0] = .package(path: "../")
package.platforms = [.iOS("15.0")]
#endif
