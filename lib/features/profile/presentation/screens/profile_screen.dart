import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../widgets/neon_qr_code.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteVenuesListProvider);
    final neonCoins = ref.watch(neonCoinsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassCard(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1000&auto=format&fit=crop'),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alex Nightowl',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('VIP Member', style: TextStyle(color: AppColors.accent)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.stars, color: AppColors.accent, size: 20),
                                const SizedBox(width: 4),
                                Text('${neonCoins.toString()} NeonCoins', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                const Text('Scan to Check-In & Earn', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Tap the QR code to simulate a venue check-in.', style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    ref.read(neonCoinsProvider.notifier).update((state) => state + 50);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('+50 NeonCoins! You checked in.'), backgroundColor: AppColors.primary));
                  },
                  child: const NeonQRCode(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Favorite Venues (${favorites.length})',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          if (favorites.isEmpty)
            const Text('No favorites yet. Start exploring!', style: TextStyle(color: AppColors.textSecondary))
          else
            ...favorites.map((venue) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GlassCard(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(venue.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  title: Text(venue.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(venue.location, style: const TextStyle(color: AppColors.textSecondary)),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(venue.id),
                  ),
                ),
              ),
            )),
        ],
      ),
    );
  }
}
