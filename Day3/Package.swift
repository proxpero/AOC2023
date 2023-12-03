// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Day3",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Day3",
            resources: [.process("Input")]
        ),
    ]
)
