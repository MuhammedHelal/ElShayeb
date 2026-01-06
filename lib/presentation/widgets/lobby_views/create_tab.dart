/// Presentation Layer - Lobby Widgets - Create Tab
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubits.dart';
import '../../theme/app_theme.dart';
import '../../../core/localization/localization_service.dart';
import 'connection_info.dart';

/// Create room tab
class CreateTab extends StatelessWidget {
  final GameCubit cubit;
  final TextEditingController nameController;
  final VoidCallback onCreateGame;

  const CreateTab({
    super.key,
    required this.cubit,
    required this.nameController,
    required this.onCreateGame,
  });

  @override
  Widget build(BuildContext context) {
    final isLan = cubit.currentMode == GameMode.lan;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 32),

          // Create room illustration
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.3),
                  blurRadius: 20,
                ),
              ],
            ),
            child: const Icon(
              Icons.add_circle_outline,
              size: 60,
              color: AppColors.secondary,
            ),
          ),

          const SizedBox(height: 32),

          Text(
            AppStrings.lobbyCreateNewRoom,
            style: AppTypography.headlineMedium,
          ),

          const SizedBox(height: 8),

          Text(
            isLan ? AppStrings.lobbyHostLocal : AppStrings.lobbyHostOnline,
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Player name input
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: AppStrings.lobbyYourName,
              prefixIcon: const Icon(Icons.person),
            ),
            onChanged: (value) {
              context.read<SettingsCubit>().setPlayerName(value);
            },
          ),

          const SizedBox(height: 32),

          // Create button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: cubit.state.isConnecting ? null : onCreateGame,
              icon: cubit.state.isConnecting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(cubit.state.isConnecting
                  ? AppStrings.lobbyCreating
                  : AppStrings.lobbyCreateRoomBtn),
            ),
          ),

          // Show connection info after room is created
          if (cubit.state.isHost && cubit.state.gameState != null) ...[
            const SizedBox(height: 24),
            ConnectionInfo(cubit: cubit, isLan: isLan),
          ],
        ],
      ),
    );
  }
}
