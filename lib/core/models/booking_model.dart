class BookingModel {
  final String id;
  final String venueId;
  final String venueName;
  final String tableId;
  final String tableName;
  final DateTime date;
  final String time;
  final int guests;
  final String specialRequest;
  final BookingStatus status;

  BookingModel({
    required this.id,
    required this.venueId,
    required this.venueName,
    required this.tableId,
    required this.tableName,
    required this.date,
    required this.time,
    required this.guests,
    this.specialRequest = '',
    this.status = BookingStatus.confirmed,
  });
}

enum BookingStatus { confirmed, completed, cancelled }
