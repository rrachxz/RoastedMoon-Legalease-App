import 'package:flutter/material.dart';
import 'package:roastedmoon_legalease/ui/screens/components/bottom_nav.dart';
import 'package:roastedmoon_legalease/ui/screens/home/home_page.dart';
import 'package:roastedmoon_legalease/ui/screens/chat_page.dart';
import 'package:roastedmoon_legalease/ui/screens/articles_page.dart';
import 'package:roastedmoon_legalease/ui/screens/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  //pages
  final List<Widget> _pages = [
    const HomePage(),
    const ChatPage(),
    const ArticlesPage(),
    const ProfilePage(),
  ];

  // Handle bottom nav tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}