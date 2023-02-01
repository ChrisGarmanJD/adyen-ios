// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Adyen",
    defaultLocalization: "en-us",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "Adyen",
            type: .dynamic,
            targets: ["Adyen"]
        ),
        .library(
            name: "AdyenEncryption",
            type: .dynamic,
            targets: ["AdyenEncryption"]
        ),
        .library(
            name: "AdyenSwiftUI",
            type: .dynamic,
            targets: ["AdyenSwiftUI"]
        ),
        .library(
            name: "AdyenActions",
            type: .dynamic,
            targets: ["AdyenActions"]
        ),
        .library(
            name: "AdyenCard",
            type: .dynamic,
            targets: ["AdyenCard"]
        ),
        .library(
            name: "AdyenComponents",
            type: .dynamic,
            targets: ["AdyenComponents"]
        ),
        .library(
            name: "AdyenSession",
            type: .dynamic,
            targets: ["AdyenSession"]
        ),
        .library(
            name: "AdyenDropIn",
            type: .dynamic,
            targets: ["AdyenDropIn"]
        ),
        .library(
            name: "AdyenWeChatPay",
            type: .dynamic,
            targets: ["AdyenWeChatPay"]
        )
    ],
    dependencies: [
        .package(
            name: "Adyen3DS2",
            url: "https://github.com/Adyen/adyen-3ds2-ios",
            .exact(Version(2, 3, 0))
        ),
        .package(
            name: "AdyenNetworking",
            url: "https://github.com/Adyen/adyen-networking-ios",
            .exact(Version(1, 0, 0))
        ),
        .package(
            name: "AdyenWeChatPayInternal",
            url: "https://github.com/Adyen/adyen-wechatpay-ios",
            .exact(Version(2, 1, 0))
        )
    ],
    targets: [
        .target(
            name: "Adyen",
            dependencies: [
                .product(name: "AdyenNetworking", package: "AdyenNetworking")
            ],
            path: "Adyen",
            exclude: [
                "Info.plist",
                "Utilities/Non SPM Bundle Extension" // This is to exclude `BundleExtension.swift` file, since swift packages has different code to access internal resources.
            ]
        ),
        .target(
            name: "AdyenEncryption",
            dependencies: [],
            path: "AdyenEncryption",
            exclude: [
                "Info.plist"
            ]
        ),
        .target(
            name: "AdyenSwiftUI",
            dependencies: [],
            path: "AdyenSwiftUI",
            exclude: [
                "Info.plist"
            ]
        ),
        .target(
            name: "AdyenActions",
            dependencies: [
                .target(name: "Adyen"),
                .product(name: "Adyen3DS2", package: "Adyen3DS2")
            ],
            path: "AdyenActions",
            exclude: [
                "Info.plist",
                "Utilities/Non SPM Bundle Extension" // This is to exclude `BundleExtension.swift` file, since swift packages has different code to access internal resources.
            ]
        ),
        .target(
            name: "AdyenCard",
            dependencies: [
                .target(name: "Adyen"),
                .target(name: "AdyenEncryption")
            ],
            path: "AdyenCard",
            exclude: [
                "Info.plist",
                "Utilities/Non SPM Bundle Extension" // This is to exclude `BundleExtension.swift` file, since swift packages has different code to access internal resources.
            ]
        ),
        .target(
            name: "AdyenComponents",
            dependencies: [
                .target(name: "Adyen"),
                .target(name: "AdyenEncryption")
            ],
            path: "AdyenComponents",
            exclude: ["Info.plist"]
        ),
        .target(
            name: "AdyenSession",
            dependencies: [
                .target(name: "Adyen"),
                .target(name: "AdyenActions")
            ],
            path: "AdyenSession"
        ),
        .target(
            name: "AdyenDropIn",
            dependencies: [
                .target(name: "AdyenCard"),
                .target(name: "AdyenComponents"),
                .target(name: "AdyenActions")
            ],
            path: "AdyenDropIn",
            exclude: ["Info.plist"]
        ),
        .target(
            name: "AdyenWeChatPay",
            dependencies: [
                .product(name: "AdyenWeChatPayInternal", package: "AdyenWeChatPayInternal"),
                .target(name: "AdyenActions")
            ],
            path: "AdyenWeChatPay/WeChatPayActionComponent"
        )
    ]
)
