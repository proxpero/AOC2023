// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Day7",
    platforms: [.macOS(.v14)],
    targets: [.executableTarget(name: "Day7", resources: [.process("Input")])]
)
