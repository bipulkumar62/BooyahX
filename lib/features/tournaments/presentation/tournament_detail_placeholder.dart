import 'package:flutter/material.dart';

class TournamentDetailPlaceholder extends StatelessWidget {
  final String tournamentId;
  const TournamentDetailPlaceholder({super.key, required this.tournamentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tournament Detail')),
      body: Center(child: Text('Tournament $tournamentId — Coming Soon')),
    );
  }
}
