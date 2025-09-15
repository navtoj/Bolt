import AppKit

/// A simple print wrapper that only runs in debug builds.
@inline(__always)
func printd(
	_ items: Any...,
	separator: String = " ",
	terminator: String = "\n"
) {
	#if DEBUG
		print(items, separator: separator, terminator: terminator)
	#endif
}

/// Adds a notification observer and appends it to the provided array for later deinitialization.
func addNotification(
	from centre: NotificationCenter = NotificationCenter.default,
	to observers: inout [NSObjectProtocol],
	for name: Notification.Name,
	action run: ((Notification) -> Void)? = nil
) {
	observers.append(centre.addObserver(
		forName: name,
		object: nil,
		queue: nil,
		using: { notification in
			if let run {
				run(notification)
			} else {
				printd(">", notification.name.rawValue, notification.userInfo ?? "No user info.")
			}
		}
	))
}
