import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/neon_button.dart';
import '../../../../core/navigation/routes.dart';
import '../providers/venue_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../../core/models/venue_model.dart';

class VenueDetailsScreen extends ConsumerWidget {
  final String id;
  const VenueDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venues = ref.watch(venueListProvider);
    final venue = venues.firstWhere((v) => v.id == id, orElse: () => venues.first);
    final isFavorite = ref.watch(favoritesProvider).contains(venue.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.white), 
                onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(venue.id)
              ),
              IconButton(icon: const Icon(Icons.share, color: Colors.white), onPressed: () {}),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(venue.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    venue.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          AppColors.background,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(venue.location, style: const TextStyle(color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          const Text('Open Now • Closes at 3 AM', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(venue.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ).animate().fadeIn().slideX(),
                  const SizedBox(height: 32),
                  const Text('About', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 12),
                  Text(
                    venue.description,
                    style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 32),
                  const Text('Live Occupancy', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 16),
                  _buildOccupancyIndicator(venue).animate().fadeIn(delay: 500.ms),
                  const SizedBox(height: 32),
                  const Text('Amenities', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)).animate().fadeIn(delay: 600.ms),
                  const SizedBox(height: 16),
                  _buildAmenities(venue).animate().fadeIn(delay: 700.ms),
                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.9),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -10)),
          ],
        ),
        child: NeonButton(
          text: 'Book Table',
          onPressed: () {
            // Context push to floor map
            context.push('/interactive-map/$id');
          },
        ),
      ),
    );
  }

  Widget _buildOccupancyIndicator(VenueModel venue) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(venue.occupancy, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Live data', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
          SizedBox(
            width: 100,
            height: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: venue.occupancyPercentage,
                backgroundColor: AppColors.surface,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenities(VenueModel venue) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: venue.amenities.map((a) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Icon(a['icon'] as IconData, color: AppColors.accent),
            ),
            const SizedBox(height: 8),
            Text(a['title'] as String, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }
}
