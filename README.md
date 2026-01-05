# Todo App - Individual Final Assignment
---
## 📱 App Description

A full-featured **Todo List application** built with Flutter that demonstrates modern mobile development practices including offline-first architecture, cloud backend integration, and runtime feature flags.

### Key Features:
- ✅ **Create, Read, Update, Delete** todos with ease
- 📸 **Photo Attachments** - Capture photos or choose from gallery
- 🔒 **Firebase Authentication** - Secure email/password login and signup
- 💾 **Offline-First** - Works seamlessly without internet connection
- ☁️ **Cloud Sync** - Automatic synchronization with PostgreSQL backend
- 🌓 **Dark Mode** - Toggle between light and dark themes
- 🎨 **Modern UI** - Beautiful, intuitive interface with smooth animations
- 🚩 **Feature Flags** - Runtime control over app features

---

## 🎯 Assignment Requirements Met

### ✅ 1. Flutter App (Core)
- **Platform:** Android (iOS compatible)
- **Screens:** 
  - Authentication Screen (Login/Signup)
  - Todo List Screen
  - Add Todo Screen
- **Mobile-First UX:**
  - Smooth navigation with back buttons
  - Loading indicators with progress animations
  - Empty state with encouraging messages
  - Error handling via SnackBars and dialogs
  - Pull-to-refresh functionality
  - Swipe-to-delete gestures

### ✅ 2. Offline-First Behavior
- **Local Storage:** Hive NoSQL database
- **Cached Data:** All todos stored locally for instant access
- **Offline Functionality:**
  - View todos without internet
  - Create/edit todos offline
  - Automatic sync when connection restored
  - Visual online/offline indicators
  - Graceful fallback messages

### ✅ 3. Device APIs
**Camera & Photo Library (image_picker)**
- Take photos with device camera
- Choose photos from gallery
- Photo preview and management
- Local photo storage with todos
- Full-screen photo viewing

### ✅ 4. Backend + Cloud Function
**Technology Stack:**
- **Database:** PostgreSQL on Google Cloud SQL
- **Backend:** Dart Cloud Run service
- **Authentication:** Firebase Authentication

**Database Schema:**
```sql
CREATE TABLE todos (
    id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    title TEXT NOT NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    photo_path TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**API Endpoints:**
- `GET /health` - Health check with database status
- `GET /todos` - Fetch user's todos
- `POST /todos` - Create new todo
- `PUT /todos/:id` - Update todo
- `DELETE /todos/:id` - Delete todo

**Cloud Run Service URL:**  
`https://todo-api-416899989790.northamerica-northeast2.run.app`

**Authentication:**
- Firebase email/password authentication
- Secure user sessions
- Password reset functionality
- Account creation and login flows

### ✅ 5. Feature Flags
**Two Runtime Feature Flags:**

1. **`enable_photos`** - Photo functionality control
   - **Enabled:** Photo button visible, camera/gallery access
   - **Disabled:** Photo features hidden
   - **Default:** Enabled

2. **`enable_dark_mode`** - Theme control
   - **Enabled:** Dark theme with inverted colors
   - **Disabled:** Light theme
   - **Default:** Disabled (Light mode)
   - **Toggle:** Sun/moon icon in app bar for instant switching

**Implementation:**  
Located in `lib/services/feature_flag_service.dart`  
Can be integrated with Intellitoggle or Firebase Remote Config for true runtime updates

---

## 🛠️ Technical Architecture

### Frontend (Flutter)
```
lib/
├── main.dart                    # App entry point with Firebase init
├── models/
│   └── todo.dart               # Todo data model with Hive annotations
├── screens/
│   ├── auth_screen.dart        # Login/Signup interface
│   ├── todo_list_screen.dart   # Main todo list view
│   └── add_todo_screen.dart    # Create todo interface
├── services/
│   ├── auth_service.dart       # Firebase authentication logic
│   ├── api_service.dart        # Backend API communication
│   ├── storage_service.dart    # Hive local database
│   └── feature_flag_service.dart # Feature flag management
```

### Backend (Dart Cloud Run)
```
cloud_function/
├── bin/
│   └── server.dart             # RESTful API server
├── pubspec.yaml                # Dart dependencies
└── Dockerfile                  # Container configuration
```

### Infrastructure
- **GCP Project:** mohammadi-fall-25-final
- **Cloud SQL:** PostgreSQL 15
- **Cloud Run:** Serverless container
- **Firebase:** Authentication service

---

## 🚀 How to Run

### Prerequisites
- Flutter SDK (3.0+)
- Android Studio / VS Code
- Java 17 (for Android Gradle 8.1.1)
- Xcode 14+ (for iOS/macOS)
- GCP account with Cloud SQL and Cloud Run enabled
- Firebase project with Authentication enabled

---

## 📱 Running on Android

### Setup
1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd todolist_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   flutter packages pub run build_runner build
   ```

3. **Configure Firebase:**
   - Ensure `android/app/google-services.json` is present
   - File is already configured for package: `com.final.app`

4. **Update API URL:**
   - Open `lib/services/api_service.dart`
   - Verify line 10 has the correct Cloud Run URL:
     ```dart
     static const String _baseUrl = 'https://todo-api-416899989790.northamerica-northeast2.run.app';
     ```

### Run on Android Device/Emulator
```bash
# Connect Android device or start emulator
flutter devices

# Run the app
flutter run
```

### Build APK
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

**APK Location:** `build/app/outputs/flutter-apk/app-release.apk`

---

## 🍎 Running on iOS/macOS (Xcode)

### Prerequisites
- macOS with Xcode 14+
- CocoaPods installed: `sudo gem install cocoapods`
- Active Apple Developer account (for device testing)

### Setup

1. **Navigate to iOS directory:**
   ```bash
   cd ios
   ```

2. **Install iOS dependencies:**
   ```bash
   pod install
   ```

3. **Configure Firebase for iOS:**
   
   **Download `GoogleService-Info.plist`:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Select project: `mohammadi-fall-25-final-86620`
   - Click iOS app (or add iOS app if not exists)
   - Bundle ID: `com.final.app`
   - Download `GoogleService-Info.plist`
   - Place in: `ios/Runner/GoogleService-Info.plist`

4. **Update Bundle Identifier:**
   - Open Xcode: `open Runner.xcworkspace`
   - Select **Runner** project in left sidebar
   - Select **Runner** target
   - **General** tab → Set Bundle Identifier: `com.final.app`
   - **Signing & Capabilities** → Select your development tea# Todo App - Final Assignment

**Student:** Mohammad I  
**GCP Project:** mohammadi-fall-25-final  
**Firebase Project:** N/A (using Cloud Run directly)

## App Idea
A simple todo list application where users can create, view, and manage their todos with optional photo attachments. The app demonstrates offline-first behavior, device API integration, and backend communication.

## Device API Used
**Camera and Photo Library (image_picker)**
- Users can attach photos to todos using:
  - Device camera (take new photo)
  - Photo library (choose existing photo)
- Photos are stored locally with each todo
- Feature can be toggled on/off via feature flag

## Offline Strategy
**Hive Local Database**
- All todos are cached locally using Hive
- App loads from cache first (instant display)
- Syncs with backend when online
- New todos saved locally immediately, synced later
- Unsynced todos marked with sync icon
- Graceful offline fallback with user notifications

## Cloud Function Purpose
**Dart Cloud Run Service** deployed at `https://todo-api-xxxxx-nn.a.run.app`

Endpoints:
- `GET /todos` - Fetch all todos
- `POST /todos` - Add new todo
- `PUT /todos/:id` - Update todo
- `DELETE /todos/:id` - Delete todo
- `GET /health` - Health check

Backend uses PostgreSQL on GCP with the following schema:
```sql
CREATE TABLE todos (
    id VARCHAR(255) PRIMARY KEY,
    title TEXT NOT NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    photo_path TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Feature Flag(s)

**1. `enable_photos`** - Controls camera/photo functionality
- When `true`: Photo button visible, users can attach photos via camera or gallery
- When `false`: Photo button hidden, photo feature disabled
- Toggle by changing `_enablePhotos` in `lib/services/feature_flag_service.dart`

**2. `enable_dark_mode`** - Controls app theme
- When `true`: App uses dark theme with inverted colors (dark background, light text)
- When `false`: App uses light theme (light background, dark text)
- Toggle by changing `_enableDarkMode` in `lib/services/feature_flag_service.dart`
- Requires app restart to take effect

Both flags can be integrated with Intellitoggle or Firebase Remote Config for runtime updates.

## Test Credentials
No authentication required (simplified for assignment).

## How to Run

### Prerequisites
- Flutter SDK 3.0+
- Android Studio / VS Code
- GCP account with Cloud Run enabled

### Setup
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   flutter packages pub run build_runner build
   ```

3. Deploy Cloud Function:
   ```bash
   cd cloud_function
   ./deploy.sh
   ```

4. Update API URL in `lib/services/api_service.dart` with your Cloud Run URL

5. Run the app:
   ```bash
   flutter run
   ```

### Build APK
```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

## Features Demonstrated

✅ **Mobile-first UX**
- Clean, intuitive todo list interface
- Smooth navigation between screens
- Loading states with circular progress indicators
- Empty state messages
- Pull-to-refresh functionality

✅ **Offline-First Behavior**
- Hive local database caching
- Instant data display from cache
- Background sync when online
- Offline indicators in UI
- Retry mechanism for failed syncs

✅ **Device API Integration**
- Camera access via image_picker
- Photo preview before saving
- Local photo storage
- Remove photo option

✅ **Backend Communication**
- RESTful API with Cloud Run
- PostgreSQL database
- Error handling with user feedback
- Connectivity status checking

✅ **Feature Flag Control**
- Runtime toggle for photo feature
- Affects UI visibility and functionality
- Easy to extend for more flags

## Project Structure
```
todo_app/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── todo.dart
│   ├── screens/
│   │   ├── todo_list_screen.dart
│   │   └── add_todo_screen.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── storage_service.dart
│   │   └── feature_flag_service.dart
├── cloud_function/
│   ├── bin/server.dart
│   ├── pubspec.yaml
│   └── Dockerfile
└── README.md
```

## Time Spent
Approximately 3 hours for complete implementation and testing.
