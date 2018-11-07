// swift-tools-version:4.2
//
//  PodigeeEmbedKit.swift
//  PodigeeEmbedKit
//
//  Created by Podigee on 23/10/15.
//  Copyright © 2017 podigee. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "PodigeeEmbedKit",
    products: [
        .library(
            name: "PodigeeEmbedKit",
            targets: ["PodigeeEmbedKit"]),
        ],
    dependencies: [],
    targets: [
        .target(
            name: "PodigeeEmbedKit",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "PodigeeEmbedKitTests",
            dependencies: ["PodigeeEmbedKit"],
            path: "Tests")
    ]
)
