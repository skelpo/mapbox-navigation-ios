// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "mapbox-navigation-ios",
    defaultLocalization: "da",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "MapboxNavigation", targets: ["MapboxNavigation"]),
        .library(name: "MapboxCoreNavigation", targets: ["MapboxCoreNavigation"])
    ],
    dependencies: [
        .package(name: "Mapbox", url: "git@github.com:skelpo/Mapbox.git", .branch("main")),
        .package(name: "MapboxAccounts", url: "git@github.com:skelpo/MapboxAccounts.git", .branch("main")),
        .package(name: "MapboxNavigationNative", url: "git@github.com:skelpo/MapboxNativeNavigation.git", .branch("main")),
        .package(name: "MapboxMobileEvents", url: "https://github.com/mapbox/mapbox-events-ios.git", from: "0.10.5"),

        .package(url: "https://github.com/skelpo/Solar.git", .branch("master")),
        .package(name: "Turf", url: "https://github.com/mapbox/turf-swift.git", from: "1.0.0"),
        .package(name: "MapboxDirections", url: "https://github.com/mapbox/mapbox-directions-swift.git", from: "1.0.0"),
        .package(name: "MapboxSpeech", url: "https://github.com/mapbox/mapbox-speech-swift.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "NavObjC",
            dependencies: [
                .byName(name: "Mapbox")
            ],
            path: "NavObjC"
        ),
        .target(name: "NavCoreObjC",
            dependencies: [
                .byName(name: "MapboxAccounts")
            ],
            path: "NavCoreObjC"
        ),
        .target(name: "MapboxCoreNavigation",
            dependencies: [
                .byName(name: "Turf"),
                .target(name: "NavCoreObjC"),
                .byName(name: "MapboxAccounts"),
                .product(name: "MapboxDirections", package: "MapboxDirections"),
                .product(name: "MapboxNavigationNative", package: "MapboxNavigationNative"),
                .product(name: "MapboxMobileEvents", package: "MapboxMobileEvents"),
            ],
            path: "MapboxCoreNavigation",
            exclude: ["Info.plist"],
            resources: [.process("Resources")]
        ),
        .target(
            name: "MapboxNavigation",
            dependencies: [
                .product(name: "MapboxSpeech", package: "MapboxSpeech"),
                .byName(name: "Solar"),
                .target(name: "MapboxCoreNavigation"),
            ],
            path: "MapboxNavigation",
            exclude: ["Info.plist"],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "MapboxNavigationTests",
            dependencies: [.target(name: "MapboxNavigation")],
            path: "MapboxNavigationTests",
            exclude: [
                "Info.plist",
                "BottomBannerSnapshotTests.swift",
                "FBSnapshotTestCase.swift",
                "InstructionsBannerViewSnapshotTests.swift",
                "LaneTests.swift",
                "ManeuverArrowTests.swift",
                "ManeuverViewTests.swift",
                "RouteControllerSnapshotTests.swift",
                "SimulatedLocationManagerTests.swift",
            ],
            resources: [
                .copy("Fixtures"),
                .copy("ReferenceImages"),
                .copy("ReferenceImages_64"),
                .copy("FailureDiffs")
            ]
        ),
        .testTarget(
            name: "MapboxCoreNavigationTests",
            dependencies: [
                .target(name: "MapboxCoreNavigation"),
                .target(name: "TestHelper"),
            ],
            path: "MapboxCoreNavigationTests",
            exclude: ["CocoaPodsTest", "Info.plist"],
            resources: [.copy("Fixtures")]
        ),
        .testTarget(name: "NavTestsObjC",
            dependencies: [
                .byName(name: "MapboxAccounts"),
                .target(name: "NavObjC"),
            ],
            path: "NavTestsObjC",
            exclude: [
                "CPMapTemplate+MBTestable.h",
                "CPMapTemplate+MBTestable.mm",
            ]
        ),
        .target(name: "TestHelper",
            dependencies: [
                .target(name: "TestHelperObjC"),
                .target(name: "MapboxNavigation"),
            ],
            path: "TestHelper",
            exclude: [
                "Info.plist"
            ],
            resources: [
                .copy("Fixtures"),
                .copy("tiles"),
                .copy("li.tar"),
                .copy("GGPark-to-BernalHeights.route"),
                .copy("UnionSquare-to-GGPark.route"),
                .copy("turn_left.data"),
            ]
        ),
        .target(name: "TestHelperObjC",
            dependencies: [
                .product(name: "MapboxMobileEvents", package: "MapboxMobileEvents"),
            ],
            path: "TestHelperObjC"
        ),
    ]
)
