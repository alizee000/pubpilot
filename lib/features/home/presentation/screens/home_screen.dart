import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../venue/presentation/providers/venue_provider.dart';
import '../../../../core/models/venue_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingVenues = ref.watch(trendingVenuesProvider);
    final liveMusicVenues = ref.watch(liveMusicVenuesProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: AppColors.background.withOpacity(0.9),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              title: const Text(
                'NightPulse AI',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.auto_awesome, color: AppColors.accent),
                onPressed: () => context.push(AppRoutes.aiConcierge),
              ).animate().shimmer(duration: 2000.ms, curve: Curves.easeInOut),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What are you planning tonight?',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ).animate().fadeIn().slideX(),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.vibeFeed),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.play_circle_fill, color: Colors.white),
                          const SizedBox(width: 8),
                          const Text('Watch Live Vibe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(duration: 2000.ms),
                  ),
                  const SizedBox(height: 24),
                  _buildSearchBar(context, ref),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Trending This Week', context),
                  const SizedBox(height: 16),
                  _buildHorizontalList(trendingVenues),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Live Music', context),
                  const SizedBox(height: 16),
                  _buildHorizontalList(liveMusicVenues),
                  const SizedBox(height: 80), // Bottom nav padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, WidgetRef ref) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (val) {
                ref.read(searchFilterProvider.notifier).state = val;
              },
              onSubmitted: (_) {
                // Navigate to explore screen index 1 in bottom nav
                // Actually easier to just stay here and let the user tap Explore tab, 
                // or we can use go_router if we had deep linking to tabs.
              },
              decoration: InputDecoration(
                hintText: 'Search pubs, clubs, events...',
                hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: IconButton(
              icon: const Icon(Icons.mic, color: Colors.white, size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'See All',
            style: TextStyle(color: AppColors.accent),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildHorizontalList(List<VenueModel> venues) {
    if (venues.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text('No venues found', style: TextStyle(color: AppColors.textSecondary))),
      );
    }
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: venues.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: _buildVenueCard(venues[index], context),
          );
        },
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildVenueCard(VenueModel venue, BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/venue/${venue.id}'),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(venue.imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              AppColors.background.withOpacity(0.8),
            ],
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              venue.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  venue.rating.toString(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
