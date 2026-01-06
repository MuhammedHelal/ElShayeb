/// Presentation Layer - Card Selection Overlay Widget
///
/// Full-screen overlay for selecting a card from opponent's hand.
/// Shows cards face-down in a fan layout for selection.
library;

import 'package:flutter/material.dart';

import '../../../core/localization/localization_service.dart';
import '../../../domain/entities/entities.dart';
import '../../theme/app_theme.dart';
import '../common/playing_card_widget.dart';

/// Overlay for selecting a card from opponent's hand
class CardSelectionOverlay extends StatefulWidget {
  final Player targetPlayer;
  final VoidCallback onCancel;
  final void Function(int index) onCardSelected;

  const CardSelectionOverlay({
    super.key,
    required this.targetPlayer,
    required this.onCancel,
    required this.onCardSelected,
  });

  @override
  State<CardSelectionOverlay> createState() => _CardSelectionOverlayState();
}

class _CardSelectionOverlayState extends State<CardSelectionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardCount = widget.targetPlayer.hand.length;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: Colors.black.withOpacity(0.85),
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Close button
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: widget.onCancel,
                            icon: const Icon(Icons.close, size: 28),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.surface,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Player info
                        _buildPlayerInfo(),

                        const SizedBox(height: 24),

                        // Instructions
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.goldGradient,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.touch_app,
                                  color: AppColors.textDark),
                              const SizedBox(width: 8),
                              Text(
                                AppStrings.gameYourTurn,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Cards area
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildCardFan(cardCount),
                    ),
                  ),

                  // Bottom padding
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Avatar
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.secondary,
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.5),
                blurRadius: 16,
              ),
            ],
          ),
          child: Center(
            child: Text(
              _getAvatarEmoji(widget.targetPlayer.avatarId),
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  maxLines: 1,
                  AppStrings.cardChooseFrom(widget.targetPlayer.name),
                  style: AppTypography.headlineMedium,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                AppStrings.cardCardsCount(widget.targetPlayer.cardCount),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardFan(int cardCount) {
    if (cardCount == 0) {
      return Text(AppStrings.cardNoCards);
    }

    // Calculate layout based on card count
    const double maxSpread = 280;
    const double cardWidth = 80;
    final double overlap =
        cardCount > 1 ? (maxSpread - cardWidth) / (cardCount - 1) : 0;
    final double totalWidth = cardWidth + overlap * (cardCount - 1);
    final double startOffset = -totalWidth / 2 + cardWidth / 2;

    return SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: List.generate(cardCount, (index) {
          final isHovered = _hoveredIndex == index;
          final xOffset = startOffset + index * overlap;

          // Calculate rotation for fan effect
          final normalizedIndex = cardCount > 1
              ? (index - (cardCount - 1) / 2) / ((cardCount - 1) / 2)
              : 0.0;
          final rotation = normalizedIndex * 0.1;

          return AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            left:
                MediaQuery.of(context).size.width / 2 + xOffset - cardWidth / 2,
            top: isHovered ? 0 : 20,
            child: GestureDetector(
              onTap: () => widget.onCardSelected(index),
              onTapDown: (_) => setState(() => _hoveredIndex = index),
              onTapCancel: () => setState(() => _hoveredIndex = null),
              onTapUp: (_) => setState(() => _hoveredIndex = null),
              child: AnimatedScale(
                scale: isHovered ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Transform.rotate(
                  angle: rotation,
                  child: Container(
                    width: cardWidth,
                    height: cardWidth * 1.45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: isHovered
                              ? AppColors.secondary.withOpacity(0.6)
                              : Colors.black.withOpacity(0.3),
                          blurRadius: isHovered ? 20 : 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          // Card back
                          const PlayingCardWidget(
                            card: null,
                            faceUp: false,
                            width: 80,
                          ),

                          // Selection indicator
                          if (isHovered)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.secondary,
                                  width: 3,
                                ),
                              ),
                            ),

                          // Card number
                          Positioned(
                            bottom: 8,
                            left: 0,
                            right: 0,
                            child: Text(
                              '${index + 1}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  String _getAvatarEmoji(String avatarId) {
    final avatars = ['😀', '😎', '🤠', '👨‍💻', '👩‍🎤', '🧔'];
    final index = int.tryParse(avatarId.split('_').last) ?? 1;
    return avatars[(index - 1).clamp(0, avatars.length - 1)];
  }
}
