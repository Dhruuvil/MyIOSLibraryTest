// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "MobyRewards",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "MobyRewards",
            targets: ["MobyRewards"]
        ),
    ],
    targets: [
        .target(
            name: "MobyRewards",
            dependencies: [],
            path: "Sources/MobyRewards"
        )
    ]
)
