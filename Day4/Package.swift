// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Day4",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Day4",
            resources: [.process("Input")]
        ),
    ]
)
