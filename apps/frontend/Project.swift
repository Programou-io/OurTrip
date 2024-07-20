import ProjectDescription

let project = Project(
    name: "Frontend",
    targets: [
        .target(
            name: "Frontend",
            destinations: .iOS,
            product: .app,
            bundleId: "io.programou.Frontend",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard"
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: []
        ),
        .target(
            name: "FrontendTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.FrontendTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "Frontend")]
        )
    ]
)
