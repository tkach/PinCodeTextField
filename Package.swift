// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "PinCodeTextField",
    products: [
        .library(name: "PinCodeTextField", targets: ["PinCodeTextField"])
    ],
    targets: [
        .target(name: "PinCodeTextField", dependencies: [], path: "Pod")
    ]
)
