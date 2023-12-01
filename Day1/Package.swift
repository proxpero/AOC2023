// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Day1",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Day1",
            resources: [.process("Input")]
        ),
    ]
)
