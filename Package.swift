// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "AudioPilot",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "AudioPilotCore", targets: ["AudioPilotCore"]),
        .executable(name: "AudioPilot", targets: ["AudioPilot"])
    ],
    targets: [
        .target(
            name: "AudioPilotCore",
            path: "Sources/AudioPilotCore"
        ),
        .executableTarget(
            name: "AudioPilot",
            dependencies: ["AudioPilotCore"],
            path: "Sources/AudioPilot",
            exclude: [
                "Info.plist",
                "AudioPilot.entitlements"
            ]
        ),
        .testTarget(
            name: "AudioPilotTests",
            dependencies: ["AudioPilotCore"],
            path: "Tests/AudioPilotTests"
        )
    ]
)
