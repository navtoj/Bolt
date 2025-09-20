import Defaults
import LaunchAtLogin
import SwiftUI

struct ContentView: View {
	// MARK: Properties

	@Default(.alternativeMusicApp) var alternativeMusicApp

	@State private var alternativeMusicAppError: String?

	// MARK: Content Properties

	var body: some View {
		VStack(alignment: .leading) {
			LaunchAtLogin.Toggle("Open at Login")

			Divider()
				.padding(.vertical, 4)
			VStack(alignment: .leading) {
				Text("Alternative Music Player")
					.font(.headline)
					.padding(.bottom, 2)

				HStack {
					Button {
						let panel = NSOpenPanel()
						panel.allowedContentTypes = [.application]
						panel.allowsMultipleSelection = false
						panel.canChooseDirectories = false
						panel.canChooseFiles = true
						panel.begin { response in
							guard response == .OK, let url = panel.url else { return }

							if let bundle = Bundle(url: url),
							   let bundleId = bundle.bundleIdentifier
							{
								let name = bundle.infoDictionary?["CFBundleDisplayName"] as? String
									?? bundle.infoDictionary?["CFBundleName"] as? String
									?? url.deletingPathExtension().lastPathComponent

								if MusicPlayer.isValidApp(bundleId: bundleId) {
									alternativeMusicApp = SelectedApp(
										name: name,
										bundleId: bundleId
									)
									alternativeMusicAppError = nil
								} else {
									alternativeMusicAppError = "\(name) is not a music app."
								}
							}
						}
					} label: {
						Text(alternativeMusicApp?.name ?? "Select App")
							.frame(
								maxWidth: .infinity,
								minHeight: 20
							)
					}

					if alternativeMusicApp != nil {
						Button {
							alternativeMusicApp = nil
						} label: {
							Image(systemSymbol: .xmark)
								.frame(minHeight: 20)
						}
					}
				}
				if let alternativeMusicAppError {
					Text(alternativeMusicAppError)
						.font(.caption)
						.foregroundColor(.red)
				}
			}
		}
		.fixedSize()
		.padding()
	}
}

#Preview {
	ContentView()
}
