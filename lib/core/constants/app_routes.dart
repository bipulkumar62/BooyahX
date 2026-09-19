/// BooyahX — Route Name Constants
///
/// Centralized route names and path patterns for go_router.
abstract final class AppRoutes {
  // ──────────────────────────────────────────────
  // Route Names (for context.namedRoute)
  // ──────────────────────────────────────────────
  static const splash = 'splash';
  static const onboarding = 'onboarding';
  static const playerSetup = 'player-setup';
  static const login = 'login';
  static const register = 'register';
  static const home = 'home';
  static const myMatches = 'my-matches';
  static const leaderboard = 'leaderboard';
  static const notifications = 'notifications';
  static const profile = 'profile';
  static const tournamentDetail = 'tournament-detail';
  static const matchDetail = 'match-detail';
  static const wallet = 'wallet';
  static const roomDetails = 'room-details';
  static const showcase = 'showcase';

  // ──────────────────────────────────────────────
  // Path Patterns (for go_router path)
  // ──────────────────────────────────────────────
  static const splashPath = '/splash';
  static const onboardingPath = '/onboarding';
  static const playerSetupPath = '/player-setup';
  static const loginPath = '/login';
  static const registerPath = '/register';
  static const homePath = '/home';
  static const myMatchesPath = '/my-matches';
  static const leaderboardPath = '/leaderboard';
  static const notificationsPath = '/notifications';
  static const profilePath = '/profile';
  static const tournamentDetailPath = '/tournament/:id';
  static const matchDetailPath = '/match/:id';
  static const walletPath = '/wallet';
  static const roomDetailsPath = '/room-details/:matchId';
  static const showcasePath = '/showcase';

  // ──────────────────────────────────────────────
  // Helper: Build path with parameters
  // ──────────────────────────────────────────────
  static String tournamentDetailById(String id) => '/tournament/$id';
  static String matchDetailById(String id) => '/match/$id';
  static String roomDetailsByMatchId(String matchId) => '/room-details/$matchId';
}
