/// Presentation Layer - Lobby Widgets - Discovered Rooms
library;

import 'package:flutter/material.dart';

import '../../cubit/cubits.dart';
import '../../theme/app_theme.dart';
import '../../../core/localization/localization_service.dart';
import '../../../domain/entities/room_info.dart';
import 'room_card.dart';

/// Discovered LAN rooms list
class DiscoveredRooms extends StatelessWidget {
  final GameCubit cubit;
  final void Function(RoomInfo room) onJoinRoom;

  const DiscoveredRooms({
    super.key,
    required this.cubit,
    required this.onJoinRoom,
  });

  @override
  Widget build(BuildContext context) {
    final rooms = cubit.discoveredRooms;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.wifi_find, color: AppColors.secondary),
            const SizedBox(width: 8),
            Text(
              AppStrings.lobbyAvailableRooms,
              style: AppTypography.titleMedium,
            ),
            const Spacer(),
            if (cubit.isDiscovering)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            IconButton(
              onPressed: () => cubit.startRoomDiscovery(),
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (rooms.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 48,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.lobbyNoRoomsFound,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.lobbySearchingWifi,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...rooms.map((room) => RoomCard(
                room: room,
                isConnecting: cubit.state.isConnecting,
                onJoin: () => onJoinRoom(room),
              )),
      ],
    );
  }
}
