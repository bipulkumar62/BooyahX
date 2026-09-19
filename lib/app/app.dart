import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_theme.dart';
import 'package:booyahx/core/routing/app_router.dart';

class BooyahXApp extends StatelessWidget {
  const BooyahXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BooyahX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
