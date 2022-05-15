// swift-tools-version:5.5.0
import PackageDescription

let package = Package(
    name: "ZveronLibrary",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ZveronLibrary",
            targets: ["Example", "RemoteDataService"])
    ],
    dependencies: [
        .package(name: "SnapKit", url: "https://github.com/SnapKit/SnapKit", from: Version(5, 0, 0)),
        .package(name: "BottomSheet", url: "https://github.com/joomcode/BottomSheet", branch: "main"),
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire", from: Version(5, 5, 0)),
        .package(name: "InputMask", url: "https://github.com/RedMadRobot/input-mask-ios", from: Version(6, 0, 0)),
        .package(name: "Kingfisher", url: "https://github.com/onevcat/Kingfisher", from: Version(7,0,0))
    ],
    targets: [
        .target(name: "Example", dependencies: ["BottomSheet", "SnapKit", "Alamofire", "InputMask", "Kingfisher"]),
        .target(name: "RemoteDataService", dependencies: ["Alamofire"])
    ]
)
