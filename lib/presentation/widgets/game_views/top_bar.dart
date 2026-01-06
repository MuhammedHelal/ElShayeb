/// Presentation Layer - Game Widgets - Top Bar
library;

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubits.dart';
import '../../theme/app_theme.dart';

/// Top bar with menu, room code, and scoreboard
class TopBar extends StatelessWidget {
  final GameUiState state;
  final VoidCallback onMenuPressed;
  final VoidCallback onScoreboardPressed;
  final VoidCallback onRoomCodeTap;

  const TopBar({
    super.key,
    required this.state,
    required this.onMenuPressed,
    required this.onScoreboardPressed,
    required this.onRoomCodeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onMenuPressed,
            icon: const Icon(Icons.menu),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surface.withOpacity(0.5),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onRoomCodeTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.secondary.withOpacity(0.3),
                  ),
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      context.read<GameCubit>().connectionInfo,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onScoreboardPressed,
            icon: const Icon(Icons.leaderboard),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
