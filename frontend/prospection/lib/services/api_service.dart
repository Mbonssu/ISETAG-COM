// lib/services/api_service.dart

// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:isetagcom/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/specialite.dart';
import 'JwtService.dart';

class ApiService {
  final AppConfig conf = AppConfig();

  final http.Client _client = http.Client();

  // Get auth token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Headers
  Future<Map<String, String>> _getHeaders() async {
    final authToken = await _getToken();

    print('🔑 Raw token: "$authToken"');

    if (authToken == null || authToken.isEmpty) {
      print('⚠️ No token available');
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
    }

    final cleanToken = authToken.trim().replaceAll(RegExp(r'\s'), '');

    print(
        '🔑 Clean token: "${cleanToken.substring(0, cleanToken.length > 20 ? 20 : cleanToken.length)}..."');
    print('🔑 Clean token length: ${cleanToken.length}');
    print('🔑 Clean token contains spaces: ${cleanToken.contains(' ')}');

    final authHeader = 'Bearer $cleanToken';

    print(
        '📋 Auth header: "Bearer ${cleanToken.substring(0, cleanToken.length > 20 ? 20 : cleanToken.length)}..."');

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authHeader,
    };
  }

  // ✅ Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final url = Uri.parse(AppConfig.login);

      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body);
        final accessToken = responseData['access'] ??
            responseData['token'] ??
            responseData['access_token'];

        if (accessToken != null) {
          final cleanToken = accessToken.toString().trim();

          final user = JwtService.getUserFromToken(cleanToken);
          final agent = JwtService.getAgentFromToken(cleanToken);

          return {
            'success': true,
            'data': responseData,
            'token': cleanToken,
            'refreshToken': responseData['refresh'],
            'user': user,
            'agent': agent,
          };
        }
      }

      return {
        'success': false,
        'message': 'Login failed',
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // ✅ Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      final url = Uri.parse(AppConfig.logout);

      final response = await _client.post(
        url,
        headers: await _getHeaders(),
      );

      print("Logout response status: ${response.statusCode}");
      print("Logout response body: ${response.body}");

      await _clearLocalData();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('Logged out from server');
        return {
          'success': true,
          'message': 'Logged out successfully',
        };
      } else {
        print('Logged out locally');
        return {
          'success': true,
          'message': 'Logged out successfully',
          'warning': 'Server logout failed: ${response.statusCode}',
        };
      }
    } catch (e) {
      print("Logout error: $e");
      await _clearLocalData();
      return {
        'success': true,
        'message': 'Logged out locally',
        'warning': 'Network error during logout: $e',
      };
    }
  }

  // Clear all local data
  Future<void> _clearLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('refresh_token');
      await prefs.remove('token_payload');
      await prefs.remove('token_expiry');
      await prefs.remove('user_email');
      await prefs.remove('user_username');
      await prefs.remove('user_name');
      await prefs.remove('user_role');
      await prefs.remove('user_id');
      await prefs.remove('remember_me');
      await prefs.remove('remembered_username');
      await prefs.remove('remembered_email');
      print('All local data cleared successfully');
    } catch (e) {
      print('Error clearing local data: $e');
    }
  }

  // ✅ Check if logged in
  Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  // ==================== CREATE METHODS ====================

  // Create Prospect
  Future<Map<String, dynamic>> createProspect(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse(AppConfig.prospect);
      print("POST URL: $url");
      final response = await _client.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      print("prospect: $data");
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create prospect: $e');
    }
  }

  // Create Fiche
  Future<Map<String, dynamic>> createFiche(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse(AppConfig.fiche_sortie);
      print("POST URL: $url");
      final response = await _client.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      print("fiche: $data");
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create fiche: $e');
    }
  }

  // Create Interet
  Future<Map<String, dynamic>> createInteret(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse(AppConfig.interest);
      print("POST URL: $url");
      final response = await _client.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      print("interet: $data");
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create interet: $e');
    }
  }

  // Create Specialite
  Future<Map<String, dynamic>> createSpecialite(
      Map<String, dynamic> data) async {
    try {
      final url = Uri.parse(AppConfig.speciality);
      print("POST URL: $url");
      final response = await _client.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      print("specialite: $data");
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create specialite: $e');
    }
  }

  // Create Classe
  Future<Map<String, dynamic>> createClasse(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse(AppConfig.classes);
      print("POST URL: $url");
      final response = await _client.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      print("classe: $data");
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create classe: $e');
    }
  }

  // Create Etablissement
  Future<Map<String, dynamic>> createEtablissement(
      Map<String, dynamic> data) async {
    try {
      final url = Uri.parse(AppConfig.ets);
      print("POST URL: $url");
      final response = await _client.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      print("etablissement: $data");
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create etablissement: $e');
    }
  }

// ==================== RELANCE ====================

  Future<Map<String, dynamic>> createRelance(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse(AppConfig.relance);
      final response = await _client.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create relance: $e');
    }
  }

  Future<Map<String, dynamic>> updateRelance(
      String id, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${AppConfig.relance}$id/');
      final response = await _client.put(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to update relance: $e');
    }
  }

  Future<Map<String, dynamic>> deleteRelance(String id) async {
    try {
      final url = Uri.parse('${AppConfig.relance}$id/');
      final response = await _client.delete(
        url,
        headers: await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to delete relance: $e');
    }
  }

  // Create Source
  Future<Map<String, dynamic>> createSource(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse(AppConfig.src);
      print("POST URL: $url");
      final response = await _client.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      print("source: $data");
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create source: $e');
    }
  }

  // ==================== UPDATE METHODS ====================

  /// Update a prospect (PUT)
  Future<Map<String, dynamic>> updateProspect(
      String id, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${AppConfig.prospect}$id/');
      print("PUT URL: $url");
      final response = await _client.put(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      print("prospect (update): $data");
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to update prospect: $e');
    }
  }

  /// Update a fiche (PUT)
  Future<Map<String, dynamic>> updateFiche(
      String id, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${AppConfig.fiche_sortie}$id/');
      print("PUT URL: $url");
      final response = await _client.put(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      print("fiche (update): $data");
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to update fiche: $e');
    }
  }

  /// Update an interest (PUT)
  Future<Map<String, dynamic>> updateInteret(
      String id, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${AppConfig.interest}$id/');
      print("PUT URL: $url");
      final response = await _client.put(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      print("interet (update): $data");
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to update interest: $e');
    }
  }

  /// Update a specialty (PUT)
  Future<Map<String, dynamic>> updateSpecialite(
      String id, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${AppConfig.speciality}$id/');
      print("PUT URL: $url");
      final response = await _client.put(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      print("specialite (update): $data");
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to update specialty: $e');
    }
  }

  /// Update a class (PUT)
  Future<Map<String, dynamic>> updateClasse(
      String id, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${AppConfig.classes}$id/');
      print("PUT URL: $url");
      final response = await _client.put(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      print("classe (update): $data");
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to update class: $e');
    }
  }

  /// Update an establishment (PUT)
  Future<Map<String, dynamic>> updateEtablissement(
      String id, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${AppConfig.ets}$id/');
      print("PUT URL: $url");
      final response = await _client.put(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      print("etablissement (update): $data");
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to update establishment: $e');
    }
  }

  /// Update a relance (PUT)
  // Future<Map<String, dynamic>> updateRelance(
  //     String id, Map<String, dynamic> data) async {
  //   try {
  //     final url = Uri.parse('${AppConfig.relance}$id/');
  //     print("PUT URL: $url");
  //     final response = await _client.put(
  //       url,
  //       headers: await _getHeaders(),
  //       body: jsonEncode(data),
  //     );
  //     print("relance (update): $data");
  //     return _handleResponse(response);
  //   } catch (e) {
  //     throw Exception('Failed to update relance: $e');
  //   }
  // }

  // /// Delete a relance
  // Future<Map<String, dynamic>> deleteRelance(String id) async {
  //   try {
  //     final url = Uri.parse('${AppConfig.relance}$id/');
  //     final response = await _client.delete(url, headers: await _getHeaders());
  //     return _handleResponse(response);
  //   } catch (e) {
  //     throw Exception('Failed to delete relance: $e');
  //   }
  // }

  /// Fetch all relances
  Future<Map<String, dynamic>> fetchRelances() async {
    try {
      final url = Uri.parse(AppConfig.relance);
      final response = await _client.get(url, headers: await _getHeaders());
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to fetch relances: $e');
    }
  }

  /// Update a source (PUT)
  Future<Map<String, dynamic>> updateSource(
      String id, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${AppConfig.src}$id/');
      print("PUT URL: $url");
      final response = await _client.put(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      print("source (update): $data");
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to update source: $e');
    }
  }

  // ==================== HEALTH & PARTICIPATION ====================

  // Health check
  Future<Map<String, dynamic>> healthCheck() async {
    final url = Uri.parse(AppConfig.participation);
    print("The checkHealth Url: $url");
    try {
      final response = await _client.get(
        url,
        headers: await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'API not reachable: $e',
      };
    }
  }

  // Check participation
  Future<Map<String, dynamic>?> checkParticipation() async {
    try {
      final url = Uri.parse(AppConfig.participation);
      final headers = await _getHeaders();

      print('📡 Making request to: $url');
      print('📡 Headers: $headers');

      final response = await _client.get(
        url,
        headers: headers,
      );

      print("📡 Participation check response status: ${response.statusCode}");
      print("📡 Participation check response body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        print('📡 Parsed response: $data');

        if (data['idParticipation'] != null && data['idParticipation'] != '') {
          return data;
        }

        return {
          'idParticipation': null,
          'message': 'No participation found',
        };
      } else if (response.statusCode == 404) {
        print('ℹ️ No participation found (404)');
        return {
          'idParticipation': null,
          'message': 'No participation found',
          'statusCode': 404,
        };
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        print('❌ Client error: ${response.statusCode}');
        try {
          final errorData = jsonDecode(response.body);
          return {
            'idParticipation': null,
            'error': true,
            'message': errorData['detail'] ?? 'Client error',
            'statusCode': response.statusCode,
          };
        } catch (e) {
          return {
            'idParticipation': null,
            'error': true,
            'message': 'Client error: ${response.statusCode}',
            'statusCode': response.statusCode,
          };
        }
      } else {
        print('❌ Server error: ${response.statusCode}');
        return {
          'idParticipation': null,
          'error': true,
          'isServerError': true,
          'message': 'Server error: ${response.statusCode}',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print('❌ Network error checking participation: $e');
      return {
        'idParticipation': null,
        'error': true,
        'isNetworkError': true,
        'message': 'Network error: $e',
      };
    }
  }

  // ==================== RESPONSE HANDLER ====================

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print("📥 Response: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");
      return {
        'success': true,
        'data': jsonDecode(response.body),
        'statusCode': response.statusCode,
      };
    } else {
      print("📥 Response: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");
      return {
        'success': false,
        'message': 'Server error: ${response.statusCode}',
        'statusCode': response.statusCode,
        'body': response.body,
      };
    }
  }

  // ==================== FETCH SPECIALITIES ====================

  /// Fetches all specialties from the server.
  /// Returns a List<Specialite>.
  Future<List<Specialite>> fetchSpecialities() async {
    try {
      final url = Uri.parse(AppConfig.speciality);
      final response = await _client
          .get(
        url,
        headers: await _getHeaders(),
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timed out after 30 seconds');
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }

      final dynamic jsonData = jsonDecode(response.body);

      List<dynamic> jsonList;
      if (jsonData is List) {
        jsonList = jsonData;
      } else if (jsonData is Map && jsonData.containsKey('data')) {
        jsonList = jsonData['data'] as List<dynamic>;
      } else {
        throw Exception('Unexpected response format');
      }

      return jsonList
          .map((json) => Specialite.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Error fetching specialties: $e');
      rethrow;
    }
  }

  // Dispose
  void dispose() {
    _client.close();
  }
}
