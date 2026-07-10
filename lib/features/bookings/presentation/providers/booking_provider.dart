import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/booking_model.dart';
import '../../../../core/data/mock_database.dart';
import 'package:uuid/uuid.dart';

class BookingNotifier extends StateNotifier<List<BookingModel>> {
  BookingNotifier() : super(MockDatabase.userBookings);

  void addBooking(BookingModel booking) {
    state = [...state, booking];
    MockDatabase.userBookings.add(booking);
  }

  void cancelBooking(String bookingId) {
    state = [
      for (final booking in state)
        if (booking.id == bookingId)
          BookingModel(
            id: booking.id,
            venueId: booking.venueId,
            venueName: booking.venueName,
            tableId: booking.tableId,
            tableName: booking.tableName,
            date: booking.date,
            time: booking.time,
            guests: booking.guests,
            status: BookingStatus.cancelled,
          )
        else
          booking,
    ];
    // Update mock db
    final index = MockDatabase.userBookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      MockDatabase.userBookings[index] = state.firstWhere((b) => b.id == bookingId);
    }
  }
}

final bookingProvider = StateNotifierProvider<BookingNotifier, List<BookingModel>>((ref) {
  return BookingNotifier();
});

final upcomingBookingsProvider = Provider<List<BookingModel>>((ref) {
  final bookings = ref.watch(bookingProvider);
  return bookings.where((b) => b.status == BookingStatus.confirmed).toList();
});

final pastBookingsProvider = Provider<List<BookingModel>>((ref) {
  final bookings = ref.watch(bookingProvider);
  return bookings.where((b) => b.status != BookingStatus.confirmed).toList();
});
