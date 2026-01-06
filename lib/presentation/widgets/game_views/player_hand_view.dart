/// Presentation Layer - Game Widgets - Player Hand View
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubits.dart';
import '../../theme/app_theme.dart';
import '../../../core/localization/localization_service.dart';
import '../widgets.dart';

// Player's hand at bottom of screen
class PlayerHandView extends StatelessWidget {
  final GameUiState state;

  const PlayerHandView({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final localPlayer = state.localPlayer;
    if (localPlayer == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (localPlayer.isPlaying && localPlayer.hand.length > 1)
            TextButton.icon(
              onPressed: () => context.read<GameCubit>().shuffleHand(),
              icon: const Icon(Icons.shuffle,
                  size: 16, color: AppColors.secondary),
              label: Text(
                AppStrings.gameShuffleHand,
                style: AppTypography.labelLarge
                    .copyWith(color: AppColors.secondary),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.surface.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          PlayerHandWidget(
            cards: localPlayer.hand,
            selectedIndex: state.selectedCardIndex,
            matchedCardIds: state.matchedCardIds,
            isInteractive: state.isMyTurn && state.drawPhase == DrawPhase.idle,
            onCardTap: (index) => context.read<GameCubit>().selectCard(index),
            maxWidth: MediaQuery.of(context).size.width - 32,
          ),
        ],
      ),
    );
  }
}
