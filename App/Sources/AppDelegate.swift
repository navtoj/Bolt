import AppKit
import Sparkle

final class AppDelegate: NSObject, NSApplicationDelegate {
	// MARK: Static Properties

	static let shared = AppDelegate()

	// MARK: Properties

	let updaterController = SPUStandardUpdaterController(
		startingUpdater: true,
		updaterDelegate: nil,
		userDriverDelegate: nil
	)

	private let status = AppStatus.shared
	private let window = AppWindow.shared

	// Plugins

	private let musicPlayer = MusicPlayer.shared

	// MARK: Functions

	func applicationWillFinishLaunching(_: Notification) {
		// Single Instance

		if let id = Bundle.main.bundleIdentifier,
		   NSRunningApplication.runningApplications(withBundleIdentifier: id).count > 1
		{
			print("Another instance is already running.")
			NSApp.terminate(nil)
		}

		// Prevent Window Auto-Launch

		#if DEBUG
			NSApp.setActivationPolicy(.prohibited)
		#endif

		printd(
			"Activation Policy (\(NSApp.activationPolicy().rawValue)) —>",
			"prohibited = \(NSApplication.ActivationPolicy.prohibited.rawValue),",
			"accessory = \(NSApplication.ActivationPolicy.accessory.rawValue),",
			"regular = \(NSApplication.ActivationPolicy.regular.rawValue)",
		)
	}

	func applicationShouldHandleReopen(_ app: NSApplication, hasVisibleWindows: Bool) -> Bool {
		// Handle Dock Tile

		if app.windows
			.filter({ $0.className == AppWindow.shared.className && $0.isVisible })
			.isEmpty
		{
			printd("applicationShouldHandleReopen", NSApp.activationPolicy().rawValue)
			window.open()
		}

		return hasVisibleWindows
	}

	func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
		false
	}
}
