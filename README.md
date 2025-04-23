# 📺 TVSeriesApp

TVSeriesApp is a modular iOS application built entirely with SwiftUI and Combine. It showcases a list of TV shows with detailed views per series and episode, integrating pagination, light/dark theme support, and clean architectural separation using XcodeGen.

## 🎬 Demo

https://github.com/TheusMartins/tv-series-ios-challenge/blob/main/Demo/DemoPreview.mp4  
*This video demonstrates navigation, infinite scroll, dark/light mode, and responsive UI.*

## 🧱 Architecture & Approach

This project follows a modular structure powered by `XcodeGen`, organized as follows:

- `App/`: Entry point and app lifecycle
- `Modules/Core/`: Models and shared utilities
- `Modules/Networking/`: Request abstractions and endpoints
- `Modules/UI/`: Reusable SwiftUI components (e.g. `TVText`, `TVPill`, theming system)

State is handled via `@StateObject` and `@Published` properties in SwiftUI-compatible `ViewModels`. Data fetching uses Swift Concurrency (`async/await`) with injected repositories to allow easy mocking and unit testing.

## ⚙️ Setup

To run the project locally:

1. Clone the repository:

```bash
git clone https://github.com/TheusMartins/tv-series-ios-challenge.git
cd tv-series-ios-challenge
```

2. Install [XcodeGen](https://github.com/yonaskolb/XcodeGen):

```bash
brew install xcodegen
```

3. Generate the Xcode project:

```bash
xcodegen
```

4. Open and run:

```bash
open TVSeriesApp.xcodeproj
```

✅ The project uses Swift 5.9+ and Xcode 15+.

## 📁 Folder Structure

This is the actual structure of the repository, organized using `XcodeGen` and a modular architecture:

```bash
.
├── App
│   ├── Info.plist
│   ├── Sources
│   │   ├── Features             # SwiftUI features (SeriesList, SeriesDetails)
│   │   ├── Helpers              # Shared utilities (e.g., String extensions)
│   │   └── TVSeriesApp.swift    # App entry point
│   └── Tests
│       ├── CI                  # (Optional) Continuous Integration hooks or scripts
│       └── TVSeriesAppTests    # ViewModel and logic unit tests
├── Demo
│   └── DemoPreview.mp4         # Demo video referenced in README
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
├── README.md                   # Project overview and setup instructions
├── TVSeriesApp.xcodeproj       # Generated Xcode project (optional if using `.xcworkspace`)
│   ├── project.pbxproj
│   ├── project.xcworkspace
│   │   ├── contents.xcworkspacedata
│   │   ├── xcshareddata
│   │   └── xcuserdata
│   ├── xcshareddata
│   │   └── xcschemes
│   └── xcuserdata
│       └── matheusmartins.xcuserdatad
└── project.yml                 # XcodeGen configuration file

## ✨ Key Features

- Infinite scroll with pagination
- Series detail view with poster, summary, and episodes per season
- Fully responsive layout using `LazyVStack` and `ScrollView`
- HTML-stripped summaries to avoid runtime crashes
- Light and Dark Mode support via a centralized `AppTheme`
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
- Episode filtering based on selected season
- A custom observer (`ViewStateSpy`) to verify async flow

📌 I intentionally didn’t include snapshot tests to keep the scope clean, but the project is ready for them.

## 🎨 Design & Theming

TVSeriesApp includes dynamic support for Light and Dark Mode using a custom theme system:

```swift
AppTheme.shared.colors.background
AppTheme.shared.colors.primary
AppTheme.shared.colors.accent
```

This ensures readability and consistency across appearances. I avoided pure black/white to provide a more polished feel.

## 🚫 Why Not Kingfisher?

I considered using libraries like Kingfisher for image loading, but chose to rely on native `AsyncImage` to demonstrate full command of built-in SwiftUI APIs. This approach reduces dependencies and ensures compatibility across platforms.

## 🧪 Schemes

The project provides pre-configured Xcode schemes to help developers and CI pipelines execute tasks independently across modules:

| Scheme              | Description                                            |
|---------------------|--------------------------------------------------------|
| `TVSeriesApp`       | Main application scheme for local builds and previews |
| `TVSeriesAppTests`  | Executes unit tests targeting app-level ViewModels    |
| `UI`                | Compiles and tests shared UI components like `TVText`, `TVPill` |
| `Networking`        | Targets and tests the networking module independently |
| `DASCII` (CI Scheme)| Simulates a full CI run by executing all test targets |

These schemes are automatically generated via `XcodeGen`, ensuring consistency across environments and making CI integration trivial.

## 🧩 Future Improvements

- Snapshot testing (`iOSSnapshotTestCase`)
- i18n and accessibility improvements
- Add support for favorites/bookmarks
- Analytics and event tracking per screen
- Animations and placeholder skeletons for image loading

## 🙌 Final Notes

This project was built as a personal initiative to explore advanced SwiftUI patterns and modular app architecture with `XcodeGen`. It reflects how I would approach a real-world production codebase from scratch.

> ⚠️ Note: The Xcode project and Info.plist files are already configured and versioned. You can run the project immediately without using `xcodegen`.

> 💡 `xcodegen` is only required if you need to regenerate the project structure. Be aware that this may override keys such as `UILaunchScreen` in `Info.plist`.

Feedback is welcome!
