/// Presentation Layer - Lobby Widgets - Online Join
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../cubit/cubits.dart';
import '../../theme/app_theme.dart';
import '../../../core/localization/localization_service.dart';
import '../../../core/utils/uppercase_text_formatter.dart';

/// Online room code entry
class OnlineJoin extends StatelessWidget {
  final GameCubit cubit;
  final TextEditingController roomCodeController;
  final VoidCallback onJoin;

  const OnlineJoin({
    super.key,
    required this.cubit,
    required this.roomCodeController,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Join room illustration
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
          ),
          child: const Icon(
            Icons.login,
            size: 50,
            color: AppColors.secondary,
          ),
        ),

        const SizedBox(height: 24),

        Text(
          AppStrings.lobbyEnterRoomCode,
          style: AppTypography.titleMedium,
        ),

        const SizedBox(height: 16),

        // Room code input
        TextField(
          controller: roomCodeController,
          decoration: InputDecoration(
            labelText: AppStrings.lobbyRoomCode,
            prefixIcon: const Icon(Icons.vpn_key),
            hintText: AppStrings.lobbyRoomCodeHint,
          ),
          textCapitalization: TextCapitalization.characters,
          maxLength: 4,
          textAlign: TextAlign.center,
          style: AppTypography.headlineMedium.copyWith(letterSpacing: 4),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
            UpperCaseTextFormatter(),
          ],
        ),

        const SizedBox(height: 24),

        // Join button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: cubit.state.isConnecting ? null : onJoin,
            icon: cubit.state.isConnecting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.login),
            label: Text(cubit.state.isConnecting
                ? AppStrings.lobbyJoining
                : AppStrings.lobbyJoinRoomBtn),
          ),
        ),
      ],
    );
  }
}
