# Smart Booking App 🚗

A modern Flutter application for booking premium parking and car wash services with integrated wallet management and rewards system.

![Flutter](https://img.shields.io/badge/Flutter-3.38.5-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10.3-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## 📱 Screenshots

### Home Dashboard
![Home Screen](https://raw.githubusercontent.com/naufalmms/smart_booking/refs/heads/main/screenshot/1_homePage.jpg)

### Wallet Management
![Wallet Screen](https://raw.githubusercontent.com/naufalmms/smart_booking/refs/heads/main/screenshot/2_wallet_a.jpg)
![Wallet Screen](https://raw.githubusercontent.com/naufalmms/smart_booking/refs/heads/main/screenshot/2_wallet_b.jpg)
![Transaction History](https://raw.githubusercontent.com/naufalmms/smart_booking/refs/heads/main/screenshot/2_wallet_c.jpg)

### Services & Booking
![Services Screen](https://raw.githubusercontent.com/naufalmms/smart_booking/refs/heads/main/screenshot/3_services_a.jpg)
![Booking Dialog](https://raw.githubusercontent.com/naufalmms/smart_booking/refs/heads/main/screenshot/3_services_b.jpg)
![Transaction History](https://raw.githubusercontent.com/naufalmms/smart_booking/refs/heads/main/screenshot/3_services_c.jpg)
![Booking Details](https://raw.githubusercontent.com/naufalmms/smart_booking/refs/heads/main/screenshot/3_services_d.jpg)
![Booking Details](https://raw.githubusercontent.com/naufalmms/smart_booking/refs/heads/main/screenshot/3_services_e.jpg)

### Rewards Center
![Rewards Screen](https://raw.githubusercontent.com/naufalmms/smart_booking/refs/heads/main/screenshot/4_rewards_a.jpg)
![Rewards Screen](https://raw.githubusercontent.com/naufalmms/smart_booking/refs/heads/main/screenshot/4_rewards_b.jpg)

---

## 🎯 Features

### Core Features

- **💰 Wallet Management**
  - Dual currency support (RM - Ringgit Malaysia & GP - Gold Points)
  - Top-up functionality for both currencies
  - Real-time balance tracking
  - Transaction history with filtering by currency
  - Credit/Debit transaction indicators

- **🚗 Service Booking**
  - Browse available services (Valet, Car Wash, Bay Reservation)
  - Real-time service availability status
  - Dual pricing (RM or GP)
  - Interactive booking dialog with date/time picker
  - Location selection
  - Payment method selection (Wallet/GP)

- **📅 Booking Management**
  - View all bookings with status tracking
  - Tab-based filtering (Confirmed, Completed, Cancelled)
  - Booking details dialog
  - Cancel booking functionality
  - Payment history per booking

- **🎁 Rewards Center**
  - Claim exclusive offers and vouchers
  - Category-based filtering (All Offers, Campaigns, Loyalty)
  - My Vouchers section for claimed rewards
  - Expiry date tracking
  - Discount badges and tags

- **🏠 Dashboard**
  - Quick access to all features
  - Wallet balance overview
  - Upcoming bookings summary
  - Available rewards preview
  - Bottom navigation for easy screen switching

### Technical Features

- **MVVM Architecture** - Clean separation of concerns
- **State Management** - Provider pattern for reactive UI
- **Local Database** - SQLite for offline-first experience
- **Material Design 3** - Modern and consistent UI
- **Custom Fonts** - Google Fonts integration
- **Loading States** - Skeleton loaders for better UX
- **Error Handling** - Comprehensive error management

---

## 🏗️ Architecture

This project follows the **MVVM (Model-View-ViewModel)** architecture pattern for clean code organization and maintainability.

```
lib/
├── core/
│   └── database/
│       └── database_helper.dart          # SQLite database singleton
├── features/
│   ├── home/
│   │   ├── view/                         # UI screens
│   │   ├── viewmodel/                    # State management
│   │   └── widgets/                      # Reusable components
│   ├── wallet/
│   │   ├── model/                        # Data models
│   │   ├── service/                      # Business logic & DB operations
│   │   ├── view/                         # UI screens
│   │   ├── viewmodel/                    # State management
│   │   └── widgets/                      # Reusable components
│   ├── services/
│   ├── bookings/
│   └── rewards/
└── main.dart                              # App entry point
```

### Layer Responsibilities

1. **Model** - Data classes and serialization (fromMap/toMap)
2. **Service** - Database operations and business logic
3. **ViewModel** - State management with ChangeNotifier
4. **View** - UI screens and user interactions
5. **Widgets** - Reusable UI components

### State Management Approach

- **Provider** - Lightweight and efficient state management
- **ChangeNotifier** - For reactive state updates
- **Consumer** - For rebuilding UI on state changes
- **MultiProvider** - Global state access across the app

### Database Schema

The app uses **SQLite** with the following tables:

- `wallet_balance` - Currency balances (RM, GP)
- `transactions` - Transaction history
- `services` - Available services catalog
- `bookings` - User bookings
- `rewards` - Vouchers and offers

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.38.5
- **Dart SDK**: 3.10.3
- **FVM** (Flutter Version Management): Recommended for version control

### FVM Setup

This project uses FVM to manage Flutter versions. Make sure you have FVM installed:

```bash
# Install FVM (if not already installed)
dart pub global activate fvm

# Use the project's Flutter version
fvm use 3.38.5

# Verify Flutter version
fvm flutter --version
```

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/naufalmms/smart_booking.git
cd smart_booking
```

2. **Install dependencies**

```bash
# If using FVM
fvm flutter pub get

# If not using FVM
flutter pub get
```

3. **Run the app**

```bash
# If using FVM
fvm flutter run

# If not using FVM
flutter run
```

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5+1        # State management
  sqflite: ^2.4.2           # SQLite database
  path: ^1.9.1              # Path manipulation
  intl: ^0.20.2             # Date/number formatting
  google_fonts: ^6.3.3      # Custom fonts
  skeletonizer: ^2.1.2      # Loading skeletons
  uuid: ^4.5.2              # Unique ID generation
```

---

## 📂 Project Structure

```
smart_booking/
├── android/                  # Android native code
├── ios/                      # iOS native code
├── lib/
│   ├── core/
│   │   └── database/
│   │       └── database_helper.dart
│   ├── features/
│   │   ├── home/
│   │   │   ├── view/
│   │   │   │   └── home_screen.dart
│   │   │   ├── viewmodel/
│   │   │   │   └── home_viewmodel.dart
│   │   │   └── widgets/
│   │   │       └── dashboard_widgets.dart
│   │   ├── wallet/
│   │   │   ├── model/
│   │   │   │   └── wallet_model.dart
│   │   │   ├── service/
│   │   │   │   └── wallet_service.dart
│   │   │   ├── view/
│   │   │   │   ├── wallet_screen.dart
│   │   │   │   └── transaction_history_screen.dart
│   │   │   ├── viewmodel/
│   │   │   │   └── wallet_viewmodel.dart
│   │   │   └── widgets/
│   │   │       └── wallet_widgets.dart
│   │   ├── services/
│   │   │   ├── model/
│   │   │   │   └── service_model.dart
│   │   │   ├── service/
│   │   │   │   └── services_service.dart
│   │   │   ├── view/
│   │   │   │   └── services_screen.dart
│   │   │   ├── viewmodel/
│   │   │   │   └── services_viewmodel.dart
│   │   │   └── widgets/
│   │   │       └── booking_dialog.dart
│   │   ├── bookings/
│   │   │   ├── model/
│   │   │   │   └── booking_model.dart
│   │   │   ├── service/
│   │   │   │   └── bookings_service.dart
│   │   │   ├── view/
│   │   │   │   └── bookings_screen.dart
│   │   │   ├── viewmodel/
│   │   │   │   └── bookings_viewmodel.dart
│   │   │   └── widgets/
│   │   │       └── booking_detail_dialog.dart
│   │   └── rewards/
│   │       ├── model/
│   │       │   └── reward_model.dart
│   │       ├── service/
│   │       │   └── rewards_service.dart
│   │       ├── view/
│   │       │   └── rewards_screen.dart
│   │       ├── viewmodel/
│   │       │   └── rewards_viewmodel.dart
│   │       └── widgets/
│   │           └── rewards_widgets.dart
│   └── main.dart
├── test/                     # Unit and widget tests
├── .fvmrc                    # FVM configuration
├── .gitignore
├── pubspec.yaml
└── README.md
```

---

## 🎨 Design System

### Color Palette

- **Primary Blue**: `#3B82F6` - Wallet & primary actions
- **Green**: `#10B981` - Services & success states
- **Purple**: `#9333EA` - Rewards & premium features
- **Orange**: `#F97316` - Bookings & alerts
- **Background**: `#F9FAFB` - Light gray background
- **Text**: `#1F2937` - Dark gray for text

### Typography

- **Google Fonts** - Custom font families
- **Font Weights**: Regular (400), Medium (500), Bold (700)
- **Font Sizes**: 12px - 24px for various UI elements

### Components

- **Cards** - Rounded corners (12-16px), subtle shadows
- **Buttons** - Rounded (8px), gradient backgrounds
- **Dialogs** - Modal overlays with blur effect
- **Tabs** - Pill-shaped with active state indicators

---

## 🔧 Development

### Code Style

This project follows the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).

```bash
# Format code
fvm flutter format .

# Analyze code
fvm flutter analyze
```

### Adding New Features

1. Create feature folder in `lib/features/`
2. Follow MVVM structure (model → service → viewmodel → view → widgets)
3. Register ViewModel in `main.dart` MultiProvider
4. Add navigation in `home_screen.dart`
5. Write tests
6. Commit following the commit strategy

---

## 📦 Build & Release

### Android

```bash
# Build APK
fvm flutter build apk --release

# Build App Bundle
fvm flutter build appbundle --release
```

### iOS

```bash
# Build iOS
fvm flutter build ios --release
```

---

## 🐛 Known Issues

- None at the moment

---

## 🚧 Future Enhancements

- [ ] User Authentication (Login/Register)
- [ ] REST API Integration
- [ ] Push Notifications
- [ ] Payment Gateway Integration
- [ ] Multi-language Support (i18n)
- [ ] Dark Mode
- [ ] Analytics & Crash Reporting
- [ ] Unit & Widget Tests
- [ ] CI/CD Pipeline

---

## 👨‍💻 Author
- GitHub: [@naufalmms](https://github.com/naufalmms/)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Provider package for state management
- SQLite for local database
- Google Fonts for typography
- Material Design for UI guidelines

---

## 📞 Support

If you have any questions or issues, please open an issue on GitHub or contact me directly.

---

**Made with ❤️ using Flutter**
