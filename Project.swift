import ProjectDescription

let name = "Bolt"
let identifier = "com.navtoj." + name.lowercased()

let infoPlist: [String: Plist.Value] = [
	"CFBundleVersion": "1", // Internal
	"CFBundleShortVersionString": "0.0.1", // Public
	"NSHumanReadableCopyright": "Copyright © Navtoj Chahal",
]

let settings: SettingsDictionary = [
	"CODE_SIGN_STYLE": "Automatic", // Manual
	"CODE_SIGN_IDENTITY": "Apple Development", // Mac Developer
	"DEVELOPMENT_TEAM": "FUG9F8QSPW", // grep -r DEVELOPMENT_TEAM *
]

let minimumVersion = DeploymentTargets.macOS("15.7")

let macros = Target.target(
	name: "Macros",
	destinations: .macOS,
	product: .macro,
	bundleId: "\(identifier).macros",
	deploymentTargets: minimumVersion,
	sources: ["Macros/**"],
	dependencies: [
		// .external(name: "SwiftSyntax"),
		.external(name: "SwiftSyntaxMacros"),
		.external(name: "SwiftCompilerPlugin"),
	]
)

let app = Target.target(
	name: name,
	destinations: .macOS,
	product: .app,
	bundleId: identifier,
	deploymentTargets: minimumVersion,
	infoPlist: .extendingDefault(with: infoPlist.merging([
		"LSApplicationCategoryType": "public.app-category.productivity",
		"NSMainStoryboardFile": "",
		"LSUIElement": true,
	], uniquingKeysWith: { _, new in new })),
	sources: ["App/Sources/**"],
	resources: ["App/Resources/**"],
	entitlements: .dictionary([
		"com.apple.security.app-sandbox": false,
	]),
	dependencies: [
		.target(macros),
//		.external(name: "SwiftMacros"),
		.external(name: "SFSafeSymbols"),
		.external(name: "LaunchAtLogin"),
	],
	settings: .settings(
		base: [
			"ENABLE_HARDENED_RUNTIME": true,
		],
		debug: [
			"PRODUCT_BUNDLE_IDENTIFIER": "\(identifier).debug",
		],
	),
	environmentVariables: [
		"IDEPreferLogStreaming": .environmentVariable(value: "YES", isEnabled: true),
	]
)

let project = Project(
	name: name,
	settings: .settings(base: settings.merging([
		"ENABLE_USER_SCRIPT_SANDBOXING": true,
		"ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": true,
		"ENABLE_MODULE_VERIFIER": true,
		"STRING_CATALOG_GENERATE_SYMBOLS": true,
	], uniquingKeysWith: { _, new in new })),
	targets: [
		app,
		macros,
	],
)
