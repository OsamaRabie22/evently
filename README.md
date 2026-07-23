Evently 🎉
A cross-platform mobile application built with Flutter that allows users to create, manage, and track personal events — with full support for dark mode, Arabic/English localization, and real-time Firebase sync.

Features:
Authentication — Email/password login & sign up via Firebase Auth. Session is persisted across app restarts — no need to log in again after closing the app.
Event Management — Create, view, edit, and delete personal events stored in Firestore, each with a title, description, category, date, and time.
Favorites — Mark events as favorite and view them in a dedicated Favorites page, synced in real-time.
Event Details — Dedicated screen showing full event info with edit and delete actions.
Category Filtering — Filter events by category (Sport, Birthday, Meeting, Exhibition, Book Club) on the home screen.
Dark Mode — Full dark/light theme toggle, persisted across sessions using SharedPreferences.
Localization — Full Arabic and English support with easy_localization, including RTL layout. Language preference is changeable from the Profile screen.
Onboarding — First-launch onboarding screens for theme and language selection.
Profile Screen — Displays user avatar (initials), name, email, with options for dark mode toggle, language switching, and logout.

Project Structure:
lib/
├── core/               # Theme, Firebase functions
├── helpers/            # Firestore helper
├── models/             # TaskModel
├── providers/          # ThemeProvider, HomePageProvider, AddEventProvider
├── screens/
│   ├── auth/           # Login, Signup
│   ├── home/           # HomeScreen, HomePage
│   ├── add_event/      # AddEventScreen, EditEventScreen, EventDetailsScreen
│   ├── onboarding/     # Onboarding screens
│   └── profile/        # ProfilePage
├── widget/             # Reusable widgets (EventCard, DateTimeRow, etc.)
└── main.dart
assets/
├── images/             # Event category images (light + dark)
└── translations/       # en.json, ar.json
