import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:roastedmoon_legalease/settings_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roastedmoon_legalease/screens/chat_history_page.dart';
import 'package:roastedmoon_legalease/screens/home_page.dart';
import 'package:roastedmoon_legalease/screens/articles_page.dart';
import 'package:roastedmoon_legalease/screens/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'Legalease',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            primaryColor: const Color(0xFF0086FF),

            // Set default font family
            fontFamily: settings.isDyslexicFont
                ? GoogleFonts.lexend().fontFamily
                : GoogleFonts.plusJakartaSans().fontFamily,

            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),

            // Apply font theme
            textTheme: (settings.isDyslexicFont
                    ? GoogleFonts.lexendTextTheme()
                    : GoogleFonts.plusJakartaSansTextTheme())
                .copyWith(
              bodyLarge: const TextStyle(color: Colors.black, fontSize: 16),
              bodyMedium: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ),
          home: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(settings.fontSizeFactor),
            ),
            child: const MainNavigation(),
          ),
        );
      },
    );
  }
}

// --- NAVIGATION ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    const HomeScreenContent(),
    const ChatHistoryPage(),
    ArticlesPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      // Bottom navigation bar removed — handled by friend's nav
    );
  }
}