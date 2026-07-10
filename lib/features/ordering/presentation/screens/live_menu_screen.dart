import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neon_button.dart';
import '../providers/cart_provider.dart';

class LiveMenuScreen extends ConsumerWidget {
  final String bookingId;
  const LiveMenuScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock menu data
    final menuItems = [
      MenuItem(id: '1', name: 'Neon Margarita', price: 18.0, description: 'Tequila, Lime, Blue Curacao', imageUrl: 'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?auto=format&fit=crop&w=400&q=80'),
      MenuItem(id: '2', name: 'Cyberpunk Old Fashioned', price: 22.0, description: 'Smoked Bourbon, Bitters', imageUrl: 'https://images.unsplash.com/photo-1597075687490-8f673c6c17f6?auto=format&fit=crop&w=400&q=80'),
      MenuItem(id: '3', name: 'Electric Lemonade', price: 15.0, description: 'Vodka, Lemon, Sprite', imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=400&q=80'),
      MenuItem(id: '4', name: 'VIP Bottle Service', price: 250.0, description: 'Premium Vodka, Mixers, Sparklers', imageUrl: 'https://picsum.photos/400/400?random=3'),
    ];

    final cartItems = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Menu', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final cartItem = cartItems.firstWhere((c) => c.menu.id == item.id, orElse: () => CartItem(menu: item, quantity: 0));
                
                return _buildMenuItemCard(context, ref, item, cartItem.quantity).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.1);
              },
            ),
          ),
          if (cartItems.isNotEmpty)
            _buildCartSummary(context, ref, total).animate().slideY(begin: 1.0, end: 0.0),
        ],
      ),
    );
  }

  Widget _buildMenuItemCard(BuildContext context, WidgetRef ref, MenuItem item, int quantity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: Image.network(item.imageUrl, width: 100, height: 100, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(item.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          if (quantity > 0)
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary),
                              onPressed: () => ref.read(cartProvider.notifier).removeItem(item.id),
                            ),
                          if (quantity > 0)
                            Text('$quantity', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: AppColors.primary),
                            onPressed: () => ref.read(cartProvider.notifier).addItem(item),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, WidgetRef ref, double total) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(color: AppColors.textSecondary, fontSize: 18)),
                Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),
            NeonButton(
              text: 'Send to Table',
              onPressed: () {
                // Simulate order sending
                ref.read(cartProvider.notifier).clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order Sent! The bartender is preparing your drinks.'),
                    backgroundColor: AppColors.primary,
                  ),
                );
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
