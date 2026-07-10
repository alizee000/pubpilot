import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neon_button.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/venue_provider.dart';
import '../../../bookings/presentation/providers/booking_provider.dart';
import '../../../../core/models/booking_model.dart';
import '../../../../core/models/venue_model.dart';
import '../../../main/presentation/screens/main_navigation_screen.dart';
import 'package:uuid/uuid.dart';

class InteractiveFloorMapScreen extends ConsumerStatefulWidget {
  final String venueId;
  const InteractiveFloorMapScreen({super.key, required this.venueId});

  @override
  ConsumerState<InteractiveFloorMapScreen> createState() => _InteractiveFloorMapScreenState();
}

class _InteractiveFloorMapScreenState extends ConsumerState<InteractiveFloorMapScreen> {
  int? _selectedTableIndex;
  int _selectedFloor = 1;

  @override
  Widget build(BuildContext context) {
    final venues = ref.watch(venueListProvider);
    final venue = venues.firstWhere((v) => v.id == widget.venueId, orElse: () => venues.first);

    final availableFloors = venue.tables.map((t) => t.floorLevel).toSet().toList()..sort();
    final currentFloorTables = venue.tables.where((t) => t.floorLevel == _selectedFloor).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${venue.name} Floor Map'),
        backgroundColor: AppColors.background,
      ),
      body: Stack(
        children: [
          InteractiveViewer(
            minScale: 0.5,
            maxScale: 3.0,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOutCubic,
                // 3D Isometric Tilt effect based on floor
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateX(0.4) // tilt forward
                  ..rotateZ(-0.2)
                  ..translate(0.0, _selectedFloor * -20.0, 0.0), // elevate higher floors
                transformAlignment: FractionalOffset.center,
                width: 320,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 3),
                  borderRadius: BorderRadius.circular(24),
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 40,
                      spreadRadius: 10,
                      offset: const Offset(0, 20),
                    )
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                      ...currentFloorTables.asMap().entries.map((entry) {
                        return _buildTable(entry.key, entry.value);
                      }),
                  ],
                ),
              ),
            ),
          ),
          
          // Floor Selector UI
          Positioned(
            right: 16,
            top: 40,
            child: _buildFloorSelector(availableFloors),
          ),
          
          if (_selectedTableIndex != null && _selectedTableIndex! < currentFloorTables.length)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBookingSummaryPanel(venue, currentFloorTables[_selectedTableIndex!]).animate().slideY(begin: 1.0, end: 0.0),
            ),
        ],
      ),
    );
  }

  Widget _buildFloorSelector(List<int> availableFloors) {
    if (availableFloors.length <= 1) return const SizedBox.shrink();
    
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      borderRadius: 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: availableFloors.reversed.map((floor) {
          final isSelected = _selectedFloor == floor;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFloor = floor;
                _selectedTableIndex = null; // Reset selection on floor change
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.accent : AppColors.textSecondary,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  'F$floor',
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTable(int index, TableModel table) {
    final isSelected = _selectedTableIndex == index;
    final themeColor = table.isVIP ? Colors.amber : AppColors.primary;
    final displayColor = table.isAvailable ? themeColor : Colors.red.withOpacity(0.5);

    return Positioned(
      left: table.leftPos,
      top: table.topPos,
      child: GestureDetector(
        onTap: () {
          if (table.isAvailable) {
            setState(() {
              _selectedTableIndex = index;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          width: isSelected ? 65 : 50,
          height: isSelected ? 65 : 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                isSelected ? displayColor.withOpacity(0.8) : AppColors.surface,
                isSelected ? displayColor.withOpacity(0.2) : AppColors.background,
              ],
            ),
            border: Border.all(
              color: displayColor,
              width: isSelected ? 3 : (table.isVIP ? 2 : 1),
            ),
            boxShadow: [
              if (table.isAvailable)
                BoxShadow(
                  color: displayColor.withOpacity(isSelected ? 0.8 : 0.4),
                  blurRadius: isSelected ? 20 : 10,
                  spreadRadius: isSelected ? 5 : 0,
                ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (table.isVIP) 
                  const Icon(Icons.workspace_premium, color: Colors.amber, size: 12)
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .shimmer(duration: 1500.ms, color: Colors.white),
                Text(
                  table.name.contains('1') || table.name.contains('2') ? table.name.substring(0,2) : 'T',
                  style: TextStyle(
                    color: table.isAvailable ? Colors.white : Colors.white54,
                    fontWeight: FontWeight.bold,
                    fontSize: isSelected ? 14 : 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingSummaryPanel(VenueModel venue, TableModel table) {
    return GlassCard(
      borderRadius: 0,
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  table.name,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: Text('Capacity: ${table.capacity}', style: const TextStyle(color: AppColors.accent)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Minimum Spend: \$${table.minimumSpend}', style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            NeonButton(
              text: 'Confirm Booking',
              onPressed: () {
                final booking = BookingModel(
                  id: const Uuid().v4(),
                  venueId: venue.id,
                  venueName: venue.name,
                  tableId: table.id,
                  tableName: table.name,
                  date: DateTime.now(),
                  time: '10:00 PM',
                  guests: table.capacity,
                );
                ref.read(bookingProvider.notifier).addBooking(booking);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking Confirmed!'), backgroundColor: AppColors.primary),
                );
                ref.read(bottomNavIndexProvider.notifier).state = 3; // Index for Bookings
                context.go('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
