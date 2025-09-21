import ProjectDescription

let name = "Bolt"
let identifier = "com.navtoj." + name.lowercased()

let infoPlist: [String: Plist.Value] = [
	"CFBundleVersion": "3", // Internal
	"CFBundleShortVersionString": "1.0.2", // Public
	"NSHumanReadableCopyright": "Copyright © Navtoj Chahal",
	"SUFeedURL": "https://navtoj.github.io/Bolt/appcast.xml",
	"SUPublicEDKey": "ZW5EvT7HK6P8ph5KhNCA9z+XsWcEJs77fCOXLGS9lko=",
	"SUEnableAutomaticChecks": true,
	"SUScheduledCheckInterval": 3600,
	"SUVerifyUpdateBeforeExtraction": true,
	"SUDefaultsDomain": "${InfoPlist_SUDefaultsDomain}",
]

let settings: SettingsDictionary = [
	"CODE_SIGN_STYLE": "Automatic", // Manual
	"CODE_SIGN_IDENTITY": "Apple Development", // Mac Developer
	"DEVELOPMENT_TEAM": "FUG9F8QSPW", // grep -r DEVELOPMENT_TEAM *
]

let app = Target.target(
	name: name,
	destinations: .macOS,
	product: .app,
	bundleId: identifier,
	deploymentTargets: .macOS("15.7"),
	infoPlist: .extendingDefault(with: infoPlist.merging([
		"LSApplicationCategoryType": "public.app-category.productivity",
		"NSMainStoryboardFile": "",
		"LSUIElement": true,
		"NSAppleEventsUsageDescription": "Permission to Play / Pause Media",
	], uniquingKeysWith: { _, new in new })),
	sources: ["App/Sources/**"],
	resources: ["App/Resources/**"],
	entitlements: .dictionary([
		"com.apple.security.app-sandbox": false,
		"com.apple.security.automation.apple-events": true,
	]),
	dependencies: [
		.external(name: "SFSafeSymbols"),
		.external(name: "LaunchAtLogin"),
		.external(name: "Defaults"),
		.external(name: "Sparkle"),
	],
	settings: .settings(
		base: [
			"ENABLE_HARDENED_RUNTIME": true,
			"InfoPlist_SUDefaultsDomain": "\(identifier).sparkle",
		],
		debug: [
			"PRODUCT_BUNDLE_IDENTIFIER": "\(identifier).debug",
			"InfoPlist_SUDefaultsDomain": "\(identifier).sparkle.debug",
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
	],
)
