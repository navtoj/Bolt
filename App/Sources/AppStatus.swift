import AppKit
import SFSafeSymbols

// MARK: - AppStatus

final class AppStatus {
	// MARK: Static Properties

	static let shared = AppStatus()

	// MARK: Properties

	private lazy var icon = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	private lazy var menu = NSMenu(title: "Bolt")

	// MARK: Lifecycle

	private init() {
		// Status Item

		if let button = icon.button {
			#if DEBUG
				button.image = NSImage(systemSymbol: .bolt)
			#else
				button.image = NSImage(systemSymbol: .boltFill)
			#endif
		}

		// Status Menu

		icon.menu = setup(ns: menu)
	}
}

// MARK: - Helpers

private extension AppStatus {
	@objc
	func openAbout() {
		if let link = URL(string: "https://github.com/navtoj/Bolt") {
			NSWorkspace.shared.open(link)
		}
	}

	func setup(ns menu: NSMenu) -> NSMenu {
		let about = NSMenuItem(
			title: "About",
			action: #selector(openAbout),
			keyEquivalent: ""
		)
		if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
			#if DEBUG
				let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"
				about.badge = NSMenuItemBadge(string: "\(version).\(build)")
			#else
				about.badge = NSMenuItemBadge(string: version)
			#endif
		}
		about.target = self
		menu.addItem(about)

		let settings = NSMenuItem(
			title: "Settings...",
			action: #selector(AppWindow.shared.open),
			keyEquivalent: ","
		)
		settings.target = AppWindow.shared
		menu.addItem(settings)

		menu.addItem(.separator())

		menu.addItem(
			withTitle: "Quit Bolt",
			action: #selector(NSApp.terminate),
			keyEquivalent: "q"
		)

		return menu
	}
}
