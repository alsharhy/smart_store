import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBqcf4xTW2QmSQo5H6Y7sBvvrw3rG7FJSo',
    appId: '1:336360371156:web:5729f93579d75eb8ad5c41',
    messagingSenderId: '336360371156',
    projectId: 'smartstore-fe906',
    authDomain: 'smartstore-fe906.firebaseapp.com',
    storageBucket: 'smartstore-fe906.firebasestorage.app',
    measurementId: 'G-DPW2QWJQNG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBcX-JBmk5g50seFRN3SIpyxdICr4g51aQ',
    appId: '1:336360371156:android:03cc0ab826e198c7ad5c41',
    messagingSenderId: '336360371156',
    projectId: 'smartstore-fe906',
    storageBucket: 'smartstore-fe906.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQjNvODF911P7PofRWEvVtebT5949e2uA',
    appId: '1:336360371156:ios:cc49dcaa901ed2f6ad5c41',
    messagingSenderId: '336360371156',
    projectId: 'smartstore-fe906',
    storageBucket: 'smartstore-fe906.firebasestorage.app',
    iosBundleId: 'com.example.smartStore',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDQjNvODF911P7PofRWEvVtebT5949e2uA',
    appId: '1:336360371156:ios:cc49dcaa901ed2f6ad5c41',
    messagingSenderId: '336360371156',
    projectId: 'smartstore-fe906',
    storageBucket: 'smartstore-fe906.firebasestorage.app',
    iosBundleId: 'com.example.smartStore',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBqcf4xTW2QmSQo5H6Y7sBvvrw3rG7FJSo',
    appId: '1:336360371156:web:6c6f5672c017b97bad5c41',
    messagingSenderId: '336360371156',
    projectId: 'smartstore-fe906',
    authDomain: 'smartstore-fe906.firebaseapp.com',
    storageBucket: 'smartstore-fe906.firebasestorage.app',
    measurementId: 'G-84WNXFN1PP',
  );
}
