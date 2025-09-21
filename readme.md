# Bolt

A better macOS experience - with powerful tweaks and seamless enhancements.

## Installation

1. Download [`Bolt.zip`](https://github.com/navtoj/Bolt/releases/latest/download/Bolt.zip) from the [Releases](https://github.com/navtoj/Bolt/releases/latest) page.
2. Unzip and drag `Bolt.app` to your **Applications** folder.
3. Launch ⚡︎ **Bolt** ⚡︎ from Spotlight or the Applications folder.

> [!TIP]
> Run `xattr -d com.apple.quarantine /Applications/Bolt.app` to bypass restrictions.

## Features

### Alternative Music Player

Replace _Apple Music_ with _Spotify_ or any _other_ music app.

-   Launch selected app with `⏯` media keys.
-   Toggle media playback in selected app.

## Development

### Install Dependencies

-   [Tuist](https://github.com/tuist/tuist) – `brew install --formula tuist/tuist/tuist`

-   [Swift Format](https://github.com/nicklockwood/SwiftFormat) – `brew install swiftformat`

-   [Swift Lint](https://github.com/realm/SwiftLint) – `brew install swiftlint`

### Link Git Hooks

```shell
git config core.hooksPath .githooks
```

### Install Packages

```shell
tuist install
```

### Launch Xcode

```shell
tuist generate
```

### Release

#### Sign

```
security find-identity -v -p codesigning | grep 'Apple Development' | xargs | cut -d ' ' -f2 | xargs -I% codesign --deep --force --sign % Bolt.app
```

#### Package

```
ditto -ck --keepParent --sequesterRsrc Bolt.app Bolt.zip
```

#### Update

Ensure `SUPublicEDKey` in `Info.plist` is set to the public key and macOS Keychain contains the private key by running `generate_keys --account "Sparkle:Bolt" -p`[^1] in the terminal.

```
generate_appcast --account "Sparkle:Bolt" -o docs/appcast.xml path/to/zip/files
```

[^1]: The `generate_*` commands can be found inside the `sparkle` symlink for the `.build/artifacts/sparkle/Sparkle/bin` directory.
