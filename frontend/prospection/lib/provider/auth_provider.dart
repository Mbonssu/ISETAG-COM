// lib/providers/auth_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/agent_commercial.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  static final AuthProvider _instance = AuthProvider._internal();
  factory AuthProvider() => _instance;
  AuthProvider._internal();

  final ApiService _apiService = ApiService();

  User? _currentUser;
  AgentCommercial? _currentAgent;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get currentUser => _currentUser;
  AgentCommercial? get currentAgent => _currentAgent;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isAgent => _currentUser?.isAgent ?? false;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  String get fullName => _currentUser?.fullName ?? '';
  String get initials => _currentUser?.initials ?? 'A';
  String get userEmail => _currentUser?.email ?? '';
  String get userPhone => _currentUser?.telephone ?? '';
  String get agentMatricule => _currentAgent?.matriculeAgent ?? '';

  SharedPreferences? _prefs;

  static const String _userKey = 'user_data';
  static const String _agentKey = 'agent_data';
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _passwordKey = 'user_password';
  static const String _lastLoginKey = 'last_login';
  static const String _rememberMeKey = 'remember_me';
  static const String _rememberedUsernameKey = 'remembered_username';
  static const String _currentOutingIdKey = 'current_outing_id';
  static const String _currentParticipationIdKey = 'current_participation_id';
  static const String _currentParticipationDataKey = 'current_participation_data'; // ✅ NEW
  static const String _isLoggedInKey = 'is_logged_in';

  // ✅ Initialize - Load from cache
  Future<void> init() async {
    if (_prefs != null) return;
    _prefs = await SharedPreferences.getInstance();

    // Load user from cache
    final userJson = _prefs?.getString(_userKey);
    if (userJson != null && userJson.isNotEmpty) {
      try {
        final data = jsonDecode(userJson);
        _currentUser = User.fromJson(data);
        notifyListeners();
      } catch (e) {
        print('Error parsing user data: $e');
        await _prefs?.remove(_userKey);
      }
    }

    // Load agent from cache
    if (_currentUser != null && _currentUser!.isAgent) {
      final agentJson = _prefs?.getString(_agentKey);
      if (agentJson != null && agentJson.isNotEmpty) {
        try {
          final data = jsonDecode(agentJson);
          _currentAgent = AgentCommercial.fromJson(data);
          notifyListeners();
        } catch (e) {
          print('Error parsing agent data: $e');
          await _prefs?.remove(_agentKey);
        }
      }
    }
  }

  // ✅ Save user data to cache
  Future<void> saveUserData(User user,
      {AgentCommercial? agent,
      String? password,
      String? token,
      String? refreshToken}) async {
    _prefs ??= await SharedPreferences.getInstance();

    try {
      _currentUser = user;

      // Save user to cache
      await _prefs!.setString(_userKey, jsonEncode(user.toJsonApi()));

      // Save agent if provided
      if (agent != null) {
        _currentAgent = agent;
        await _prefs!.setString(_agentKey, jsonEncode(agent.toJsonApi()));
      }

      // Save password if provided
      if (password != null && password.isNotEmpty) {
        await _prefs!.setString(_passwordKey, password);
      }

      // Save tokens
      if (token != null && token.isNotEmpty) {
        await _prefs!.setString(_authTokenKey, token);
      }
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _prefs!.setString(_refreshTokenKey, refreshToken);
      }

      // Save last login
      await _prefs!.setString(_lastLoginKey, DateTime.now().toIso8601String());

      // ✅ Set is_logged_in flag to true
      await _prefs!.setBool(_isLoggedInKey, true);

      notifyListeners();
      print('✅ User data saved: ${user.fullName}');
    } catch (e) {
      print('❌ Error saving user data: $e');
      _errorMessage = e.toString();
    }
  }

  // ✅ Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.login(email, password);

      if (result['success'] == true) {
        final user = result['user'];
        final agent = result['agent'];
        final token = result['token'];
        final refreshToken = result['refreshToken'];

        if (user != null) {
          await saveUserData(
            user,
            agent: agent,
            password: password,
            token: token?.toString(),
            refreshToken: refreshToken?.toString(),
          );
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message']?.toString() ?? 'login_failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'login_error';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ✅ Logout
  Future<void> logout() async {
    await _apiService.logout();
    await removeUserData();
  }

  // ✅ Remove user data
  Future<void> removeUserData() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.remove(_userKey);
    await _prefs!.remove(_agentKey);
    await _prefs!.remove(_authTokenKey);
    await _prefs!.remove(_refreshTokenKey);
    await _prefs!.remove(_passwordKey);
    await _prefs!.remove(_lastLoginKey);
    await _prefs!.remove(_isLoggedInKey);
    await _prefs!.remove(_currentParticipationDataKey); // ✅ Also remove participation data

    _currentUser = null;
    _currentAgent = null;
    _errorMessage = null;

    notifyListeners();
    print('✅ User data removed');
  }

  // ✅ Save remember me
  Future<void> saveRememberMe(bool remember, String username) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(_rememberMeKey, remember);
    if (remember && username.isNotEmpty) {
      await _prefs!.setString(_rememberedUsernameKey, username);
    } else {
      await _prefs!.remove(_rememberedUsernameKey);
    }
  }

  // ✅ Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    _prefs ??= await SharedPreferences.getInstance();
    final isLoggedIn = _prefs!.getBool(_isLoggedInKey) ?? false;
    
    // ✅ Also verify that user data exists
    if (isLoggedIn) {
      final userJson = _prefs!.getString(_userKey);
      if (userJson == null || userJson.isEmpty) {
        await _prefs!.remove(_isLoggedInKey);
        return false;
      }
      final token = _prefs!.getString(_authTokenKey);
      if (token == null || token.isEmpty) {
        await _prefs!.remove(_isLoggedInKey);
        return false;
      }
      return true;
    }
    return false;
  }

  // ✅ Get auth token
  Future<String?> getAuthToken() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getString(_authTokenKey);
  }

  // ==================== PARTICIPATION METHODS ====================

  /// Save participation ID
  Future<void> saveParticipationId(String participationId) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(_currentParticipationIdKey, participationId);
    print('✅ Participation ID saved: $participationId');
  }

  /// Get cached participation ID
  Future<String?> getCachedParticipationId() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getString(_currentParticipationIdKey);
  }

  /// Clear participation ID
  Future<void> clearParticipationId() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.remove(_currentParticipationIdKey);
    await _prefs!.remove(_currentParticipationDataKey);
    print('✅ Participation ID cleared');
  }

  /// ✅ Save full participation data
  Future<void> saveParticipationData(Map<String, dynamic> data) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(_currentParticipationDataKey, jsonEncode(data));
    print('✅ Participation data saved');
  }

  /// ✅ Get cached participation data
  Future<Map<String, dynamic>?> getCachedParticipationData() async {
    _prefs ??= await SharedPreferences.getInstance();
    final data = _prefs!.getString(_currentParticipationDataKey);
    if (data != null && data.isNotEmpty) {
      try {
        return jsonDecode(data) as Map<String, dynamic>;
      } catch (e) {
        print('Error parsing participation data: $e');
        return null;
      }
    }
    return null;
  }

  // ==================== OUTING METHODS ====================

  /// Save outing ID
  Future<void> saveOutingId(String outingId) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(_currentOutingIdKey, outingId);
    print('✅ Outing ID saved: $outingId');
  }

  /// Get cached outing ID
  Future<String?> getCachedOutingId() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getString(_currentOutingIdKey);
  }

  /// Clear outing ID
  Future<void> clearOutingId() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.remove(_currentOutingIdKey);
    print('✅ Outing ID cleared');
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}