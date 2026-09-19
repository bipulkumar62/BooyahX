import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:booyahx/core/constants/app_routes.dart';

import 'package:booyahx/features/splash/presentation/splash_screen.dart';
import 'package:booyahx/features/onboarding/presentation/player_setup_screen.dart';
import 'package:booyahx/features/home/presentation/home_screen.dart';
import 'package:booyahx/features/matches/presentation/my_matches_screen.dart';
import 'package:booyahx/features/leaderboard/presentation/leaderboard_screen.dart';
import 'package:booyahx/features/notifications/presentation/notifications_screen.dart';
import 'package:booyahx/features/profile/presentation/profile_screen.dart';
import 'package:booyahx/features/tournaments/presentation/tournament_details_screen.dart';
import 'package:booyahx/features/tournaments/presentation/create_tournament_screen.dart';
import 'package:booyahx/features/matches/presentation/match_details_screen.dart';
import 'package:booyahx/features/wallet/presentation/wallet_screen.dart';
import 'package:booyahx/features/matches/presentation/room_details_screen.dart';
import 'package:booyahx/shared/widgets/bottom_nav_scaffold.dart';
import 'package:booyahx/shared/widgets/showcase/component_showcase.dart';

/// BooyahX — Application Router (go_router)
///
/// Defines the complete route tree.
/// Splash is the initial route. It checks player profile state
/// and redirects to onboarding or home accordingly.
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splashPath,
  debugLogDiagnostics: true,
  routes: [
    // ── Splash (initial) ──
    GoRoute(
      path: AppRoutes.splashPath,
      name: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // ── Onboarding ──
    GoRoute(
      path: AppRoutes.onboardingPath,
      name: AppRoutes.onboarding,
      builder: (context, state) => const PlayerSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.playerSetupPath,
      name: AppRoutes.playerSetup,
      builder: (context, state) => const PlayerSetupScreen(),
    ),

    // ── Main Shell (with bottom navigation) ──
    ShellRoute(
      builder: (context, state, child) => BottomNavScaffold(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.homePath,
          name: AppRoutes.home,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.myMatchesPath,
          name: AppRoutes.myMatches,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MyMatchesScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.leaderboardPath,
          name: AppRoutes.leaderboard,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LeaderboardScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.notificationsPath,
          name: AppRoutes.notifications,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: NotificationsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.profilePath,
          name: AppRoutes.profile,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),

    // ── Push Routes (no bottom nav) ──
    GoRoute(
      path: AppRoutes.tournamentDetailPath,
      name: AppRoutes.tournamentDetail,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return TournamentDetailsScreen(tournamentId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.matchDetailPath,
      name: AppRoutes.matchDetail,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return MatchDetailsScreen(matchId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.walletPath,
      name: AppRoutes.wallet,
      builder: (context, state) => const WalletScreen(),
    ),
    GoRoute(
      path: AppRoutes.createTournamentPath,
      name: AppRoutes.createTournament,
      builder: (context, state) => const CreateTournamentScreen(),
    ),
    GoRoute(
      path: AppRoutes.roomDetailsPath,
      name: AppRoutes.roomDetails,
      builder: (context, state) {
        final matchId = state.pathParameters['matchId'] ?? '';
        return RoomDetailsScreen(matchId: matchId);
      },
    ),
    GoRoute(
      path: AppRoutes.showcasePath,
      name: AppRoutes.showcase,
      builder: (context, state) => const ComponentShowcase(),
    ),
  ],
);
