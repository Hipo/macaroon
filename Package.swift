// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Macaroon",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "MacaroonApplication", targets: ["MacaroonApplication"]),
        .library(name: "MacaroonBanner", targets: ["MacaroonBanner"]),
        .library(name: "MacaroonBiometrics", targets: ["MacaroonBiometrics"]),
        .library(name: "MacaroonBottomOverlay", targets: ["MacaroonBottomOverlay"]),
        .library(name: "MacaroonBottomSheet", targets: ["MacaroonBottomSheet"]),
        .library(name: "MacaroonCamera", targets: ["MacaroonCamera"]),
        .library(name: "MacaroonForm", targets: ["MacaroonForm"]),
        .library(name: "MacaroonMap", targets: ["MacaroonMap"]),
        .library(name: "MacaroonMedia", targets: ["MacaroonMedia"]),
        .library(name: "MacaroonMixpanel", targets: ["MacaroonMixpanel"]),
        .library(name: "MacaroonResources", targets: ["MacaroonResources"]),
        .library(name: "MacaroonRouter", targets: ["MacaroonRouter"]),
        .library(name: "MacaroonStorySheet", targets: ["MacaroonStorySheet"]),
        .library(name: "MacaroonSVGImage", targets: ["MacaroonSVGImage"]),
        .library(name: "MacaroonSwiftUI", targets: ["MacaroonSwiftUI"]),
        .library(name: "MacaroonToastUIKit", targets: ["MacaroonToastUIKit"]),
        .library(name: "MacaroonUIKit", targets: ["MacaroonUIKit"]),
        .library(name: "MacaroonURLImage", targets: ["MacaroonURLImage"]),
        .library(name: "MacaroonUserNotifications", targets: ["MacaroonUserNotifications"]),
        .library(name: "MacaroonVendors", targets: ["MacaroonVendors"])
    ],
    dependencies: [
        .package(url: "https://github.com/luximetr/AnyFormatKit.git", .upToNextMajor(from: "2.5.1")),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.0.0")),
        .package(name: "MacaroonUtils", url: "https://github.com/Hipo/macaroon-utils.git", .upToNextMajor(from: "3.0.0")),
        .package(name: "Macaw", url: "https://github.com/exyte/macaw.git", .upToNextMajor(from: "0.9.7")),
        .package(name: "Mixpanel", url: "https://github.com/mixpanel/mixpanel-swift.git", .upToNextMajor(from: "2.10.1")),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1"))
    ],
    targets: [
        .target(name: "MacaroonApplication", dependencies: ["MacaroonUtils"], path: "Sources/MacaroonApplication"),
        .target(name: "MacaroonBanner", dependencies: ["MacaroonUIKit"], path: "Sources/MacaroonBanner"),
        .target(name: "MacaroonBiometrics", dependencies: ["MacaroonUtils"], path: "Sources/MacaroonBiometrics"),
        .target(name: "MacaroonBottomOverlay", dependencies: ["MacaroonUIKit"], path: "Sources/MacaroonBottomOverlay"),
        .target(name: "MacaroonBottomSheet", dependencies: ["MacaroonResources", "MacaroonUIKit"], path: "Sources/MacaroonBottomSheet"),
        .target(name: "MacaroonCamera", dependencies: ["MacaroonUtils"], path: "Sources/MacaroonCamera"),
        .target(name: "MacaroonForm", dependencies: ["AnyFormatKit", "MacaroonUIKit"], path: "Sources/MacaroonForm"),
        .target(name: "MacaroonMap", dependencies: ["MacaroonRouter"], path: "Sources/MacaroonMap"),
        .target(name: "MacaroonMedia", dependencies: ["MacaroonURLImage"], path: "Sources/MacaroonMedia"),
        .target(name: "MacaroonMixpanel", dependencies: ["MacaroonUtils", "MacaroonVendors", "Mixpanel"], path: "Sources/MacaroonMixpanel"),
        .target(name: "MacaroonResources", dependencies: [], path: "Sources/MacaroonResources"),
        .target(name: "MacaroonRouter", dependencies: ["MacaroonUIKit"], path: "Sources/MacaroonRouter"),
        .target(name: "MacaroonStorySheet", dependencies: ["MacaroonResources", "MacaroonUIKit"], path: "Sources/MacaroonStorySheet"),
        .target(name: "MacaroonSVGImage", dependencies: ["MacaroonURLImage", "Macaw"], path: "Sources/MacaroonSVGImage"),
        .target(name: "MacaroonSwiftUI", dependencies: [], path: "Sources/MacaroonSwiftUI"),
        .target(name: "MacaroonToastUIKit", dependencies: ["MacaroonResources", "MacaroonUIKit"], path: "Sources/MacaroonToastUIKit"),
        .target(name: "MacaroonUIKit", dependencies: ["MacaroonResources", "MacaroonUtils", "SnapKit"], path: "Sources/MacaroonUIKit"),
        .target(name: "MacaroonURLImage", dependencies: ["Kingfisher", "MacaroonUIKit"], path: "Sources/MacaroonURLImage"),
        .target(name: "MacaroonUserNotifications", dependencies: ["MacaroonUtils"], path: "Sources/MacaroonUserNotifications"),
        .target(name: "MacaroonVendors", dependencies: ["MacaroonUtils"], path: "Sources/MacaroonVendors"),
        .testTarget(name: "MacaroonTests", dependencies: ["MacaroonApplication"]),
    ],
    swiftLanguageVersions: [.v5]
)
