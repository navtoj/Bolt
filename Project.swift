import ProjectDescription

let project = Project(
    name: "Placeholder",
    targets: [
        .target(
            name: "Placeholder",
            destinations: .macOS,
            product: .app,
            bundleId: "dev.tuist.Placeholder",
            infoPlist: .default,
            sources: ["Placeholder/Sources/**"],
            resources: ["Placeholder/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "PlaceholderTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "dev.tuist.PlaceholderTests",
            infoPlist: .default,
            sources: ["Placeholder/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Placeholder")]
        ),
    ]
)
