import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.description = '',
  });
}

class CartItem {
  final MenuItem menu;
  final int quantity;

  CartItem({required this.menu, required this.quantity});
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(MenuItem item) {
    final index = state.indexWhere((c) => c.menu.id == item.id);
    if (index != -1) {
      final updated = List<CartItem>.from(state);
      updated[index] = CartItem(menu: item, quantity: updated[index].quantity + 1);
      state = updated;
    } else {
      state = [...state, CartItem(menu: item, quantity: 1)];
    }
  }

  void removeItem(String itemId) {
    final index = state.indexWhere((c) => c.menu.id == itemId);
    if (index != -1) {
      final updated = List<CartItem>.from(state);
      if (updated[index].quantity > 1) {
        updated[index] = CartItem(menu: updated[index].menu, quantity: updated[index].quantity - 1);
        state = updated;
      } else {
        updated.removeAt(index);
        state = updated;
      }
    }
  }

  void clear() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

final cartTotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0, (total, item) => total + (item.menu.price * item.quantity));
});
