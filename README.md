# Secure Notes - Private & Minimalist Notes App

Secure Notes is a robust and elegant Flutter application designed for users who value privacy and simplicity. Built with Firebase, it provides a seamless experience for managing personal thoughts, to-do lists, and memories with complete security.

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: ^3.6.0
- **Firebase Account**: To manage your own database.
- **Tools**: Android Studio, VS Code, or your preferred IDE.

### Installation & Local Setup
1. **Clone the repository**:
   ```bash
   git clone https://github.com/faizi037/secure_notes.git
   cd secure_notes
   ```
2. **Setup Firebase**:
   - Create a project at [Firebase Console](https://console.firebase.google.com).
   - Register your Android app (Package name: `com.example.secure_notes`).
   - Download `google-services.json` and place it in `android/app/`.
   - Enable **Email/Password** Auth & **Firestore Database**.
3. **Configure Firestore Rules**:
   Paste these into your Rules tab to ensure user privacy:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /notes/{noteId} {
         allow create: if request.auth != null && request.auth.uid == request.resource.data.user_id;
         allow read, update, delete: if request.auth != null && request.auth.uid == resource.data.user_id;
       }
     }
   }
   ```
4. **Run the App**:
   ```bash
   flutter pub get
   flutter run
   ```

## 📊 Database Schema (Firestore)

| Collection | Field | Type | Description |
|---|---|---|---|
| `notes` | `user_id` | String | UID of the note owner |
| | `title` | String | Title of the note |
| | `content` | String | Main text of the note |
| | `created_at`| Timestamp | Creation date |
| | `updated_at`| Timestamp | Last modified date |

## 🔑 Authentication Approach
- **Firebase Auth**: Used for secure Email/Password sign-ins and sign-ups.
- **Persistence**: Sessions are maintained automatically by Firebase.
- **Provider Pattern**: Auth state is managed globally using the `Provider` package to reactively update the UI.

## 🧠 Assumptions & Trade-offs
- **Offline Mode**: For this version, the app relies on Firestore's default caching; a full offline-first sync with SQLite was traded off for development speed.
- **Search**: Implemented as a client-side filter for instant results, assuming the number of notes per user remains within a reasonable range for memory.
- **Security**: Access control is strictly enforced via Firestore Security Rules, ensuring data is never exposed to other users.

## 📦 APK Generation
To generate the production APK:
```bash
flutter build apk --release
```
The file will be located at: `build/app/outputs/flutter-apk/app-release.apk`

---
Developed by **faizi037**
