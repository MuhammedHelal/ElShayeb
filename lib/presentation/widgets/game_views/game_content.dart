/// Presentation Layer - Game Widgets - Game Content
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubits.dart';
import '../../../domain/entities/entities.dart';
import '../widgets.dart';

// Routes to correct game phase view
class GameContent extends StatelessWidget {
  final GameUiState state;

  const GameContent({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    switch (state.phase) {
      case GamePhase.lobby:
        return LobbyView(state: state);
      case GamePhase.dealing:
        return DealingAnimationOverlay(
          players: state.players,
          localPlayerId: state.localPlayerId,
          onComplete: () => context.read<GameCubit>().onDealAnimationComplete(),
        );
      case GamePhase.playing:
        return PlayingView(state: state);
      case GamePhase.roundEnd:
      case GamePhase.gameEnd:
        return RoundEndView(state: state);
    }
  }
}
