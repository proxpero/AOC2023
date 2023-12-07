// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Day6",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Day6",
            resources: [.process("Input")]
        ),
    ]
)
