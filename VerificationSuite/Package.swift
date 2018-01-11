// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VerificationSuite",
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.1.0")
    ],
    targets: [
        .target(
            name: "VerificationSuite",
            dependencies: ["Utility", "ShellOut"]
        ),
        .testTarget(
            name: "VerificationSuiteTests",
            dependencies: ["VerificationSuite"]
        )
    ]
)
