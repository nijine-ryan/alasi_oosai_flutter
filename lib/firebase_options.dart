// GENERATED FILE — Replace this with your real Firebase config.
//
// Setup steps:
//   1. Create a Firebase project at https://console.firebase.google.com
//   2. Add Android & iOS apps in the console
//   3. Run: dart pub global activate flutterfire_cli
//   4. Run: flutterfire configure
//      → This auto-generates this file with your real project values.
//
// Android:  add google-services.json to android/app/
//           add `apply plugin: 'com.google.gms.google-services'` to android/app/build.gradle
//           add `classpath 'com.google.gms:google-services:4.4.0'` to android/build.gradle
//
// iOS:      add GoogleService-Info.plist via Xcode into Runner/
//
// Permissions (android/app/src/main/AndroidManifest.xml):
//   <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Firebase not configured for web yet.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'Firebase not configured. Run: flutterfire configure',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'Firebase not configured. Run: flutterfire configure',
        );
      default:
        throw UnsupportedError('Unsupported platform for Firebase.');
    }
  }
}
