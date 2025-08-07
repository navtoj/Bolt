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
            sources: ["App/Sources/**"],
            resources: ["App/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "PlaceholderTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "dev.tuist.PlaceholderTests",
            infoPlist: .default,
            sources: ["App/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Placeholder")]
        ),
    ]
)
