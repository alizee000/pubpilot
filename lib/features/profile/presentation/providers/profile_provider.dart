import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/mock_database.dart';
import '../../../../core/models/venue_model.dart';
import '../../../venue/presentation/providers/venue_provider.dart';

class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier() : super(MockDatabase.favoriteVenueIds);

  void toggleFavorite(String venueId) {
    if (state.contains(venueId)) {
      state = state.where((id) => id != venueId).toList();
      MockDatabase.favoriteVenueIds.remove(venueId);
    } else {
      state = [...state, venueId];
      MockDatabase.favoriteVenueIds.add(venueId);
    }
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  return FavoritesNotifier();
});

final neonCoinsProvider = StateProvider<int>((ref) => 1250); // Starting mock balance

final favoriteVenuesListProvider = Provider<List<VenueModel>>((ref) {
  final favoriteIds = ref.watch(favoritesProvider);
  final allVenues = ref.watch(venueListProvider);
  
  return allVenues.where((v) => favoriteIds.contains(v.id)).toList();
});
