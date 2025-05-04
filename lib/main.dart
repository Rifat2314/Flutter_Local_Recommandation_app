import 'package:explore_map/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyC73u7T_o5smBZSUYELZxmkryz6YbP2pzs",
            authDomain: "fluttermap1td.firebaseapp.com",
            projectId: "fluttermap1td",
            storageBucket: "fluttermap1td.firebasestorage.app",
            messagingSenderId: "184797963299",
            appId: "1:184797963299:web:4d936ad0a92109ca58fd96",
            measurementId: "G-Q39MFTFZ3N"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
