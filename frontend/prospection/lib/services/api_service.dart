// lib/services/api_service.dart
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:isetagcom/config/app_config.dart';
// import 'package:isetagcom/routes/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      final url = Uri.parse(AppConfig.prospect);
      print("URL: $url");
      final response = await _client.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create prospect: $e');
    }
  }

  // Create Fiche (Also unuseful cause the agent don't create any fiche)
  Future<Map<String, dynamic>> createFiche(Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse('');
      print("URL: $url");
      final response = await _client.post(
        url,
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
      final url = Uri.parse(AppConfig.interest);
      print("URL: $url");
      final response = await _client.post(
        url,
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
      final url = Uri.parse(AppConfig.speciality);
      print("URL: $url");
      final response = await _client.post(
        url,
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
      final url = Uri.parse(AppConfig.classes);
      print("URL: $url");
      final response = await _client.post(
        url,
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
      
      print("📥 Response: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");
      return {
        'success': true,
        'data': jsonDecode(response.body),
      };
    } else {
      print("📥 Response: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");
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
      final url = Uri.parse(AppConfig.ets);
      print("URL: $url");
      final response = await _client.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create etablissement: $e');
    }
  }

  // Create Source (This method is unuseful cause agent don't create any source)
  Future<Map<String, dynamic>> createSource(Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse(AppConfig.src);
      print("URL: $url");
      final response = await _client.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create source: $e');
    }
  }

  // To check whether the API is recheable
  Future<Map<String, dynamic>> healthCheck() async {
    final url = Uri.parse(AppConfig.prospect);
    print("The checkHealth Url: $url");
    try {
      final response = await _client.get(
        url,
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
