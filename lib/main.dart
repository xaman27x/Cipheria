import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/tree_page.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyBBS1Ca6HVg_HiZDNW2eKWXrg7hZQMlMMY",
      authDomain: "cipheria-3a247.firebaseapp.com",
      databaseURL:
          "https://cipheria-3a247-default-rtdb.asia-southeast1.firebasedatabase.app",
      projectId: "cipheria-3a247",
      storageBucket: "cipheria-3a247.appspot.com",
      messagingSenderId: "311847927977",
      appId: "1:311847927977:web:0f1e5ac8e3197ed858e9b8",
      measurementId: "G-32N7CS10L4",
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //Root
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cipheria',
      home: WidgetTree(),
    );
  }
}
