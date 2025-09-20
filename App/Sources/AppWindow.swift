import SwiftUI

// MARK: - AppWindow

final class AppWindow: NSWindow {
	// MARK: Static Properties

	static let shared = AppWindow()

	// MARK: Properties

	private let hostingView = NSHostingView(rootView: ContentView())

	// MARK: Lifecycle

	private init() {
		super.init(
			contentRect: .zero,
			styleMask: [.titled, .closable, .miniaturizable],
			backing: .buffered,
			defer: true
		)
		title = "Bolt"
		level = .floating
		collectionBehavior = .moveToActiveSpace

		contentView = hostingView
		setContentSize(hostingView.intrinsicContentSize)
		center()

		isReleasedWhenClosed = false
		delegate = self
	}

	// MARK: Overridden Functions

	override func performKeyEquivalent(with event: NSEvent) -> Bool {
		if event.type == .keyDown,
		   event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command,
		   let key = event.charactersIgnoringModifiers
		{
			if key == "w" {
				performClose(nil)
				return true
			} else if key == "q" {
				NSApp.terminate(nil)
				return true
			}
		}

		printd("performKeyEquivalent", event)
		return super.performKeyEquivalent(with: event)
	}

	// MARK: Functions

	@objc
	func open() {
		NSWorkspace.shared.openApplication(at: Bundle.main.bundleURL, configuration: .init()) { _, error in
			if let error { return print(error) }

			DispatchQueue.main.async {
				NSApp.setActivationPolicy(.regular)
				printd("window.open", NSApp.activationPolicy().rawValue)
				self.makeKeyAndOrderFront(nil)
			}
		}
	}
}

// MARK: NSWindowDelegate

extension AppWindow: NSWindowDelegate {
	func windowWillClose(_: Notification) {
		NSApp.setActivationPolicy(.accessory)
		printd("windowWillClose", NSApp.activationPolicy().rawValue)
	}
}
