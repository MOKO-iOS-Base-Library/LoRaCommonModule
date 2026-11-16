// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "MKLoRaCommonModule",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "MKLoRaCommonModule",
            targets: ["MKLoRaCommonModule"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/MOKO-iOS-Base-Library/MKBaseModuleLibrary.git", from: "2.2.21"),
        .package(url: "https://github.com/MOKO-iOS-Base-Library/MKCustomUIModule.git", from: "2.1.17"),
    ],
    targets: [
        .target(
            name: "MKLoRaCommonModule",
            dependencies: [
                "MKBaseModuleLibrary",
                "MKCustomUIModule",
            ],
            path: "MKLoRaCommonModule",
            exclude: ["Classes/Vendor"],
            sources: ["Classes"],
            resources: [.process("Assets")],
            publicHeadersPath: "Classes",
            cSettings: [
                .headerSearchPath("Classes"),
                .headerSearchPath("Classes/Common"),
                .headerSearchPath("Classes/Common/Protocol"),
                .headerSearchPath("Classes/Pages"),
                .headerSearchPath("Classes/Views"),
            ],
            linkerSettings: [
                .linkedFramework("UIKit"),
            ]
        )
    ]
)
