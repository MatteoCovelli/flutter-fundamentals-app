# Flutter Fundamentals App

A mobile application built to demonstrate and master the core architectural and layout concepts of the **Flutter** framework and **Dart** programming language.

---

## 🚀 Key Features

* **Modular Architecture:** The codebase is fully decoupled, splitting the user interface into distinct `views/pages` (smart components) and reusable `widgets` (presentational components).
* **State Management & Reactivity:** Implemented local state tracking using `StatefulWidget` and high-performance, granular UI updates via `ValueNotifier` and `ValueListenableBuilder` to minimize widget rebuilds.
* **Responsive & Adaptive Layouts:** Designed to scale across different screen constraints using `MediaQuery`, `LayoutBuilder`, and proportional sizing with `Flexible` and `Expanded`. Uses native `.adaptive` constructors to match iOS and Android visual guidelines.
* **Data Persistence:** Integrated local key-value storage using the `shared_preferences` package to persist user configuration (such as Dark/Light theme toggle) across app restarts.
* **Asynchronous Networking:** Consumes external REST APIs using the `http` package. Implements declarative asynchronous rendering using `FutureBuilder` to smoothly cycle through Loading, Error, and Data states.
* **UI Polish:** Features smooth component-sharing transitions via native `Hero` animations and handles complex vector graphics through the `Lottie` animation framework.

---

## 🛠️ Tech Stack & Dependencies

* **Core:** Flutter 3.x / Dart 3.x
* **Networking:** `http`
* **Storage:** `shared_preferences`
* **Graphics:** `lottie`
* **Build Tools:** `flutter_launcher_icons` (for native app icon generation)
