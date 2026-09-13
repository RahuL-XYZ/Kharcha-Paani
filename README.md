# Kharcha Paani (खर्चा पानी) 🏠 ₹

A production-quality Flutter mobile application for roommates and flatmates to manage shared households, record expenses, split costs equally with exact integer-paise precision, track who owes whom via debt simplification, settle payments, and view monthly analytics.

---

## 🌟 Key Features

1. **Authentication & User Profiles**:
   - Email & password registration and login
   - Password reset workflow
   - Automatic sync with Cloud Firestore `users` collection

2. **Household & Room Management**:
   - Create shared households (e.g. *Flat 302*, *Green Villa*)
   - Unique 6-character uppercase invite code generation (e.g., `X7K92P`)
   - Join existing households by entering the invite code
   - Manage roommates, view roles (*Owner*, *Member*), and track join dates

3. **Smart Expense Management**:
   - Add/edit expenses with title, amount, category, payer, and multi-selected participants
   - 10 predefined Indian household categories (Grocery, Rent, Electricity, Water, Internet, Gas, Cleaning, Household, Food, Other)
   - Receipt detail screen with split breakdowns and edit/delete permissions
   - Filter expenses by category, roommate, date range, or title search

4. **Precision Calculation Engine**:
   - **Integer-Paise Precision**: All monetary calculations are performed in paise (`₹100.00 = 10000 paise`) to prevent floating-point rounding errors.
   - **Deterministic Remainder Distribution**: An uneven split (e.g. ₹100 split 3 ways: ₹33.34 + ₹33.33 + ₹33.33) always preserves the exact sum.
   - **Dynamic Net Balances**: Balances are calculated dynamically from active expenses and settlements—never manually edited.

5. **Debt Simplification & Settlements ("Who Owes Whom")**:
   - Optimal greedy debt-settlement algorithm calculates the minimal practical transactions needed to settle all household debts.
   - Quick one-tap "Mark as Paid" action to record cash/UPI/bank settlements.
   - Complete audit trail in Settlement History.

6. **Monthly Analytics & Trends**:
   - Spending breakdown by category with interactive percentage progress bars.
   - Month-by-month spending trends.

7. **Modern Material 3 Indian Fintech UI**:
   - Sleek Emerald (`#00875A`) and Navy Slate aesthetic.
   - Indian currency formatting (`₹12,450`, `₹1,25,000`).
   - Light, Dark, and System theme support with persistent settings.

---

## 🏗️ Architecture & Project Structure

The project follows a clean, feature-based modular architecture:

```text
lib/
├── core/
│   ├── constants/            # Colors, App constants, Expense categories
│   ├── errors/               # AppException & friendly error mapping
│   ├── routing/              # GoRouter configuration & route names
│   ├── theme/                # Material 3 light/dark themes & Riverpod theme provider
│   └── utils/                # CurrencyFormatter (paise), DateFormatter, InviteCodeGenerator
├── models/
│   ├── user_model.dart
│   ├── household_model.dart
│   ├── household_member_model.dart
│   ├── expense_model.dart
│   └── settlement_model.dart
├── services/
│   ├── auth_service.dart
│   ├── household_service.dart
│   ├── expense_service.dart
│   ├── settlement_service.dart
│   └── expense_calculation_service.dart   # Integer paise & debt simplification engine
├── repositories/
│   ├── auth_repository.dart
│   ├── household_repository.dart
│   ├── expense_repository.dart
│   └── settlement_repository.dart
├── features/
│   ├── auth/                 # Splash, Login, Register, Forgot Password
│   ├── home/                 # Household listing, Quick summary, Empty states
│   ├── household/            # Create, Join, Invite Code, Dashboard, Members
│   ├── expenses/             # Add/Edit, Details, History, Filters
│   ├── balances/             # Net balances, Debt simplification, Settle Up
│   ├── settlements/          # Settlement History
│   ├── analytics/            # Category & Monthly breakdowns
│   └── profile/              # User profile, Theme switcher, About dialog
├── firebase_options.dart
└── main.dart
```

---

## 🗄️ Firestore Database Schema

```text
users/{userId}
  ├── name: string
  ├── email: string
  ├── photoUrl: string (optional)
  └── createdAt: timestamp

households/{householdId}
  ├── name: string
  ├── inviteCode: string (6-char uppercase alphanumeric)
  ├── createdBy: string (userId)
  ├── createdAt: timestamp
  ├── isActive: boolean
  ├── memberIds: array<string>
  └── memberCount: number

households/{householdId}/members/{userId}
  ├── name: string
  ├── role: string ('owner' | 'member')
  ├── joinedAt: timestamp
  └── email: string (optional)

households/{householdId}/expenses/{expenseId}
  ├── title: string
  ├── amount: number
  ├── category: string
  ├── paidBy: string (userId)
  ├── participants: array<string>
  ├── splitType: string ('equal')
  ├── notes: string (optional)
  ├── date: timestamp
  ├── createdBy: string (userId)
  ├── createdAt: timestamp
  └── updatedAt: timestamp (optional)

households/{householdId}/settlements/{settlementId}
  ├── fromUser: string (userId)
  ├── toUser: string (userId)
  ├── amount: number
  ├── createdBy: string (userId)
  ├── createdAt: timestamp
  └── status: string ('completed')
```

---

## 🔒 Firestore Security Rules

Deploy the included `firestore.rules` file to ensure:
- Only authenticated members can read and write household data.
- Non-members cannot access expenses or balances of other households.
- Only creators or payers can edit or delete expenses.
- Settlements are immutable audit records.

To deploy security rules using Firebase CLI:
```bash
firebase deploy --only firestore:rules
```

---

## 🚀 Getting Started

### 1. Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.13+ / 3.47+)
- [Dart SDK](https://dart.dev/get-dart)
- [Firebase CLI](https://firebase.google.com/docs/cli) (`npm install -g firebase-tools`)
- Android Studio / Xcode for emulators and physical devices

### 2. Clone & Install Dependencies
```bash
git clone <repo-url>
cd kharcha_paani
flutter pub get
```

### 3. Firebase Configuration
1. Log in to Firebase CLI:
   ```bash
   firebase login
   ```
2. Create a new Firebase project on the [Firebase Console](https://console.firebase.google.com/).
3. Enable **Email/Password Authentication** in Authentication > Sign-in method.
4. Enable **Cloud Firestore** in Firestore Database > Create Database (production mode).
5. Run FlutterFire CLI in the project root to generate platform configurations:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

### 4. Running the App
- On Android emulator / device:
  ```bash
  flutter run -d android
  ```
- On iOS simulator / device:
  ```bash
  flutter run -d ios
  ```
- On Web (Chrome):
  ```bash
  flutter run -d chrome
  ```

---

## 🧪 Running Unit & Widget Tests

Run the complete test suite:
```bash
flutter test
```

To run the calculation service tests specifically:
```bash
flutter test test/services/expense_calculation_service_test.dart
```

To run analyzer checks:
```bash
flutter analyze
```

---

## 📄 License
Kharcha Paani is licensed under the MIT License.
