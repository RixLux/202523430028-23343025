# Note for what is changed for week 3 task

## AUTH Service
 
### 1. Isolated Auth Directory (`lib/auth/`)

Created a dedicated module to handle the logic and definitions of authentication:

* **`auth_user.dart`**: An abstract representation of the authenticated user, stripping away provider-specific data.
* **`auth_provider.dart`**: A formal interface (contract) defining necessary operations like `logIn`, `createUser`, and `logOut`.
* **`auth_exceptions.dart`**: A collection of custom, provider-agnostic exceptions.
* **`firebase_auth_provider.dart`**: The concrete implementation of the `AuthProvider` interface specifically for Firebase.

### 2. Generic AuthService (The Facade)

Updated `lib/auth_service.dart` to act as a **singleton facade**.

* It wraps the `AuthProvider` and exposes its methods to the rest of the app.
* **Benefit:** Switching from Firebase to another provider (like Supabase or a custom backend) now only requires changing one line of code in the service initialization.

```
import 'auth/auth_provider.dart';
import 'auth/auth_user.dart';
import 'auth/firebase_auth_provider.dart';

export 'auth/auth_user.dart';
export 'auth/auth_exceptions.dart';
export 'auth/auth_provider.dart';
```
> Replace `firebase_auth_provider.dart` with other provider.

### 3. Clean Exception Handling

Refactored `login_view.dart` and `register_view.dart` to catch domain-specific exceptions:

* **Old way:** Catching `FirebaseAuthException`.
* **New way:** Catching `UserNotFoundAuthException` or `WeakPasswordAuthException`.
* **Result:** The UI layer remains "blind" to the backend technology, resulting in cleaner, more readable code.

### 4. Decoupled Entry Point

Modified `main.dart` to remove direct Firebase dependencies.

* Replaced Firebase-specific setup with `AuthService().initialize()`.
* The application entry point is now completely unaware of which authentication provider is being utilized under the hood.


## CRUD local storage

### Key Components
   * **`DatabaseNote`**: A model class representing the database row (ID, Text, UserID).
   * **`NotesService`**: A singleton service handling database initialization, table creation, and CRUD (Create, Read, Update, Delete) operations.
   * **`FutureBuilder` Integration**: The `NotesView` uses a `FutureBuilder` to asynchronously load and refresh the notes list.
 
 
### Platform Note
   `sqflite` is a native plugin. **It does not support Flutter Web.**
   * To test the notes feature, you **must** use an Android or iOS emulator/device.
   * Running on Web will result in a `Database not open` exception.

> this one use sqflite as dependency

```
dependencies:
  flutter:
    sdk: flutter
  # Add these three lines:
  sqflite: ^2.3.0
  path_provider: ^2.1.2
  path: ^1.9.0
```
> look for it on `pubspec.yaml` and add it  

next run these to install it
```
flutter pub get
```

also to make sure that the app work properly on waydroid we need to change the build engine

```
<application
        android:label="first_app"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">

        <meta-data
            android:name="io.flutter.embedding.android.EnableImpeller"
            android:value="false" />

        <activity
            android:name=".MainActivity"
            ... >
            </activity>
    </application>
```
> make sure it look like this

look for this at `android/app/src/main/AndroidManifest.xml`
