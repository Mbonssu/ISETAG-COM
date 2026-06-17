// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import '../models/agent_commercial.dart';
import '../models/user.dart';
import '../models/localStorage/local_storage.dart';

class UserProvider extends ChangeNotifier {

  static final UserProvider _instance = UserProvider._internal();
  factory UserProvider() => _instance;
  UserProvider._internal();

  User? _currentUser;
  AgentCommercial? _currentAgent;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  AgentCommercial? get currentAgent => _currentAgent;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;
  String get fullName => _currentUser?.fullName ?? '';
  String get initials => _currentUser?.initials ?? '';

  // Check if user is admin
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isAgent => _currentUser?.isAgent ?? false;
  bool get isUser => _currentUser?.isUser ?? false;

  // Load user from localStorage
  Future<bool> loadUser(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final localStorage = LocalStorage.instance;
      await localStorage.init();
      
      // Get user from Isar
      final user = await localStorage.getUserById(userId);
      
      if (user != null) {
        _currentUser = user;
        
        // If user is an agent, load agent details
        if (user.isAgent) {
          _currentAgent = await localStorage.getAgentByUserId(userId);
        } else {
          _currentAgent = null;
        }
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'User not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login user
  Future<bool> login(String emailOrPhone, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final localStorage = LocalStorage.instance;
      await localStorage.init();
      
      // Find user by email or phone
      final user = await localStorage.getUserByEmailOrPhone(emailOrPhone);
      
      if (user == null) {
        _error = 'User not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      // Check password (in production, use hashed password)
      if (user.motDePasse != password) {
        _error = 'Invalid password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      // Check if user is active
      if (!user.actif) {
        _error = 'Account is inactive';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      _currentUser = user;
      
      // If user is an agent, load agent details
      if (user.isAgent) {
        _currentAgent = await localStorage.getAgentByUserId(user.idUtilisateur);
      } else {
        _currentAgent = null;
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // // Register new user
  // Future<bool> register(User user, {AgentCommercial? agentData}) async {
  //   _isLoading = true;
  //   _error = null;
  //   notifyListeners();

  //   try {
  //     final localStorage = LocalStorage.instance;
  //     await localStorage.init();
      
  //     // Check if user already exists
  //     final existing = await localStorage.getUserByEmailOrPhone(user.telephone);
  //     if (existing != null) {
  //       _error = 'User already exists';
  //       _isLoading = false;
  //       notifyListeners();
  //       return false;
  //     }
      
  //     // Save user
  //     user.createdAt = DateTime.now().toIso8601String();
  //     await localStorage.saveUser(user);
      
  //     // If user is an agent, save agent details
  //     if (user.isAgent && agentData != null) {
  //       agentData.idUtilisateur = user.idUtilisateur;
  //       await localStorage.saveAgent(agentData);
  //       _currentAgent = agentData;
  //     }
      
  //     _currentUser = user;
  //     _isLoading = false;
  //     notifyListeners();
  //     return true;
  //   } catch (e) {
  //     _error = e.toString();
  //     _isLoading = false;
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Update user profile
  Future<bool> updateUser(User updatedUser) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final localStorage = LocalStorage.instance;
      await localStorage.init();
      
      await localStorage.updateUser(updatedUser);
      
      _currentUser = updatedUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update agent details
  // Future<bool> updateAgent(AgentCommercial updatedAgent) async {
  //   if (_currentAgent == null) {
  //     _error = 'No agent data found';
  //     notifyListeners();
  //     return false;
  //   }

  //   _isLoading = true;
  //   _error = null;
  //   notifyListeners();

  //   try {
  //     final localStorage = LocalStorage.instance;
  //     await localStorage.init();
      
  //     await localStorage.updateAgent(updatedAgent);
      
  //     _currentAgent = updatedAgent;
  //     _isLoading = false;
  //     notifyListeners();
  //     return true;
  //   } catch (e) {
  //     _error = e.toString();
  //     _isLoading = false;
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Logout
  void logout() {
    _currentUser = null;
    _currentAgent = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}