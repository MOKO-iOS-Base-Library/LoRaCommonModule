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
                .headerSearchPath("Classes/Pages/AboutPage"),
                .headerSearchPath("Classes/Pages/AboutPage/Controller"),
                .headerSearchPath("Classes/Pages/AboutPage/Protocol"),
                .headerSearchPath("Classes/Pages/DownlinkPage"),
                .headerSearchPath("Classes/Pages/DownlinkPage/Controller"),
                .headerSearchPath("Classes/Pages/DownlinkPage/Protocol"),
                .headerSearchPath("Classes/Pages/OutdoorFixPage"),
                .headerSearchPath("Classes/Pages/OutdoorFixPage/Controller"),
                .headerSearchPath("Classes/Pages/OutdoorFixPage/Protocol"),
                .headerSearchPath("Classes/Pages/VibrationPage"),
                .headerSearchPath("Classes/Pages/VibrationPage/Controller"),
                .headerSearchPath("Classes/Pages/VibrationPage/Protocol"),
                .headerSearchPath("Classes/Pages/LoRaPage"),
                .headerSearchPath("Classes/Pages/LoRaPage/Controller"),
                .headerSearchPath("Classes/Pages/LoRaPage/Protocol"),
                .headerSearchPath("Classes/Pages/LoRaApplicationPage"),
                .headerSearchPath("Classes/Pages/LoRaApplicationPage/Controller"),
                .headerSearchPath("Classes/Pages/LoRaApplicationPage/Protocol"),
                .headerSearchPath("Classes/Pages/LCGpsFixPage"),
                .headerSearchPath("Classes/Pages/LCGpsFixPage/Controller"),
                .headerSearchPath("Classes/Pages/LCGpsFixPage/Protocol"),
                .headerSearchPath("Classes/Views"),
                .headerSearchPath("Classes/Views/ReportTimePointCell"),
                .headerSearchPath("Classes/Views/TimingModeAddCell"),
                .headerSearchPath("Classes/Pages/PayloadContentPage"),
                .headerSearchPath("Classes/Pages/PayloadContentPage/Controller"),
                .headerSearchPath("Classes/Pages/PayloadContentPage/Protocol"),
                .headerSearchPath("Classes/Pages/DebuggerPage"),
                .headerSearchPath("Classes/Pages/DebuggerPage/Controller"),
                .headerSearchPath("Classes/Pages/DebuggerPage/Protocol"),
                .headerSearchPath("Classes/Pages/LoRaSettingPage"),
                .headerSearchPath("Classes/Pages/LoRaSettingPage/Controller"),
                .headerSearchPath("Classes/Pages/LoRaSettingPage/Protocol"),
                .headerSearchPath("Classes/Views/DebuggerCell"),
                .headerSearchPath("Classes/Views/DebuggerButton"),
            ],
            linkerSettings: [
                .linkedFramework("UIKit"),
            ]
        )
    ]
)
