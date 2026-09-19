import 'package:flutter/material.dart';

class RoomDetailsPlaceholder extends StatelessWidget {
  final String matchId;
  const RoomDetailsPlaceholder({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Room Details')),
      body: Center(child: Text('Room for $matchId — Coming Soon')),
    );
  }
}
