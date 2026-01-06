/// Presentation Layer - Lobby Widgets - Room Card
library;

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../../core/localization/localization_service.dart';
import '../../../domain/entities/room_info.dart';

/// Individual room card
class RoomCard extends StatelessWidget {
  final RoomInfo room;
  final bool isConnecting;
  final VoidCallback onJoin;

  const RoomCard({
    super.key,
    required this.room,
    required this.isConnecting,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.devices, color: AppColors.secondary),
        ),
        title: Text(room.hostName),
        subtitle: Text(
          '${room.hostAddress}:${room.port} • ${room.playerCountDisplay}',
        ),
        trailing: room.canJoin
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size.fromWidth(10),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.center,
                ),
                onPressed: isConnecting ? null : onJoin,
                child: Center(
                  child: Transform.rotate(
                      angle: 3.14,
                      child: const Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 24,
                      )),
                ),
              )
            : Chip(
                label: Text(room.isStarted
                    ? AppStrings.lobbyInGame
                    : AppStrings.lobbyFull),
                backgroundColor: AppColors.surfaceLight,
              ),
      ),
    );
  }
}
