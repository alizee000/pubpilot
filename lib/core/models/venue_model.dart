class VenueModel {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String distance;
  final String location;
  final String priceRange;
  final String description;
  final String occupancy;
  final double occupancyPercentage;
  final List<String> tags;
  final List<Map<String, dynamic>> amenities;
  final List<TableModel> tables;
  final bool isTrending;
  final bool isLiveMusic;

  VenueModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.distance,
    required this.location,
    required this.priceRange,
    required this.description,
    required this.occupancy,
    required this.occupancyPercentage,
    required this.tags,
    required this.amenities,
    required this.tables,
    this.isTrending = false,
    this.isLiveMusic = false,
  });
}

class TableModel {
  final String id;
  final String name;
  final int capacity;
  final int minimumSpend;
  final bool isVIP;
  final bool isDanceFloor;
  final double leftPos;
  final double topPos;
  final bool isAvailable;
  final int floorLevel;

  TableModel({
    required this.id,
    required this.name,
    required this.capacity,
    required this.minimumSpend,
    required this.leftPos,
    required this.topPos,
    this.isVIP = false,
    this.isDanceFloor = false,
    this.isAvailable = true,
    this.floorLevel = 1,
  });
}
