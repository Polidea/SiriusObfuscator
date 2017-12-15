// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ObfuscatorTool",
    dependencies: [
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "ObfuscatorTool",
            dependencies: ["ShellOut"]),
        .testTarget(
            name: "ObfuscatorToolTests",
            dependencies: ["ObfuscatorTool"]),
    ]
)

