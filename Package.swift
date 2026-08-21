// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "GameCenter",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "GameCenter",
            targets: ["GameCenter"]),
        .library(
            name: "GameCenterObjC",
            targets: ["GameCenterObjC"])
    ],
    targets: [
        .target(
            name: "GameCenterObjC",
            path: "Sources/GameCenterObjC",
            publicHeadersPath: "include"),
        .target(
            name: "GameCenter",
            dependencies: ["GameCenterObjC"],
            path: "Sources/GameCenter")
    ]
)
