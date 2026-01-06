/// Presentation Layer - Lobby Widgets - Manual Entry
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../cubit/cubits.dart';
import '../../theme/app_theme.dart';
import '../../../core/localization/localization_service.dart';

/// Manual IP/Port entry for LAN
class ManualEntry extends StatelessWidget {
  final GameCubit cubit;
  final TextEditingController addressController;
  final TextEditingController portController;
  final VoidCallback onJoin;

  const ManualEntry({
    super.key,
    required this.cubit,
    required this.addressController,
    required this.portController,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.keyboard, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              AppStrings.lobbyOrEnterManually,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: AppStrings.lobbyIpAddress,
                  hintText: '192.168.x.x',
                  prefixIcon: const Icon(Icons.computer),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: TextField(
                controller: portController,
                decoration: InputDecoration(
                  labelText: AppStrings.lobbyPort,
                  prefixIcon: const Icon(Icons.tag),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
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
