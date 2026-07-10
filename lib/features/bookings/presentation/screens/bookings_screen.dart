import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/neon_button.dart';
import '../../../../core/navigation/routes.dart';
import 'package:go_router/go_router.dart';
import '../providers/booking_provider.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingBookings = ref.watch(upcomingBookingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Bookings',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: upcomingBookings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'No upcoming bookings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: upcomingBookings.length,
              itemBuilder: (context, index) {
                final booking = upcomingBookings[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                booking.venueName,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.primary),
                                ),
                                child: const Text('Confirmed', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: AppColors.accent, size: 16),
                              const SizedBox(width: 8),
                              Text('${booking.date.toLocal().toString().split(' ')[0]} at ${booking.time}', style: const TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.table_restaurant, color: AppColors.accent, size: 16),
                              const SizedBox(width: 8),
                              Text('${booking.tableName} • ${booking.guests} Guests', style: const TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          NeonButton(
                            text: 'Open Tab / Order Now',
                            onPressed: () {
                              context.push(AppRoutes.liveMenu.replaceFirst(':bookingId', booking.id));
                            },
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                ref.read(bookingProvider.notifier).cancelBooking(booking.id);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking Cancelled')));
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Cancel Booking'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
