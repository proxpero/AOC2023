// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Day2",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Day2",
            resources: [.process("Input")]
        ),
    ]
)
