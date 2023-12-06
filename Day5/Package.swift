// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Day5",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Day5",
            resources: [.process("Input")]
        ),
    ]
)
