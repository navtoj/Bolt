// swift-tools-version: 6.0
import PackageDescription

#if TUIST
	import struct ProjectDescription.PackageSettings

	let packageSettings = PackageSettings(
		// Customize the product types for specific package product
		// Default is .staticFramework
		// productTypes: ["Alamofire": .framework,]
		productTypes: [:]
	)
#endif

let package = Package(
	name: "Bolt",
	dependencies: [
		// https://docs.tuist.io/documentation/tuist/dependencies
		.package(url: "https://github.com/bernndr/swift-macros.git", .upToNextMajor(from: "0.1.1")),
		.package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", .upToNextMajor(from: "6.2.0")),
	]
)
