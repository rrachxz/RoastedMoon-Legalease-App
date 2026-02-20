import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;


  const BottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {

    const Color activeColor = Color(0xFF2196F3); // Blue when active
    const Color inactiveColor = Color(0xFF6B7280); // Grey when inactive

    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/home.svg',
            color: selectedIndex == 0 ? activeColor : inactiveColor,
            width: 35,
            height: 35,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/chat.svg',
            color: selectedIndex == 1 ? activeColor : inactiveColor,
            width: 35,
            height: 35,
          ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/file-text.svg',
            color: selectedIndex == 2 ? activeColor : inactiveColor,
            width: 35,
            height: 35,
          ),
          label: 'Articles',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/user-circle.svg',
            color: selectedIndex == 3 ? activeColor : inactiveColor,
            width: 35,
            height: 35,
          ),
          label: 'Profile',
        ),
      ],

      currentIndex: selectedIndex,
      selectedItemColor: activeColor,
      unselectedItemColor: inactiveColor,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      onTap: onItemTapped,
      elevation: 8,
      selectedFontSize: 12,
      unselectedFontSize: 12,
    );
  }
}