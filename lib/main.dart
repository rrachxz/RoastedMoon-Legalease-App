import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:roastedmoon_legalease/ui/auth/login.dart';
import 'firebase_options.dart';
import 'ui/auth/login.dart';
import 'package:roastedmoon_legalease/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Legalease',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white, // Pure white background
        primaryColor: const Color(0xFF0086FF), // Your Figma blue
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: const MainNavigation(),
    );
  }
}
