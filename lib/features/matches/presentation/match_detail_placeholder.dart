import 'package:flutter/material.dart';

class MatchDetailPlaceholder extends StatelessWidget {
  final String matchId;
  const MatchDetailPlaceholder({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Match Detail')),
      body: Center(child: Text('Match $matchId — Coming Soon')),
    );
  }
}
