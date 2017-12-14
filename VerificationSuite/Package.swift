// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VerificationSuite",
    dependencies: [
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "VerificationSuite",
            dependencies: ["ShellOut"]
        ),
        .testTarget(
            name: "VerificationSuiteTests",
            dependencies: ["VerificationSuite"]
        )
    ]
)
