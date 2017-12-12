import PackageDescription

let package = Package(
  dependencies: [
    .Package(url: "../z", majorVersion: 1),
  ]
)
