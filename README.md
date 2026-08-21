# GameCenter

A lightweight Swift Package that wraps Apple's Game Kit for Game Center sign-in, leaderboards, and avatars.

## Installation

### Swift Package Manager

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/s-vanichkin/GameCenter.git", from: "1.5.0")
]
```

Or add it via Xcode: **File > Add Package Dependencies…** and enter the repository URL.

## Usage

```swift
import GameCenter

// Local player info (available after a successful sign-in)
GameCenter.alias
GameCenter.displayName
GameCenter.avatar

// Report a score to a leaderboard
GameCenter.setScore(100, leaderboardIdentifier: "leaderboard.identifier") { error in
    // handle error
}

// Authenticate the local player if needed and show the Game Center leaderboard
GameCenter.showScores(controller: self) { error in
    // handle error
}
```

## License

MIT
