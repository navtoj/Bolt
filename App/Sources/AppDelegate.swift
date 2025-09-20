import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
	// MARK: Static Properties

	static let shared = AppDelegate()

	// MARK: Properties

	private let status = AppStatus.shared
	private let window = AppWindow.shared

	// MARK: Functions

	func applicationDidFinishLaunching(_: Notification) {
		// Menu Bar

		if let menu = NSApplication.shared.mainMenu,
		   let appMenu = menu.items.first,
		   let submenu = appMenu.submenu
		{
			submenu.addItem(
				withTitle: "About Bolt",
				action: #selector(NSApp.orderFrontStandardAboutPanel(_:)),
				keyEquivalent: "a"
			)

			submenu.addItem(.separator())

			submenu.addItem(
				withTitle: "Quit Bolt",
				action: #selector(NSApp.terminate(_:)),
				keyEquivalent: "q"
			)
		}

		// Show Window

		window.makeKeyAndOrderFront(nil)
	}

	func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
		true
	}
}
