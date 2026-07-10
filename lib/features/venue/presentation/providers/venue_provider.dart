import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/venue_model.dart';
import '../../../../core/data/mock_database.dart';

final venueListProvider = Provider<List<VenueModel>>((ref) {
  return MockDatabase.venues;
});

final searchFilterProvider = StateProvider<String>((ref) => '');
final categoryFilterProvider = StateProvider<String>((ref) => 'All');

final filteredVenuesProvider = Provider<List<VenueModel>>((ref) {
  final venues = ref.watch(venueListProvider);
  final searchQuery = ref.watch(searchFilterProvider).toLowerCase();
  final category = ref.watch(categoryFilterProvider);

  return venues.where((venue) {
    final matchesSearch = venue.name.toLowerCase().contains(searchQuery) ||
        venue.location.toLowerCase().contains(searchQuery);
    
    final matchesCategory = category == 'All' || venue.tags.contains(category);

    return matchesSearch && matchesCategory;
  }).toList();
});

final trendingVenuesProvider = Provider<List<VenueModel>>((ref) {
  final venues = ref.watch(venueListProvider);
  return venues.where((v) => v.isTrending).toList();
});

final liveMusicVenuesProvider = Provider<List<VenueModel>>((ref) {
  final venues = ref.watch(venueListProvider);
  return venues.where((v) => v.isLiveMusic).toList();
});
