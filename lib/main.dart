import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:roastedmoon_legalease/ui/auth/login.dart';
import 'firebase_options.dart';
import 'ui/auth/login.dart';
import 'package:roastedmoon_legalease/screens/home_page.dart';

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
        brightness: Brightness.dark, // Makes the whole app dark mode
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E), // Matches your Figma
      ),
      home: const MainNavigation(),
    );
  }
}
