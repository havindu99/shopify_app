# 🛍️ ShopNest

A modern, premium-feeling e-commerce shopping app built with Flutter — featuring an animated onboarding flow, dark/light themes, and a clean Provider-based architecture.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)
![Provider](https://img.shields.io/badge/State%20Management-Provider-blue)

---

## ✨ Features

- **Animated Landing/Onboarding Screen** — auto-sliding carousel with category photos (Electronics, Audio, Footwear, Fashion), animated gradient background, and glow effects.
- **Authentication** — separate, polished **Login** and **Register** screens with form validation.
- **Home Feed** — searchable, filterable product grid with category chips and a responsive layout (2 columns on phones, 3 on tablets/web).
- **Shopping Cart** — add/remove items, live cart badge on the bottom navigation bar.
- **Product Details** — dedicated detail screen for each product.
- **Profile** — user profile screen with account settings.
- **Light & Dark Theme** — toggle from the home screen, persisted via `ThemeProvider`.
- **Smooth Animations** — fade, slide, and scale transitions throughout using Flutter's `AnimationController`.

---

## 🧱 Tech Stack

| Layer            | Package / Tool        |
|-------------------|------------------------|
| Framework         | Flutter                |
| Language          | Dart                   |
| State Management  | `provider`              |
| Cart Badge        | `badges`                |
| Icons             | `material_icons` (built-in) |

---

## 📂 Project Structure

```
lib/
├── main.dart                       # App entry point, MultiProvider setup
├── models/
│   ├── cart_item.dart
│   ├── order.dart
│   └── product.dart
├── providers/
│   ├── auth_provider.dart          # Login/session state
│   ├── cart_provider.dart          # Cart items & totals
│   ├── product_provider.dart       # Product catalog, search, filters
│   └── theme_provider.dart         # Light/dark mode
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── cart/
│   │   └── cart_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── landing/
│   │   └── landing_screen.dart     # Onboarding carousel
│   ├── product_detail/
│   │   └── product_detail_screen.dart
│   └── profile/
│       └── profile_screen.dart
├── theme/
│   └── app_theme.dart              # Light/dark ThemeData
└── widgets/
    ├── auth_widgets.dart           # Shared GlowCircle & PremiumField
    └── product_card.dart
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- An emulator/simulator, a physical device, or a browser (Chrome/Edge) for web

### Installation

```bash
# 1. Clone the repository
git clone <your-repo-url>
cd shopnest

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

You'll be prompted to choose a target device (Windows desktop, Chrome, Edge, an emulator, etc.) if more than one is available.

### Demo Login

This project ships with a **mock authentication provider** for demo purposes — no real backend required:

> Enter **any email address** and **any password with 6 or more characters** to sign in.

---

## 🎨 Design

The app uses a **Midnight Blue & Cyan** palette throughout:

| Color        | Hex       |
|--------------|-----------|
| Navy Dark    | `#0A0E27` |
| Navy         | `#0D1B4B` |
| Cyan         | `#00D4FF` |
| Cyan Light   | `#7EEEFF` |

---

## 🗺️ Roadmap / Ideas for Improvement

- [ ] Connect to a real backend / REST API for products and auth
- [ ] Persist cart & auth state with `shared_preferences` or `hive`
- [ ] Add payment integration
- [ ] Add order history screen
- [ ] Add product reviews & ratings
- [ ] Write unit/widget tests for providers and key screens

---

## 📄 License

This project is for educational/demo purposes. Add a license of your choice (MIT, Apache 2.0, etc.) here.
