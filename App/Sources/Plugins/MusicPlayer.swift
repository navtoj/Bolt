import AppKit
import Defaults

// MARK: - SelectedApp

struct SelectedApp: Codable, Defaults.Serializable {
	let name: String
	let bundleId: String
}

extension Defaults.Keys {
	static let alternativeMusicApp = Key<SelectedApp?>("alternativeMusicApp", default: nil)
}

final class MusicPlayer {
	// MARK: Static Properties

	static let shared = MusicPlayer()

	// MARK: Properties

	private var observers: [NSObjectProtocol] = []

	// MARK: Lifecycle

	deinit {
		for observer in observers {
			NSWorkspace.shared.notificationCenter.removeObserver(observer)
		}
		observers.removeAll()
	}

	private init() {
		// Alternative Music Player

		addNotification(
			from: NSWorkspace.shared.notificationCenter,
			to: &observers,
			for: NSWorkspace.willLaunchApplicationNotification
		) { notification in
			if let alternative = Defaults[.alternativeMusicApp],
			   let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
			   app.bundleIdentifier == "com.apple.Music"
			{
				guard app.forceTerminate() else {
					return printd("Failed to Terminate:", app)
				}

				if !NSWorkspace.shared.runningApplications.contains(where: { $0.bundleIdentifier == alternative.bundleId }) {
					self.launch(app: alternative)
				} else {
					self.toggleMusicPlayback(in: alternative)
				}
			}
		}
	}

	// MARK: Static Functions

	static func isValidApp(bundleId: String) -> Bool {
		let script = """
		tell application id "\(bundleId)"
			try
				player state
				return true
			on error
				return false
			end try
		end tell
		"""
		var error: NSDictionary?
		if let appleScript = NSAppleScript(source: script) {
			let output = appleScript.executeAndReturnError(&error)
			return output.booleanValue
		}
		return false
	}
}

private extension MusicPlayer {
	func launch(app: SelectedApp) {
		guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: app.bundleId) else {
			Defaults[.alternativeMusicApp] = nil
			return print("Could not find \(app.bundleId) bundle.")
		}

		let configuration = NSWorkspace.OpenConfiguration()
		configuration.activates = true

		NSWorkspace.shared.openApplication(at: url, configuration: configuration) { _, error in
			if let error {
				print("Could not launch \(app.bundleId) bundle: \(error.localizedDescription)")
			}
		}
	}

	func toggleMusicPlayback(in app: SelectedApp) {
		if let appleScript = NSAppleScript(source: "tell application \"\(app.name)\" to playpause") {
			var errorDict: NSDictionary?
			appleScript.executeAndReturnError(&errorDict)

			if let error = errorDict {
				print("Could not handle \(app.bundleId) bundle: \(error)")
			}
		}
	}
}
