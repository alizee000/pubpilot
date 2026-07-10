import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/main/presentation/screens/main_navigation_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/main/presentation/screens/main_navigation_screen.dart';
import '../../features/ai_concierge/presentation/screens/ai_concierge_screen.dart';
import '../../features/venue/presentation/screens/venue_details_screen.dart';
import '../../features/venue/presentation/screens/interactive_floor_map_screen.dart';
import '../../features/vibe/presentation/screens/vibe_feed_screen.dart';
import '../../features/ordering/presentation/screens/live_menu_screen.dart';
import 'routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: AppRoutes.aiConcierge,
        builder: (context, state) => const AiConciergeScreen(),
      ),
      GoRoute(
        path: AppRoutes.venueDetails,
        builder: (context, state) => VenueDetailsScreen(id: state.pathParameters['id'] ?? '1'),
      ),
      GoRoute(
        path: '/interactive-map/:id',
        builder: (context, state) => InteractiveFloorMapScreen(venueId: state.pathParameters['id'] ?? '1'),
      ),
      GoRoute(
        path: '/vibe',
        builder: (context, state) => const VibeFeedScreen(),
      ),
      GoRoute(
        path: AppRoutes.liveMenu,
        builder: (context, state) {
          final id = state.pathParameters['bookingId']!;
          return LiveMenuScreen(bookingId: id);
        },
      ),
      GoRoute(
        path: '/booking-success',
        builder: (context, state) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 16),
                const Text('Booking Confirmed!', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
});
