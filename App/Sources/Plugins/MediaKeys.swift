import AppKit

final class MediaKeys {
	// MARK: Static Properties

	static let shared = MediaKeys()

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
		// Prevent Music App Launch

		addNotification(
			from: NSWorkspace.shared.notificationCenter,
			to: &observers,
			for: NSWorkspace.willLaunchApplicationNotification
		) { notification in
			if let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
			   app.bundleIdentifier == "com.apple.Music"
			{
				let result = app.forceTerminate()
				printd("Terminated? \(result)", app)
			}
		}
	}
}
