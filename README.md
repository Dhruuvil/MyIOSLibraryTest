# Moby Rewards SDK for iOS

A modern, highly customizable iOS SDK for integrating Moby cashback and scratch rewards into your iOS apps (Swift / SwiftUI / UIKit).

---

## 🌟 Features

- **Scratch Card Engine**: Real-time finger scratch-to-reveal experience with custom mask rendering & auto-completion at 50%.
- **Upcoming & Active Tabs**: Easily toggle between upcoming scratch cards and active unlocked rewards.
- **Dynamic Theming**: Full control over colors, fonts, margins, card radii, button styles, and scratch cover design.
- **Copy & Shop Now**: Automatic coupon code copying to clipboard with toast feedback and 1-second delayed web redirection.
- **SwiftUI & UIKit Ready**: Use native `MobyRewardsView` in UIKit or `MobyRewardsSwiftUIView` in SwiftUI.

---

## 📦 Installation

### Swift Package Manager (SPM)

Add the repository URL to your Xcode Project dependencies:

```swift
https://github.com/moby-cashback/moby-rewards-lib.git
```

Or in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/moby-cashback/moby-rewards-lib.git", .upToNextMajor(from: "1.0.0"))
]
```

### CocoaPods

Add the following to your `Podfile`:

```ruby
pod 'MobyRewards', :git => 'https://github.com/moby-cashback/moby-rewards-lib.git'
```

---

## 🚀 Quick Start

### 1. UIKit Integration

```swift
import UIKit
import MobyRewards

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let rewardsView = MobyRewardsView(frame: view.bounds)
        rewardsView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(rewardsView)

        // Pass your API Configuration
        rewardsView.setApiConfig(
            affiliateId: "YOUR_AFFILIATE_ID",
            appShortName: "YOUR_APP_SHORT_NAME",
            secureKey: "YOUR_SECURE_KEY",
            userUnique: "USER_UNIQUE_ID",
            gender: "male",
            age: 25
        )
    }
}
```

### 2. SwiftUI Integration

```swift
import SwiftUI
import MobyRewards

struct ContentView: View {
    var body: some View {
        MobyRewardsSwiftUIView(
            affiliateId: "YOUR_AFFILIATE_ID",
            appShortName: "YOUR_APP_SHORT_NAME",
            secureKey: "YOUR_SECURE_KEY",
            userUnique: "USER_UNIQUE_ID",
            gender: "male",
            age: 25
        )
        .edgesIgnoringSafeArea(.all)
    }
}
```

---

## 🎨 Customizing Theme & Colors

You can easily customize all colors and design system tokens:

```swift
var customTheme = RewardsColorCombination()
customTheme.primaryColor = UIColor(hex: "#FF6B35")
customTheme.backgroundColor = UIColor(hex: "#F7F8FC")
customTheme.titleTextColor = UIColor(hex: "#111827")

rewardsView.setColorCombination(customTheme)
```

---

## 📄 License

Distributed under the MIT License.
