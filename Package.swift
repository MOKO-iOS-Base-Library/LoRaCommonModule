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
                .headerSearchPath("Classes/Pages/MotionModePage"),
                .headerSearchPath("Classes/Pages/MotionModePage/Controller"),
                .headerSearchPath("Classes/Pages/MotionModePage/Protocol"),
                .headerSearchPath("Classes/Pages/PeriodicModePage"),
                .headerSearchPath("Classes/Pages/PeriodicModePage/Controller"),
                .headerSearchPath("Classes/Pages/PeriodicModePage/Protocol"),
                .headerSearchPath("Classes/Pages/StandbyModePage"),
                .headerSearchPath("Classes/Pages/StandbyModePage/Controller"),
                .headerSearchPath("Classes/Pages/StandbyModePage/Protocol"),
                .headerSearchPath("Classes/Pages/TimeSegmentedModePage"),
                .headerSearchPath("Classes/Pages/TimeSegmentedModePage/Controller"),
                .headerSearchPath("Classes/Pages/TimeSegmentedModePage/Model"),
                .headerSearchPath("Classes/Pages/TimeSegmentedModePage/Protocol"),
                .headerSearchPath("Classes/Pages/TimeSegmentedModePage/View"),
                .headerSearchPath("Classes/Pages/TimingModePage"),
                .headerSearchPath("Classes/Pages/TimingModePage/Controller"),
                .headerSearchPath("Classes/Pages/TimingModePage/Model"),
                .headerSearchPath("Classes/Pages/TimingModePage/Protocol"),
                .headerSearchPath("Classes/Views"),
                .headerSearchPath("Classes/Views/ReportTimePointCell"),
                .headerSearchPath("Classes/Views/TimingModeAddCell"),
            ],
            linkerSettings: [
                .linkedFramework("UIKit"),
            ]
        )
    ]
)
