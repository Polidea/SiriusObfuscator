import PackageDescription

let package = Package(
   name: "Foo",
    dependencies: [
        .Package(url: "../CFoo", majorVersion: 1),
    ]
)
