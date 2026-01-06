/// Presentation Layer - Lobby Widgets - Join Tab
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubits.dart';

import '../../../core/localization/localization_service.dart';
import '../../../domain/entities/room_info.dart';
import 'discovered_rooms.dart';
import 'manual_entry.dart';
import 'online_join.dart';

/// Join room tab
class JoinTab extends StatelessWidget {
  final GameCubit cubit;
  final bool isLan;
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController portController;
  final TextEditingController roomCodeController;
  final VoidCallback onJoinManual;
  final VoidCallback onJoinOnline;
  final void Function(RoomInfo room) onJoinDiscoveredRoom;

  const JoinTab({
    super.key,
    required this.cubit,
    required this.isLan,
    required this.nameController,
    required this.addressController,
    required this.portController,
    required this.roomCodeController,
    required this.onJoinManual,
    required this.onJoinOnline,
    required this.onJoinDiscoveredRoom,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),

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

          const SizedBox(height: 24),

          if (isLan) ...[
            DiscoveredRooms(
              cubit: cubit,
              onJoinRoom: onJoinDiscoveredRoom,
            ),
            const SizedBox(height: 24),
            ManualEntry(
              cubit: cubit,
              addressController: addressController,
              portController: portController,
              onJoin: onJoinManual,
            ),
          ] else ...[
            OnlineJoin(
              cubit: cubit,
              roomCodeController: roomCodeController,
              onJoin: onJoinOnline,
            ),
          ],
        ],
      ),
    );
  }
}
