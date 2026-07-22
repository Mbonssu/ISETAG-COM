// lib/screens/main_screen.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../services/translation_service.dart';
import '../utils/themes/app_colors.dart';
import 'fiche_list_screen.dart';
import 'home_screen.dart';
import 'relances_screen.dart';
import 'settings_screen.dart';
import 'OutingsScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FicheListScreen(),
    const OutingsScreen(),
    const RelancesScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1), // ✅ No white background
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNav(screenWidth, isSmallScreen),
    );
  }

  Widget _buildBottomNav(double screenWidth, bool isSmallScreen) {
    final items = [
      {'icon': Icons.home_outlined,        'activeIcon': Icons.home,        'label': 'home'.tr,       'badge': null},
      {'icon': Icons.people_outline,       'activeIcon': Icons.people,      'label': 'prospects'.tr,  'badge': null},
      {'icon': Icons.route_outlined,       'activeIcon': Icons.route,       'label': 'outings'.tr,    'badge': null},
      {'icon': Icons.access_time_outlined, 'activeIcon': Icons.access_time, 'label': 'follow_ups'.tr, 'badge': null},
      {'icon': Icons.settings_outlined,    'activeIcon': Icons.settings,    'label': 'settings'.tr,   'badge': null},
    ];

    final double navMargin  = isSmallScreen ? 12.0 : 16.0;
    final double navPadding = isSmallScreen ? 8.0  : 12.0;
    final double navHeight  = isSmallScreen ? 60   : 65;
    final double iconSize   = isSmallScreen ? 20   : 22;
    const double borderRadius = 30;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: navMargin, vertical: navPadding),
      child: Container(
        height: navHeight,
        decoration: BoxDecoration(
          color: Colors.white, // ✅ Keep white background for nav bar
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4,  offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((entry) {
            final index    = entry.key;
            final item     = entry.value;
            final isActive = _selectedIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            isActive
                                ? (item['activeIcon'] as IconData)
                                : (item['icon'] as IconData),
                            color: isActive ? AppColors.primaryGreen : AppColors.textTertiary,
                            size: iconSize,
                          ),
                          if (item['badge'] != null && !isActive)
                            Positioned(
                              top: -6, right: -10,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: AppColors.badgeOrange,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${item['badge']}',
                                  style: const TextStyle(
                                    color: AppColors.textOnPrimary,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize:   isSmallScreen ? 10 : 11,
                          color:      isActive ? AppColors.primaryGreen : AppColors.textTertiary,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}