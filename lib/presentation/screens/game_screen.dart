/// Presentation Layer - Game Screen
///
/// Main in-game screen with table, cards, and player interactions.
library;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/localization/localization_service.dart';
import '../cubit/cubits.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

/// Main game screen
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late AnimationController _dealAnimController;

  @override
  void initState() {
    super.initState();
    _dealAnimController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _dealAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameUiState>(
      builder: (context, state) {
        context.locale; // Register dependency for easy_localization rebuild
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              _showExitDialog(context);
            }
          },
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.tableGradient,
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    TopBar(
                      state: state,
                      onMenuPressed: () => _showGameMenu(context, state),
                      onScoreboardPressed: () =>
                          _showScoreboard(context, state),
                      onRoomCodeTap: () => _copyRoomCode(context, state),
                    ),
                    Expanded(
                      child: GameContent(state: state),
                    ),
                    if (state.localPlayer != null && state.isPlaying)
                      PlayerHandView(state: state),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.gameLeaveTitle),
        content: Text(AppStrings.gameLeaveMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.gameCancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<GameCubit>().leaveGame();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(AppStrings.gameLeave),
          ),
        ],
      ),
    );
  }

  void _showGameMenu(BuildContext context, GameUiState state) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.leaderboard),
              title: Text(AppStrings.gameScoreboard),
              onTap: () {
                Navigator.pop(context);
                _showScoreboard(context, state);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppStrings.gameSettings),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: AppColors.error),
              title: Text(AppStrings.gameLeaveGame,
                  style: const TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(context);
                _showExitDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showScoreboard(BuildContext context, GameUiState state) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ScoreboardWidget(
            players: state.players,
            localPlayerId: state.localPlayerId,
          ),
        ),
      ),
    );
  }

  void _copyRoomCode(BuildContext context, GameUiState state) {
    final gameCubit = context.read<GameCubit>();
    final textToCopy = gameCubit.currentMode == GameMode.lan
        ? gameCubit.connectionInfo
        : state.roomCode;
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.gameCopied),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
