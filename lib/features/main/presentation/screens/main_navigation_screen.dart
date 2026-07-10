import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../explore/presentation/screens/explore_screen.dart';
import '../../../events/presentation/screens/events_screen.dart';
import '../../../bookings/presentation/screens/bookings_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final List<Widget> screens = [
      const HomeScreen(),
      const ExploreScreen(),
      const EventsScreen(),
      const BookingsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(context, ref, 0, Icons.home_rounded, 'Home'),
                _buildNavItem(context, ref, 1, Icons.explore_rounded, 'Explore'),
                _buildNavItem(context, ref, 2, Icons.event_rounded, 'Events'),
                _buildNavItem(context, ref, 3, Icons.book_online_rounded, 'Bookings'),
                _buildNavItem(context, ref, 4, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, WidgetRef ref, int index, IconData icon, String label) {
    final isSelected = ref.watch(bottomNavIndexProvider) == index;
    return GestureDetector(
      onTap: () => ref.read(bottomNavIndexProvider.notifier).state = index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.accent : AppColors.textSecondary,
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn().slideY(begin: 0.5, end: 0),
              ),
          ],
        ),
      ),
    );
  }
}
