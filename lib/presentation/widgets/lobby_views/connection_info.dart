/// Presentation Layer - Lobby Widgets - Connection Info
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../cubit/cubits.dart';
import '../../theme/app_theme.dart';
import '../../../core/localization/localization_service.dart';

/// Connection info display for host
class ConnectionInfo extends StatelessWidget {
  final GameCubit cubit;
  final bool isLan;

  const ConnectionInfo({
    super.key,
    required this.cubit,
    required this.isLan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            isLan ? AppStrings.lobbyShareWithFriends : AppStrings.lobbyRoomCode,
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 12),
          if (isLan) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi, color: AppColors.secondary),
                const SizedBox(width: 8),
                Text(
                  cubit.connectionInfo,
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.secondary,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _copyToClipboard(context, cubit.connectionInfo),
              icon: const Icon(Icons.copy, size: 18),
              label: Text(AppStrings.lobbyCopy),
            ),
          ] else ...[
            Text(
              cubit.state.roomCode,
              style: AppTypography.displayMedium.copyWith(
                color: AppColors.secondary,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _copyToClipboard(context, cubit.state.roomCode),
              icon: const Icon(Icons.copy, size: 18),
              label: Text(AppStrings.lobbyCopyCode),
            ),
          ],
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.gameCopied),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
