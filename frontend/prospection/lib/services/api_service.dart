// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:isetagcom/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final AppConfig url = AppConfig();

  final http.Client _client = http.Client();

  // Get auth token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Headers
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Create Prospect
  Future<Map<String, dynamic>> createProspect(Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.post(
        Uri.parse('$url/api/prospects'),
        headers: headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create prospect: $e');
    }
  }

  // Create Fiche
  Future<Map<String, dynamic>> createFiche(Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.post(
        Uri.parse('$url/api/fiches'),
        headers: headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create fiche: $e');
    }
  }

  // Create Interet
  Future<Map<String, dynamic>> createInteret(Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.post(
        Uri.parse('$url/api/interets'),
        headers: headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create interet: $e');
    }
  }

  // Create Specialite
  Future<Map<String, dynamic>> createSpecialite(
      Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.post(
        Uri.parse('$url/api/specialites'),
        headers: headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create specialite: $e');
    }
  }

  // Create Classe
  Future<Map<String, dynamic>> createClasse(Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.post(
        Uri.parse('$url/api/classes'),
        headers: headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create classe: $e');
    }
  }

  // Handle response
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {
        'success': true,
        'data': jsonDecode(response.body),
      };
    } else {
      return {
        'success': false,
        'message': 'Server error: ${response.statusCode}',
        'body': response.body,
      };
    }
  }

  // Create Etablissement
  Future<Map<String, dynamic>> createEtablissement(
      Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.post(
        Uri.parse('$url/api/etablissements'),
        headers: headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create etablissement: $e');
    }
  }

  // Create Source
  Future<Map<String, dynamic>> createSource(Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.post(
        Uri.parse('$url/api/sources'),
        headers: headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create source: $e');
    }
  }

  // Add to ApiService class
  Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await _client.get(
        Uri.parse('$url/api/health'),
        headers: {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'API not reachable: $e',
      };
    }
  }

  // Dispose
  void dispose() {
    _client.close();
  }
}
