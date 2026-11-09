// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ZuZuCore",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [.library(name: "ZuZuCore", targets: ["ZuZuCore"])],
    targets: [
        .target(name: "ZuZuCore", path: "ZuZu/Core"),
        .testTarget(name: "ZuZuCoreTests", dependencies: ["ZuZuCore"], path: "Tests/ZuZuCoreTests")
    ]
)
