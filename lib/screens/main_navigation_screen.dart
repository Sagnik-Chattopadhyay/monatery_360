import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'tours/virtual_tours_screen.dart';
import 'map/interactive_map_screen.dart';
import 'monk_ai/monk_ai_chat_screen.dart';
import 'profile/profile_screen.dart';
import '../config/app_theme.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    VirtualToursScreen(),
    InteractiveMapScreen(),
    MonkAIChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceCanvas,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C112D23),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.explore_outlined, Icons.explore, 'Discover'),
                _buildNavItem(1, Icons.view_in_ar_outlined, Icons.view_in_ar, '360° Tours'),
                _buildNavItem(2, Icons.alt_route_outlined, Icons.alt_route, 'Routes Map'),
                _buildNavItem(3, Icons.psychology_outlined, Icons.psychology, 'Monk AI'),
                _buildNavItem(4, Icons.person_outline, Icons.person, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData solidIcon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryEmerald : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? solidIcon : outlineIcon,
              size: 20,
              color: isSelected ? Colors.white : AppTheme.textMuted,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
