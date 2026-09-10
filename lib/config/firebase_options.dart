import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase options template for Monastery 360.
/// Replace placeholder values with your Firebase console credentials.
class DefaultFirebaseOptions {
  static bool useLiveFirebase = true; // Connected to live Firebase project: monastery-360-f4b5a

  static const String _apiKey = String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'YOUR_FIREBASE_API_KEY');

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: _apiKey,
    appId: '1:991253647029:web:b54c1e9b38eea8fcb5b8fc',
    messagingSenderId: '991253647029',
    projectId: 'monastery-360-f4b5a',
    authDomain: 'monastery-360-f4b5a.firebaseapp.com',
    storageBucket: 'monastery-360-f4b5a.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: _apiKey,
    appId: '1:991253647029:android:b54c1e9b38eea8fcb5b8fc',
    messagingSenderId: '991253647029',
    projectId: 'monastery-360-f4b5a',
    storageBucket: 'monastery-360-f4b5a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: _apiKey,
    appId: '1:991253647029:ios:b54c1e9b38eea8fcb5b8fc',
    messagingSenderId: '991253647029',
    projectId: 'monastery-360-f4b5a',
    storageBucket: 'monastery-360-f4b5a.firebasestorage.app',
    iosBundleId: 'com.example.monastery_360',
  );
}

