import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../venue/presentation/providers/venue_provider.dart';

class VibeFeedScreen extends ConsumerWidget {
  const VibeFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venues = ref.watch(trendingVenuesProvider);
    
    // Fallback if no trending venues
    final feedItems = venues.isNotEmpty ? venues : ref.watch(venueListProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 30),
          onPressed: () => context.pop(),
        ),
        title: const Text('Live Vibe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: feedItems.length,
        itemBuilder: (context, index) {
          final venue = feedItems[index];
          return Stack(
            fit: StackFit.expand,
            children: [
              // Mock Video Background
              Image.network(
                venue.imageUrl,
                fit: BoxFit.cover,
              ),
              // Gradient Overlay for readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              // Venue Info Overlay
              Positioned(
                bottom: 40,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.fiber_manual_record, color: Colors.white, size: 12),
                              SizedBox(width: 4),
                              Text('LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        ).animate(onPlay: (controller) => controller.repeat(reverse: true)).fade(begin: 1.0, end: 0.5),
                        const SizedBox(width: 8),
                        Text('1.2k watching', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      venue.name,
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ).animate().fadeIn().slideX(begin: -0.1),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.music_note, color: AppColors.accent, size: 16),
                        const SizedBox(width: 8),
                        const Text('Playing: Midnight City - M83', style: TextStyle(color: AppColors.textSecondary)),
                      ],
                    ).animate().fadeIn().slideX(begin: -0.1, delay: 100.ms),
                    const SizedBox(height: 24),
                    GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Feeling this vibe?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                Text('${venue.distance} away', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () {
                                context.push('/venue/${venue.id}');
                              },
                              child: const Text('Book Table', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn().slideY(begin: 0.2, delay: 200.ms),
                  ],
                ),
              ),
              // Right side action buttons
              Positioned(
                right: 16,
                bottom: 200,
                child: Column(
                  children: [
                    _buildActionButton(Icons.favorite, '12k'),
                    const SizedBox(height: 24),
                    _buildActionButton(Icons.share, 'Share'),
                    const SizedBox(height: 24),
                    _buildActionButton(Icons.map, 'Map', onTap: () {
                      context.push('/venue/${venue.id}');
                    }),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
