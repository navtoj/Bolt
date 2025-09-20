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

- Launch selected app with `⏯` media keys.
- Toggle media playback in selected app.

## Development

### Install Dependencies

- [Tuist](https://github.com/tuist/tuist) – `brew install --formula tuist/tuist/tuist`

- [Swift Format](https://github.com/nicklockwood/SwiftFormat) – `brew install swiftformat`

- [Swift Lint](https://github.com/realm/SwiftLint) – `brew install swiftlint`

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
