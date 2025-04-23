# 📺 TVSeriesApp

TVSeriesApp is a modular iOS application built entirely with SwiftUI and Combine. It showcases a list of TV shows with detailed views per series and episode, integrating pagination, search, light/dark theme support, and clean architectural separation using XcodeGen.

## 🎬 Demo

![Demo Preview](Demo/DemoPreview.mp4)

*This video demonstrates navigation, infinite scroll, dark/light mode, series search, and episode navigation.*

## 🧱 Architecture & Approach

This project follows a modular structure powered by `XcodeGen`, organized as follows:

- `App/`: Entry point and app lifecycle
- `Modules/Core/`: Models and shared utilities
- `Modules/Networking/`: Request abstractions and endpoints
- `Modules/UI/`: Reusable SwiftUI components (e.g. `TVText`, `TVPill`, theming system)

State is handled via `@StateObject` and `@Published` properties in SwiftUI-compatible `ViewModels`. Data fetching uses Swift Concurrency (`async/await`) with injected repositories for easy mocking and unit testing.

## ✨ Key Features

- Infinite scroll with pagination
- Series search by name with debounce
- Series detail view with poster, summary, and episodes per season
- Tap to navigate to episode detail
- Fully responsive layout using `LazyVStack` and `ScrollView`
- HTML-stripped summaries to avoid runtime crashes
- Light and Dark Mode support via centralized `AppTheme`
- Navigation using native `NavigationView` and `NavigationLink`

## ⚠️ HTML Handling

Some API fields (e.g. `summary`) return HTML-formatted strings. An early implementation using `NSAttributedString` caused crashes when scrolling rapidly. To ensure reliability and performance, I opted for a safer approach:

```swift
extension String {
    var strippedHTMLTags: String {
        // Basic regex-based HTML stripping
    }
}
```

This improves consistency and avoids layout issues.

## 🧪 Testing Strategy

The project includes unit tests focusing on:

- `ViewModel` state transitions (`idle → loading → success`, etc.)
- Error fallback and messaging
- Episode filtering by season
- Series search result handling
- A custom observer (`ViewStateSpy`) to verify async flow

📌 Snapshot testing was skipped to keep the scope focused.

## 🎨 Design & Theming

TVSeriesApp supports Light and Dark Mode using a custom `AppTheme` with dynamic color resolution:

```swift
AppTheme.shared.colors.background
AppTheme.shared.colors.primary
AppTheme.shared.colors.accent
```

This approach avoids pure black/white tones and provides a smoother visual experience.

## 🚫 Why Not Kingfisher?

I considered using libraries like Kingfisher for image loading, but chose native `AsyncImage` to demonstrate full command of SwiftUI's APIs. This reduces dependencies and ensures cross-platform compatibility.

## 🧪 Schemes

The project includes pre-configured schemes for CI and local testing:

| Scheme              | Description                                            |
|---------------------|--------------------------------------------------------|
| `TVSeriesApp`       | Main application scheme for local builds              |
| `TVSeriesAppTests`  | Unit tests for app logic and ViewModels               |
| `UI`                | Tests reusable UI components like `TVText`, `TVPill`  |
| `Networking`        | Tests network layer and endpoint logic                |
| `DASCII` (CI Scheme)| Full test suite execution for CI                      |

Generated automatically with `XcodeGen`.

## 📁 Folder Structure

```
.
├── App
│   ├── Info.plist
│   ├── Sources
│   │   ├── Features             # SwiftUI features (SeriesList, SeriesDetails, EpisodeDetails)
│   │   ├── Helpers              # Shared utilities (e.g., String extensions)
│   │   └── TVSeriesApp.swift    # App entry point
│   └── Tests
│       ├── CI                  # (Optional) Continuous Integration hooks
│       └── TVSeriesAppTests    # ViewModel and logic unit tests
├── Demo
│   └── DemoPreview.mp4         # Demo video used above
├── Modules
│   ├── Networking
│   │   ├── Info.plist
│   │   ├── Networking.xcodeproj
│   │   ├── Sources             # API requests, endpoint definitions, DTOs
│   │   ├── Tests               # Networking layer tests
│   │   └── project.yml
│   └── UI
│       ├── Info.plist
│       ├── Sources             # TVText, TVPill, AppTheme, Colors
│       ├── Tests               # UI layer component tests (if any)
│       ├── UI.xcodeproj
│       └── project.yml
├── README.md                   # You are here!
├── TVSeriesApp.xcodeproj       # Versioned Xcode project (use as-is)
└── project.yml                 # XcodeGen configuration file
```

## ⚙️ Setup

This project is already versioned with a valid `.xcodeproj`, including necessary `Info.plist` settings. You can run it immediately without using `XcodeGen`.

### ▶️ To Run:

```bash
git clone https://github.com/TheusMartins/tv-series-ios-challenge.git
cd tv-series-ios-challenge
open TVSeriesApp.xcodeproj
```

### ⚠️ To Regenerate (Optional):

```bash
brew install xcodegen
rm -rf TVSeriesApp.xcodeproj
xcodegen
open TVSeriesApp.xcodeproj
```

> ⚠️ Regenerating will override `Info.plist` customizations (e.g. `UILaunchScreen`).

## 🙌 Final Notes

This is a personal exploration of modular architecture and SwiftUI patterns. Feedback is welcome!