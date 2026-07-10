import 'package:flutter/material.dart';
import '../models/venue_model.dart';
import '../models/booking_model.dart';

class MockDatabase {
  static final List<BookingModel> userBookings = [];
  static final List<String> favoriteVenueIds = [];

  static final List<VenueModel> venues = [
    VenueModel(
      id: 'v1',
      name: 'Skyline Rooftop Lounge',
      imageUrl: 'https://images.unsplash.com/photo-1572116469696-31de0f17cc34?q=80&w=1000&auto=format&fit=crop',
      rating: 4.8,
      distance: '1.2 km',
      location: 'Financial District',
      priceRange: 'High End',
      description: 'Experience the city from above at Skyline. Enjoy craft cocktails, deep house beats, and an uninterrupted 360-degree view of the metropolis. Perfect for upscale nights out and VIP experiences.',
      occupancy: 'Moderate',
      occupancyPercentage: 0.65,
      tags: ['Rooftop', 'DJ', 'Cocktails', 'Upscale'],
      isTrending: true,
      amenities: [
        {'icon': Icons.music_note, 'title': 'Live DJ'},
        {'icon': Icons.local_bar, 'title': 'Mixology'},
        {'icon': Icons.ac_unit, 'title': 'AC'},
        {'icon': Icons.smoking_rooms, 'title': 'Smoking Area'},
      ],
      tables: [
        TableModel(id: 't1', name: 'VIP Balcony 1', capacity: 6, minimumSpend: 500, leftPos: 50, topPos: 100, isVIP: true, floorLevel: 2),
        TableModel(id: 't2', name: 'VIP Balcony 2', capacity: 6, minimumSpend: 500, leftPos: 150, topPos: 100, isVIP: true, isAvailable: false, floorLevel: 2),
        TableModel(id: 't3', name: 'High Top A', capacity: 4, minimumSpend: 200, leftPos: 80, topPos: 220, floorLevel: 1),
        TableModel(id: 't4', name: 'High Top B', capacity: 4, minimumSpend: 200, leftPos: 180, topPos: 220, floorLevel: 1),
        TableModel(id: 't5', name: 'Dance Floor Booth', capacity: 8, minimumSpend: 800, leftPos: 120, topPos: 320, isDanceFloor: true, floorLevel: 1),
        TableModel(id: 't6', name: 'Sky Deck Premium', capacity: 10, minimumSpend: 1500, leftPos: 100, topPos: 150, isVIP: true, floorLevel: 3),
      ],
    ),
    VenueModel(
      id: 'v2',
      name: 'The Underground Vault',
      imageUrl: 'https://images.unsplash.com/photo-1566417713940-fe7c737a9ef2?q=80&w=1000&auto=format&fit=crop',
      rating: 4.6,
      distance: '2.5 km',
      location: 'Downtown',
      priceRange: 'Moderate',
      description: 'Hidden beneath the historic bank building, The Vault offers an intimate speakeasy vibe with rare spirits and jazz performances.',
      occupancy: 'High',
      occupancyPercentage: 0.90,
      tags: ['Speakeasy', 'Jazz', 'Intimate', 'Spirits'],
      isTrending: false,
      isLiveMusic: true,
      amenities: [
        {'icon': Icons.mic, 'title': 'Live Jazz'},
        {'icon': Icons.local_drink, 'title': 'Rare Spirits'},
        {'icon': Icons.no_photography, 'title': 'No Flash'},
      ],
      tables: [
        TableModel(id: 'v2_t1', name: 'Vault 1', capacity: 2, minimumSpend: 150, leftPos: 60, topPos: 150),
        TableModel(id: 'v2_t2', name: 'Vault 2', capacity: 2, minimumSpend: 150, leftPos: 160, topPos: 150, isAvailable: false),
        TableModel(id: 'v2_t3', name: 'Corner Booth', capacity: 5, minimumSpend: 300, leftPos: 100, topPos: 250),
      ],
    ),
    VenueModel(
      id: 'v3',
      name: 'Neon Warehouse',
      imageUrl: 'https://images.unsplash.com/photo-1545128485-c400e7702796?q=80&w=1000&auto=format&fit=crop',
      rating: 4.9,
      distance: '4.0 km',
      location: 'Industrial District',
      priceRange: 'High End',
      description: 'The city\'s largest techno club. State of the art sound system, laser light shows, and international headliners every weekend.',
      occupancy: 'Very High',
      occupancyPercentage: 0.98,
      tags: ['Club', 'Techno', 'Dance', 'Loud'],
      isTrending: true,
      amenities: [
        {'icon': Icons.speaker, 'title': 'L-Acoustics'},
        {'icon': Icons.lightbulb, 'title': 'Laser Show'},
        {'icon': Icons.local_taxi, 'title': 'Valet'},
      ],
      tables: [
        TableModel(id: 'v3_t1', name: 'Stage VIP', capacity: 10, minimumSpend: 2000, leftPos: 150, topPos: 80, isVIP: true, floorLevel: 2),
        TableModel(id: 'v3_t2', name: 'Balcony VIP', capacity: 8, minimumSpend: 1500, leftPos: 250, topPos: 120, isVIP: true, floorLevel: 2),
        TableModel(id: 'v3_t3', name: 'Dancefloor Table 1', capacity: 6, minimumSpend: 800, leftPos: 100, topPos: 250, isDanceFloor: true, floorLevel: 1),
        TableModel(id: 'v3_t4', name: 'Dancefloor Table 2', capacity: 6, minimumSpend: 800, leftPos: 200, topPos: 250, isDanceFloor: true, floorLevel: 1),
        TableModel(id: 'v3_t5', name: 'Owner Lounge', capacity: 15, minimumSpend: 5000, leftPos: 120, topPos: 120, isVIP: true, floorLevel: 3),
      ],
    ),
    VenueModel(
      id: 'v4',
      name: 'Hop Garden Brewery',
      imageUrl: 'https://picsum.photos/800/600?random=1',
      rating: 4.5,
      distance: '0.8 km',
      location: 'East Side',
      priceRange: 'Low',
      description: 'Casual outdoor brewery featuring 40 taps of local craft beer, food trucks, and lawn games.',
      occupancy: 'Low',
      occupancyPercentage: 0.30,
      tags: ['Brewery', 'Casual', 'Outdoor', 'Beer'],
      isLiveMusic: true,
      amenities: [
        {'icon': Icons.sports_bar, 'title': 'Craft Beer'},
        {'icon': Icons.restaurant, 'title': 'Food Trucks'},
        {'icon': Icons.pets, 'title': 'Pet Friendly'},
      ],
      tables: [
        TableModel(id: 'v4_t1', name: 'Picnic Table 1', capacity: 8, minimumSpend: 0, leftPos: 80, topPos: 100),
        TableModel(id: 'v4_t2', name: 'Picnic Table 2', capacity: 8, minimumSpend: 0, leftPos: 200, topPos: 100),
        TableModel(id: 'v4_t3', name: 'Firepit 1', capacity: 6, minimumSpend: 0, leftPos: 140, topPos: 220),
      ],
    ),
  ];
}
