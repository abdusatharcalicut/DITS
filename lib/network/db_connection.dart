import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> initializeFirestore() async {
  await Firebase.initializeApp(
    options: FirebaseOptions(
      authDomain: 'dits-70857.firebaseapp.com',
      apiKey: 'AIzaSyA547ZxV9wKbXeQodUhOlUKYnXo7jjPewc',
      appId: '1:195081687950:android:5e85645eabba402e97cadf',
      messagingSenderId: '195081687950',
      projectId: 'dits-70857',
      // databaseURL: 'YOUR_DATABASE_URL',
      storageBucket: 'dits-70857.appspot.com',
    ),
  );
}
