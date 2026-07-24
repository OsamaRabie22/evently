# Evently 🎉

A modern event management app built with Flutter & Firebase.

---

## About

Evently is a full-featured event management mobile application that allows users to create, manage, and favorite events — with a clean UI that supports both **Light & Dark themes** and **Arabic & English localization**.

---

## Features

- 🔐 **Authentication** — Email/Password Sign Up & Login via Firebase Auth
- 🔄 **Auto Login** — Stay signed in across sessions
- 🎨 **Theme Support** — Light & Dark mode with smooth switching
- 🌍 **Localization** — Full Arabic & English support (RTL/LTR)
- 📅 **Event Management** — Create, Edit, Delete events stored in Firestore
- ❤️ **Favorites** — Mark events as favorites with real-time sync
- 👤 **User Profile** — Display name, avatar initials, language & theme settings
- 📡 **Real-time Updates** — Firestore streams for live data
- 🧭 **Onboarding** — Multi-step intro screen with language & theme selection

---

## Tech Stack

| Technology | Usage |
|---|---|
| Flutter | UI Framework |
| Firebase Auth | Authentication |
| Cloud Firestore | Database |
| Provider | State Management |
| Easy Localization | i18n (AR/EN) |
| Google Fonts | Typography (Poppins) |

---

## Project Structure

```
lib/
├── main.dart
├── firebase_options.dart
│
├── core/
│   ├── firebase_functions.dart           # Auth: Sign Up, Login
│   └── my_theme.dart                     # Light & Dark ThemeData
│
├── helpers/
│   └── firestore_helper.dart             # Firestore CRUD + Streams
│
├── models/
│   ├── event_model.dart                  # Event data model
│   ├── task_model.dart                   # Task data model
│   └── onboarding_page_model.dart        # Onboarding page model
│
├── providers/
│   ├── theme_provider.dart               # Theme state (light/dark)
│   ├── home_provider.dart                # Bottom nav state
│   ├── home_page_provider.dart           # Home page state
│   └── add_event_provider.dart           # Add/Edit event state
│
├── screens/
│   ├── onbording_screen/
│   │   ├── app_start_screen.dart         # Splash / entry point
│   │   └── onbording_screen.dart         # Language & theme selection
│   ├── introduction_screens/
│   │   └── onboarding_pages_screen.dart  # 3-step onboarding PageView
│   ├── auth/
│   │   ├── login_screen.dart             # Login with email/password
│   │   └── signup_screen.dart            # Sign up with email/password
│   ├── home/
│   │   ├── home_screen.dart              # Main screen with BottomNavBar
│   │   └── tabs/
│   │       ├── home_page.dart            # Events list
│   │       ├── favorite_page.dart        # Favorited events
│   │       └── profile_page.dart         # User profile & settings
│   └── add_event/
│       ├── add_event_screen.dart         # Create new event
│       ├── edit_event_screen.dart        # Edit existing event
│       └── event_details_screen.dart     # Event details view
│
└── widget/
    ├── event_card.dart                   # Reusable event card widget
    └── date_time_row.dart                # Date & time display widget
```

---

## Getting Started

**Prerequisites**
- Flutter SDK ≥ 3.0.0
- Firebase project configured

**Installation**

```bash
# 1. Clone the repo
git clone https://github.com/OsamaRabie22/evently.git

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

---

## Author

**Osama Rabie**
GitHub: https://github.com/OsamaRabie22