import PackageDescription

let package = Package(
    name: "SwiftCMixed",
    targets: [
        Target(name: "swifty", dependencies: ["see"]),
    ]
)
