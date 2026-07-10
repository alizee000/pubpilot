import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

class NeonQRCode extends StatelessWidget {
  const NeonQRCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Simulate QR Code with a grid pattern
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: 36,
            itemBuilder: (context, index) {
              final isSolid = (index % 2 == 0 || index % 3 == 0) && index != 15;
              return Container(
                decoration: BoxDecoration(
                  color: isSolid ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          ),
          // Scanning Line
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.accent,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.8),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).slideY(begin: 0, end: 40, duration: 2.seconds),
          ),
        ],
      ),
    );
  }
}
