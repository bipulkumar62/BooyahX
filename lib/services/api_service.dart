/// BooyahX — API Service
///
/// Centralized HTTP client for all backend communication.
/// Uses the deployed Render backend URL.
/// Never exposes secrets or credentials.
library;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Custom exception for API errors.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Centralized API service for BooyahX backend.
class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  /// Base URL for the deployed backend.
  static const String baseUrl = 'https://booyahx-0tsy.onrender.com';

  /// Default timeout for API requests.
  static const Duration timeout = Duration(seconds: 15);

  /// Common headers.
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ──────────────────────────────────────────────
  // Generic HTTP methods
  // ──────────────────────────────────────────────

  /// Send a GET request and return decoded JSON.
  Future<Map<String, dynamic>> get(String path) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl$path'), headers: headers)
          .timeout(timeout);

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please check your connection.');
    } on http.ClientException {
      throw ApiException('Connection failed. Please check your internet.');
    }
  }

  /// Send a POST request and return decoded JSON.
  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$path'),
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please check your connection.');
    } on http.ClientException {
      throw ApiException('Connection failed. Please check your internet.');
    }
  }

  /// Send a PUT request and return decoded JSON.
  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? body}) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl$path'),
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please check your connection.');
    } on http.ClientException {
      throw ApiException('Connection failed. Please check your internet.');
    }
  }

  /// Handle HTTP response — parse JSON, check status.
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body;
    }

    // Try to parse error message from response
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final message = body['message'] ?? 'Unknown error';
      throw ApiException(message, statusCode: response.statusCode);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Server error (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }
  }

  // ──────────────────────────────────────────────
  // Player endpoints
  // ──────────────────────────────────────────────

  /// Fetch all players.
  Future<List<Map<String, dynamic>>> getPlayers() async {
    final response = await get('/api/players');
    final data = response['data'];
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  /// Fetch a single player by ID.
  Future<Map<String, dynamic>> getPlayer(String id) async {
    final response = await get('/api/players/$id');
    return response['data'] as Map<String, dynamic>;
  }

  /// Create a new player (onboarding).
  Future<Map<String, dynamic>> createPlayer({
    required String inGameName,
    required String freeFireUid,
  }) async {
    final response = await post('/api/players', body: {
      'inGameName': inGameName,
      'freeFireUid': freeFireUid,
    });
    return response['data'] as Map<String, dynamic>;
  }

  /// Update a player profile.
  Future<Map<String, dynamic>> updatePlayer(
    String id, {
    String? inGameName,
    String? freeFireUid,
  }) async {
    final body = <String, dynamic>{};
    if (inGameName != null) body['inGameName'] = inGameName;
    if (freeFireUid != null) body['freeFireUid'] = freeFireUid;

    final response = await put('/api/players/$id', body: body);
    return response['data'] as Map<String, dynamic>;
  }

  // ──────────────────────────────────────────────
  // Tournament endpoints
  // ──────────────────────────────────────────────

  /// Fetch all tournaments. Optionally filter by category.
  Future<List<Map<String, dynamic>>> getTournaments({String? category}) async {
    final path = category != null && category != 'all'
        ? '/api/tournaments?category=$category'
        : '/api/tournaments';
    final response = await get(path);
    final data = response['data'];
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  /// Fetch a single tournament by ID.
  Future<Map<String, dynamic>> getTournament(String id) async {
    final response = await get('/api/tournaments/$id');
    return response['data'] as Map<String, dynamic>;
  }

  /// Create a new tournament.
  Future<Map<String, dynamic>> createTournament(
      Map<String, dynamic> data) async {
    final response = await post('/api/tournaments', body: data);
    return response['data'] as Map<String, dynamic>;
  }

  /// Join a tournament — creates a match for the player.
  Future<Map<String, dynamic>> joinTournament(
      String tournamentId, String playerId) async {
    final response = await post('/api/tournaments/$tournamentId/join', body: {
      'playerId': playerId,
    });
    return response['data'] as Map<String, dynamic>;
  }

  // ──────────────────────────────────────────────
  // Match endpoints
  // ──────────────────────────────────────────────

  /// Fetch matches. Optionally filter by playerId.
  Future<List<Map<String, dynamic>>> getMatches({String? playerId}) async {
    final path =
        playerId != null ? '/api/matches?playerId=$playerId' : '/api/matches';
    final response = await get(path);
    final data = response['data'];
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  /// Fetch a single match by ID.
  Future<Map<String, dynamic>> getMatch(String id) async {
    final response = await get('/api/matches/$id');
    return response['data'] as Map<String, dynamic>;
  }

  /// Create a new match entry.
  Future<Map<String, dynamic>> createMatch(Map<String, dynamic> data) async {
    final response = await post('/api/matches', body: data);
    return response['data'] as Map<String, dynamic>;
  }

  // ──────────────────────────────────────────────
  // Health check
  // ──────────────────────────────────────────────

  /// Check API health status.
  Future<Map<String, dynamic>> getHealth() async {
    final response = await get('/api/health');
    return response['data'] as Map<String, dynamic>;
  }
}
