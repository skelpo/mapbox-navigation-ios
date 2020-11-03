// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "mapbox-navigation-ios",
    defaultLocalization: "da",
    platforms: [
        .macOS(.v10_12), .iOS(.v10), .watchOS(.v4), .tvOS(.v12)
    ],
    products: [
        .library(name: "MapboxNavigation", targets: ["MapboxNavigation"]),
        .library(name: "MapboxCoreNavigation", targets: ["MapboxCoreNavigation"])
    ],
    dependencies: [
        .package(name: "Mapbox", url: "git@github.com:skelpo/Mapbox.git", .branch("main")),
        .package(name: "MapboxCommon", url: "git@github.com:skelpo/MapboxCommon.git", .branch("main")),
        .package(name: "MapboxAccounts", url: "git@github.com:skelpo/MapboxAccounts.git", .branch("main")),
        .package(name: "MapboxNavigationNative", url: "git@github.com:skelpo/MapboxNativeNavigation.git", .branch("main")),

        .package(url: "https://github.com/skelpo/Solar.git", .branch("master")),
        .package(name: "Turf", url: "https://github.com/mapbox/turf-swift.git", from: "1.0.0"),
        .package(name: "MapboxDirections", url: "https://github.com/mapbox/mapbox-directions-swift.git", from: "1.0.0"),
        .package(url: "https://github.com/mapbox/mapbox-speech-swift.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "NavObjC",
            dependencies: ["Mapbox"],
            path: "NavObjC"
        ),
        .target(
            name: "NavTestsObjC",
            dependencies: ["MapboxAccounts"],
            path: "NavTestsObjC"
        ),
        .target(
            name: "NavCoreObjC",
            dependencies: ["MapboxAccounts"],
            path: "NavCoreObjC"
        ),
        .target(
            name: "MapboxCoreNavigation",
            dependencies: [
                "Turf",
                "NavCoreObjC",
                "MapboxAccounts",
                "MapboxDirections",
                "MapboxNavigationNative",
                .product(name: "MapboxMobileEvents", package: "Mapbox")
            ],
            path: "MapboxCoreNavigation",
            exclude: ["Info.plist"],
            resources: [.process("Resources")]
        ),
        .target(
            name: "MapboxNavigation",
            dependencies: ["MapboxCoreNavigation"],
            path: "MapboxNavigation",
            exclude: ["Info.plist"],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "MapboxNavigationTests",
            dependencies: ["MapboxNavigation"],
            path: "MapboxNavigationTests",
            exclude: ["Info.plist"],
            resources: [
                .copy("Fixtures"),
                .copy("ReferenceImages"),
                .copy("ReferenceImages_64"),
                .copy("FailureDiffs")
            ]
        ),
        .testTarget(
            name: "MapboxCoreNavigationTests",
            dependencies: ["MapboxCoreNavigation"],
            path: "MapboxCoreNavigationTests",
            exclude: ["CocoaPodsTest", "Info.plist"],
            resources: [.copy("Fixtures")]
        ),
    ]
)
