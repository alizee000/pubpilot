import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../venue/presentation/providers/venue_provider.dart';
import '../../../../core/models/venue_model.dart';
import 'package:go_router/go_router.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredVenues = ref.watch(filteredVenuesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.accent),
            onPressed: () {
              // Open filter bottom sheet
            },
          ),
          IconButton(
            icon: const Icon(Icons.map_outlined, color: AppColors.primary),
            onPressed: () {
              // Toggle map view
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(ref).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2, end: 0),
          Expanded(
            child: filteredVenues.isEmpty 
              ? const Center(child: Text('No venues found matching filters.', style: TextStyle(color: AppColors.textSecondary)))
              : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredVenues.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildVerticalVenueCard(context, filteredVenues[index]).animate().fadeIn(delay: (300 + (index * 100)).ms),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(WidgetRef ref) {
    final filters = ['All', 'Rooftop', 'Dance', 'Beer', 'Live Music'];
    final selectedCategory = ref.watch(categoryFilterProvider);
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == filters[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(filters[index]),
              selected: isSelected,
              onSelected: (bool selected) {
                ref.read(categoryFilterProvider.notifier).state = filters[index];
              },
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary.withOpacity(0.3),
              checkmarkColor: AppColors.accent,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.accent : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerticalVenueCard(BuildContext context, VenueModel venue) {
    return GestureDetector(
      onTap: () => context.push('/venue/${venue.id}'),
      child: GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              image: DecorationImage(
                image: NetworkImage(venue.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(venue.rating.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      venue.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Icon(Icons.favorite_border, color: AppColors.textSecondary),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${venue.distance} • ${venue.location} • ${venue.priceRange}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: venue.tags.take(3).map((t) => _buildTag(t)).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.accent, fontSize: 12),
      ),
    );
  }
}
