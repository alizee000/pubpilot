import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../venue/presentation/providers/venue_provider.dart';
import '../../../../core/models/venue_model.dart';
import 'package:go_router/go_router.dart';

class AiConciergeScreen extends ConsumerStatefulWidget {
  const AiConciergeScreen({super.key});

  @override
  ConsumerState<AiConciergeScreen> createState() => _AiConciergeScreenState();
}

class _AiConciergeScreenState extends ConsumerState<AiConciergeScreen> {
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'Hi there! I am your NightPulse Concierge. Looking for a rooftop bar, live music, or maybe a quiet pub for tonight?',
    }
  ];

  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add({
        'isUser': true,
        'text': _controller.text,
      });
      _controller.clear();
    });

    // Simulate AI typing and response
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      
      final query = _controller.text.toLowerCase();
      final allVenues = ref.read(venueListProvider);
      
      VenueModel? matchedVenue;
      for (var venue in allVenues) {
        if (venue.tags.any((tag) => query.contains(tag.toLowerCase())) || query.contains(venue.name.toLowerCase())) {
          matchedVenue = venue;
          break;
        }
      }

      setState(() {
        if (matchedVenue != null) {
          _messages.add({
            'isUser': false,
            'text': 'I found a great spot matching your vibe! Check out ${matchedVenue.name}.',
            'hasCard': true,
            'venue': matchedVenue,
          });
        } else {
          _messages.add({
            'isUser': false,
            'text': 'I couldn\'t find a specific match for that, but you can always explore the map for more options!',
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, color: AppColors.accent),
            SizedBox(width: 8),
            Text('AI Concierge'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['isUser'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isUser ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: Radius.circular(isUser ? 20 : 0),
                              bottomRight: Radius.circular(isUser ? 0 : 20),
                            ),
                          ),
                          child: Text(
                            msg['text'],
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        if (msg['hasCard'] == true && msg['venue'] != null) ...[
                          const SizedBox(height: 12),
                          _buildSuggestedVenueCard(context, msg['venue'] as VenueModel),
                        ],
                      ],
                    ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                  ),
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildSuggestedVenueCard(BuildContext context, VenueModel venue) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                venue.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(venue.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${venue.tags.first} • ${venue.distance}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ElevatedButton(
                  onPressed: () {
                    context.push('/venue/${venue.id}');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    minimumSize: const Size(60, 30),
                  ),
                  child: const Text('Book'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'e.g., Best brewery tonight...',
                hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
