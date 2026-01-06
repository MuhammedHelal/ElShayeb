/// Presentation Layer - Game Widgets - Event Message Banner
library;

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

// Event message shown at top of screen
class EventMessageBanner extends StatelessWidget {
  final String message;

  const EventMessageBanner({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 300),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.secondary.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
