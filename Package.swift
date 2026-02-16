// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SupportAISDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SupportAISDK",
            targets: ["SupportAISDK"]
        ),
    ],
    targets: [
        .target(
            name: "SupportAISDK"
        ),
        .testTarget(
            name: "SupportAISDKTests",
            dependencies: ["SupportAISDK"]
        ),
    ]
)
