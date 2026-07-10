import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local storage, etc., here.
  
  runApp(
    const ProviderScope(
      child: NightPulseApp(),
    ),
  );
}

class NightPulseApp extends ConsumerWidget {
  const NightPulseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'NightPulse AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // Enforce dark theme first
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
