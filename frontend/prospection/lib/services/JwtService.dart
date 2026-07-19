// lib/services/jwt_service.dart

import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/user.dart';
import '../models/agent_commercial.dart';

class JwtService {
  // ✅ Decode the token
  static Map<String, dynamic> decodeToken(String token) {
    try {
      return JwtDecoder.decode(token);
    } catch (e) {
      print('Error decoding token: $e');
      return {};
    }
  }

  // ✅ Get User from decoded token
  static User getUserFromToken(String token) {
    try {
      final payload = decodeToken(token);
      
      return User(
        idUtilisateur: payload['user_id'] ?? payload['idUtilisateur'] ?? '',
        nom: payload['nom'] ?? '',
        prenom: payload['prenom'] ?? '',
        telephone: payload['telephone'] ?? '',
        email: payload['email'] ?? '',
        motDePasse: '',
        role: payload['role'] ?? 'user',
        actif: payload['actif'] ?? true,
        createdAt: payload['dateEmbauche'] != null 
            ? DateTime.tryParse(payload['dateEmbauche']) 
            : DateTime.now(),
      );
    } catch (e) {
      print('Error creating User from token: $e');
      return User(
        idUtilisateur: '',
        nom: '',
        prenom: '',
        telephone: '',
        email: '',
        motDePasse: '',
        role: 'user',
        actif: true,
        createdAt: DateTime.now(),
      );
    }
  }

  // ✅ Get Agent from decoded token
  static AgentCommercial getAgentFromToken(String token) {
    try {
      final payload = decodeToken(token);
      
      return AgentCommercial(
        idAgent: payload['user_id'] ?? payload['idUtilisateur'] ?? '',
        idUtilisateur: payload['user_id'] ?? payload['idUtilisateur'] ?? '',
        matriculeAgent: payload['matricule'] ?? payload['matriculeAgent'] ?? '',
        dateEmbauche: payload['dateEmbauche'] != null 
            ? DateTime.tryParse(payload['dateEmbauche']) ?? DateTime.now()
            : DateTime.now(),
        statut: payload['statut'] ?? payload['status'] ?? 'Actif',
      );
    } catch (e) {
      print('Error creating Agent from token: $e');
      return AgentCommercial(
        idAgent: '',
        idUtilisateur: '',
        matriculeAgent: '',
        dateEmbauche: DateTime.now(),
        statut: 'Actif',
      );
    }
  }
}