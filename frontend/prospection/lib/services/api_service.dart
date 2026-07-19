// // // lib/services/api_service.dart

// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:isetagcom/config/app_config.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class ApiService {
// //   final AppConfig conf = AppConfig();

// //   final http.Client _client = http.Client();

// //   // Get auth token
// //   Future<String?> _getToken() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getString('auth_token');
// //   }

// //   // Headers
// //   Future<Map<String, String>> _getHeaders() async {
// //     final token = await _getToken();
// //     return {
// //       'Content-Type': 'application/json',
// //       'Accept': 'application/json',
// //       if (token != null) 'Authorization': 'Bearer $token',
// //     };
// //   }

// //   // Create Prospect
// //   Future<Map<String, dynamic>> createProspect(Map<String, dynamic> data) async {
// //     try {
// //       final headers = await _getHeaders();
// //       final url = Uri.parse(AppConfig.prospect);
// //       print("URL: $url");
// //       final response = await _client.post(
// //         url,
// //         headers: headers,
// //         body: jsonEncode(data),
// //       );
// //       print("prospect: $data");
// //       return _handleResponse(response);
// //     } catch (e) {
// //       throw Exception('Failed to create prospect: $e');
// //     }
// //   }

// //   // ✅ Update Prospect (PUT)
// //   //
// //   // Met à jour un prospect existant sur le serveur distant via une requête
// //   // PUT sur `${AppConfig.prospect}<id>/`. `idProspect` doit être l'identifiant
// //   // reconnu par le backend (celui utilisé côté Django, pas forcément l'id
// //   // local Isar — adapte le champ envoyé si le backend attend une autre
// //   // clé, ex: `remoteId`). Le corps `data` doit contenir la représentation
// //   // complète du prospect attendue par le serveur pour un PUT (remplacement
// //   // total de la ressource) ; si le backend supporte plutôt une mise à jour
// //   // partielle, utilise updateProspectPartial (PATCH, voir plus bas) à la
// //   // place.
// //   Future<Map<String, dynamic>> updateProspect(
// //       String idProspect, Map<String, dynamic> data) async {
// //     try {
// //       final headers = await _getHeaders();
// //       final url = Uri.parse('${AppConfig.prospect}$idProspect/');
// //       print("PUT URL: $url");
// //       final response = await _client.put(
// //         url,
// //         headers: headers,
// //         body: jsonEncode(data),
// //       );
// //       print("prospect (update): $data");
// //       return _handleResponse(response);
// //     } catch (e) {
// //       throw Exception('Failed to update prospect: $e');
// //     }
// //   }

// //   // ⚠️ DÉSACTIVÉ CÔTÉ FILE DE SYNCHRO : l'agent terrain ne crée jamais de
// //   // Fiche (elles sont pré-existantes / gérées ailleurs). SyncQueue
// //   // n'appelle donc plus cette méthode. Elle est conservée ici — avec une
// //   // vraie erreur explicite au lieu d'un `Uri.parse('')` silencieux — pour
// //   // le jour où un vrai endpoint sera exposé côté Django et où on voudra
// //   // la relier (ex: `AppConfig.fiche` à définir en suivant le même modèle
// //   // que `AppConfig.ets`/`AppConfig.src`).
// //   Future<Map<String, dynamic>> createFiche(Map<String, dynamic> data) async {
// //     try {
// //       final headers = await _getHeaders();
// //       final url = Uri.parse(AppConfig.fiche_sortie);
// //       print("URL: $url");
// //       final response = await _client.post(
// //         url,
// //         headers: headers,
// //         body: jsonEncode(data),
// //       );
// //       print("fiche: $data");
// //       return _handleResponse(response);
// //     } catch (e) {
// //       throw Exception('Failed to create fiche: $e');
// //     }
// //   }

// //   // Create Interet
// //   Future<Map<String, dynamic>> createInteret(Map<String, dynamic> data) async {
// //     try {
// //       final headers = await _getHeaders();
// //       final url = Uri.parse(AppConfig.interest);
// //       print("URL: $url");
// //       final response = await _client.post(
// //         url,
// //         headers: headers,
// //         body: jsonEncode(data),
// //       );

// //       print("interet: $data");
// //       return _handleResponse(response);
// //     } catch (e) {
// //       throw Exception('Failed to create interet: $e');
// //     }
// //   }

// //   // Create Specialite
// //   Future<Map<String, dynamic>> createSpecialite(
// //       Map<String, dynamic> data) async {
// //     try {
// //       final headers = await _getHeaders();
// //       final url = Uri.parse(AppConfig.speciality);
// //       print("URL: $url");
// //       final response = await _client.post(
// //         url,
// //         headers: headers,
// //         body: jsonEncode(data),
// //       );
// //       print("specialite: $data");
// //       return _handleResponse(response);
// //     } catch (e) {
// //       throw Exception('Failed to create specialite: $e');
// //     }
// //   }

// //   // Create Classe
// //   Future<Map<String, dynamic>> createClasse(Map<String, dynamic> data) async {
// //     try {
// //       final headers = await _getHeaders();
// //       final url = Uri.parse(AppConfig.classes);
// //       print("URL: $url");
// //       final response = await _client.post(
// //         url,
// //         headers: headers,
// //         body: jsonEncode(data),
// //       );
// //       print("classe: $data");
// //       return _handleResponse(response);
// //     } catch (e) {
// //       throw Exception('Failed to create classe: $e');
// //     }
// //   }

// //   // Handle response
// //   Map<String, dynamic> _handleResponse(http.Response response) {
// //     if (response.statusCode >= 200 && response.statusCode < 300) {
// //       print("📥 Response: ${response.statusCode}");
// //       print("📥 Response Body: ${response.body}");
// //       return {
// //         'success': true,
// //         'data': jsonDecode(response.body),
// //       };
// //     } else {
// //       print("📥 Response: ${response.statusCode}");
// //       print("📥 Response Body: ${response.body}");
// //       return {
// //         'success': false,
// //         'message': 'Server error: ${response.statusCode}',
// //         'body': response.body,
// //       };
// //     }
// //   }

// //   // Create Etablissement
// //   Future<Map<String, dynamic>> createEtablissement(
// //       Map<String, dynamic> data) async {
// //     try {
// //       final headers = await _getHeaders();
// //       final url = Uri.parse(AppConfig.ets);
// //       print("URL: $url");
// //       final response = await _client.post(
// //         url,
// //         headers: headers,
// //         body: jsonEncode(data),
// //       );
// //       print("etablissement: $data");
// //       return _handleResponse(response);
// //     } catch (e) {
// //       throw Exception('Failed to create etablissement: $e');
// //     }
// //   }

// //   // ⚠️ DÉSACTIVÉ CÔTÉ FILE DE SYNCHRO : même raison que createFiche —
// //   // l'agent ne crée jamais de Source. Cette méthode a un vrai endpoint
// //   // (AppConfig.src) donc elle FONCTIONNERAIT si rappelée manuellement,
// //   // mais SyncQueue ne l'appelle plus automatiquement.
// //   Future<Map<String, dynamic>> createSource(Map<String, dynamic> data) async {
// //     try {
// //       final headers = await _getHeaders();
// //       final url = Uri.parse(AppConfig.src);
// //       print("URL: $url");
// //       final response = await _client.post(
// //         url,
// //         headers: headers,
// //         body: jsonEncode(data),
// //       );
// //       print("source: $data");
// //       return _handleResponse(response);
// //     } catch (e) {
// //       throw Exception('Failed to create source: $e');
// //     }
// //   }

// //   // To check whether the API is reachable
// //   //
// //   // ⚠️ Toujours en attente d'un vrai endpoint /health/ côté Django — pour
// //   // l'instant ça interroge la liste complète des prospects, ce qui peut
// //   // être lent (voir l'échange précédent sur le timeout). Dès qu'un
// //   // endpoint léger existe, remplace juste l'URL ci-dessous.
// //   Future<Map<String, dynamic>> healthCheck() async {
// //     final url = Uri.parse(AppConfig.prospect);
// //     print("The checkHealth Url: $url");
// //     try {
// //       final response = await _client.get(
// //         url,
// //         headers: {'Content-Type': 'application/json'},
// //       );

// //       return _handleResponse(response);
// //     } catch (e) {
// //       return {
// //         'success': false,
// //         'message': 'API not reachable: $e',
// //       };
// //     }
// //   }

// //   // Dispose
// //   void dispose() {
// //     _client.close();
// //   }
// // }

// // lib/services/api_service.dart

// // ignore_for_file: avoid_print

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:isetagcom/config/app_config.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'JwtService.dart';

// class ApiService {
//   final AppConfig conf = AppConfig();

//   final http.Client _client = http.Client();
//   // Future<String?> get token async => await _getToken();

//   // Get auth token
//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   // Headers
//   // Future<Map<String, String>> _getHeaders() async {
//   //   final authToken = await _getToken();
//   //   print(authToken);
//   //   return {
//   //     'Content-Type': 'application/json',
//   //     'Accept': 'application/json',
//   //     'Authorization': 'Bearer $authToken',
//   //   };
//   // }

//   Future<Map<String, String>> _getHeaders() async {
//     final authToken = await _getToken();

//     // Debug: Print token to see what we have
//     print('🔑 Raw token: "$authToken"');

//     if (authToken == null || authToken.isEmpty) {
//       print('⚠️ No token available');
//       return {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       };
//     }

//     // ✅ Clean the token - remove ALL whitespace, newlines, carriage returns, tabs
//     final cleanToken = authToken
//         .trim()
//         .replaceAll(RegExp(r'\s'), ''); // Remove ALL whitespace characters

//     print(
//         '🔑 Clean token: "${cleanToken.substring(0, cleanToken.length > 20 ? 20 : cleanToken.length)}..."');
//     print('🔑 Clean token length: ${cleanToken.length}');
//     print('🔑 Clean token contains spaces: ${cleanToken.contains(' ')}');

//     // ✅ Ensure exactly "Bearer " + token with no extra spaces
//     final authHeader = 'Bearer $cleanToken';

//     // Debug: Show the full header (safely)
//     print(
//         '📋 Auth header: "Bearer ${cleanToken.substring(0, cleanToken.length > 20 ? 20 : cleanToken.length)}..."');

//     return {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       'Authorization': authHeader, // Exactly "Bearer token" with ONE space
//     };
//   }

//   // ✅ Login
//   //
//   // Authentifie l'utilisateur auprès de `AppConfig.login` (adapte le nom du
//   // champ si ton backend attend `username` au lieu de `email`, ou expose un
//   // login token-based différent, ex: SimpleJWT `/api/token/`). En cas de
//   // succès, le token retourné est persisté dans SharedPreferences sous la
//   // clé `auth_token` (utilisée par `_getToken`/`_getHeaders` ci-dessus),
//   // ainsi que quelques infos utilisateur si présentes dans la réponse.
//   // Future<Map<String, dynamic>> login(String email, String password) async {
//   //   try {
//   //     final url = Uri.parse(AppConfig.login);
//   //     print("URL: $url");

//   //     final response = await _client.post(
//   //       url,
//   //       headers: {
//   //         'Content-Type': 'application/json',
//   //         'Accept': 'application/json',
//   //       },
//   //       body: jsonEncode({
//   //         'email': email,
//   //         'password': password,
//   //       }),
//   //     );

//   //     print("Response status: ${response.statusCode}");
//   //     print("Response body: ${response.body}");

//   //     Map<String, dynamic> responseData;
//   //     try {
//   //       responseData = jsonDecode(response.body);
//   //     } catch (e) {
//   //       return {
//   //         'success': false,
//   //         'message': 'Invalid response format',
//   //       };
//   //     }

//   //     if (response.statusCode >= 200 && response.statusCode < 300) {
//   //       final accessToken = responseData['access'] ??
//   //           responseData['token'] ??
//   //           responseData['access_token'];

//   //       final refreshToken =
//   //           responseData['refresh'] ?? responseData['refresh_token'];

//   //       if (accessToken != null) {
//   //         final prefs = await SharedPreferences.getInstance();

//   //         // Save tokens
//   //         await prefs.setString('auth_token', accessToken.toString());
//   //         if (refreshToken != null) {
//   //           await prefs.setString('refresh_token', refreshToken.toString());
//   //         }

//   //         // ✅ Decode the token to get user information
//   //         final userInfo = JwtService.getUserInfo(accessToken.toString());

//   //         // Save user information from decoded token
//   //         if (userInfo.isNotEmpty) {
//   //           if (userInfo['email'] != null && userInfo['email'] != '') {
//   //             await prefs.setString('user_email', userInfo['email']!);
//   //           }
//   //           if (userInfo['username'] != null && userInfo['username'] != '') {
//   //             await prefs.setString('user_username', userInfo['username']!);
//   //           }
//   //           if (userInfo['userId'] != null && userInfo['userId'] != '') {
//   //             await prefs.setString('user_id', userInfo['userId']!);
//   //           }
//   //           if (userInfo['role'] != null && userInfo['role'] != '') {
//   //             await prefs.setString('user_role', userInfo['role']!);
//   //           }

//   //           // ✅ Save expiration date as ISO string (convert DateTime to string)
//   //           if (userInfo['expiresAt'] != null) {
//   //             final expiryDate = userInfo['expiresAt'] as DateTime;
//   //             await prefs.setString(
//   //                 'token_expiry', expiryDate.toIso8601String());
//   //           }
//   //         }

//   //         // ✅ Create a copy of userInfo with DateTime converted to string for storage
//   //         final userInfoForStorage = Map<String, dynamic>.from(userInfo);
//   //         if (userInfoForStorage['expiresAt'] != null) {
//   //           userInfoForStorage['expiresAt'] =
//   //               (userInfoForStorage['expiresAt'] as DateTime).toIso8601String();
//   //         }
//   //         if (userInfoForStorage['issuedAt'] != null) {
//   //           userInfoForStorage['issuedAt'] =
//   //               (userInfoForStorage['issuedAt'] as DateTime).toIso8601String();
//   //         }

//   //         await prefs.setString(
//   //             'token_payload', jsonEncode(userInfoForStorage));

//   //         return {
//   //           'success': true,
//   //           'data': responseData,
//   //           'token': accessToken,
//   //           'user': userInfo,
//   //           'message': 'Login successful',
//   //         };
//   //       } else {
//   //         return {
//   //           'success': false,
//   //           'message': 'No token received from server',
//   //           'detail': responseData,
//   //         };
//   //       }
//   //     } else {
//   //       String errorMessage = 'Login failed';
//   //       if (responseData.containsKey('detail')) {
//   //         errorMessage = responseData['detail'].toString();
//   //       } else if (responseData.containsKey('error')) {
//   //         errorMessage = responseData['error'].toString();
//   //       } else if (responseData.containsKey('message')) {
//   //         errorMessage = responseData['message'].toString();
//   //       }

//   //       return {
//   //         'success': false,
//   //         'message': errorMessage,
//   //         'detail': responseData,
//   //         'statusCode': response.statusCode,
//   //       };
//   //     }
//   //   } catch (e) {
//   //     print("Login error: $e");
//   //     return {
//   //       'success': false,
//   //       'message': 'Network error: ${e.toString()}',
//   //     };
//   //   }
//   // }

//   Future<Map<String, dynamic>> login(String email, String password) async {
//     try {
//       final url = Uri.parse(AppConfig.login);

//       final response = await _client.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode({
//           'email': email,
//           'password': password,
//         }),
//       );

//       print("Response status: ${response.statusCode}");
//       print("Response body: ${response.body}");

//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         final responseData = jsonDecode(response.body);
//         final accessToken = responseData['access'] ??
//             responseData['token'] ??
//             responseData['access_token'];

//         if (accessToken != null) {
//           final cleanToken = accessToken.toString().trim();

//           // ✅ Decrypt the token to get user data
//           final user = JwtService.getUserFromToken(cleanToken);
//           final agent = JwtService.getAgentFromToken(cleanToken);

//           return {
//             'success': true,
//             'data': responseData,
//             'token': cleanToken,
//             'refreshToken': responseData['refresh'],
//             'user': user,
//             'agent': agent,
//           };
//         }
//       }

//       return {
//         'success': false,
//         'message': 'Login failed',
//         'statusCode': response.statusCode,
//       };
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'Network error: ${e.toString()}',
//       };
//     }
//   }

//   // Future<Map<String, dynamic>> refreshToken() async {
//   //   try {
//   //     final prefs = await SharedPreferences.getInstance();
//   //     final refreshToken = prefs.getString('refresh_token');

//   //     if (refreshToken == null) {
//   //       return {'success': false, 'message': 'No refresh token available'};
//   //     }

//   //     final url = Uri.parse(AppConfig.refreshToken);
//   //     final response = await _client.post(
//   //       url,
//   //       headers: {
//   //         'Content-Type': 'application/json',
//   //         'Accept': 'application/json',
//   //       },
//   //       body: jsonEncode({
//   //         'refresh': refreshToken,
//   //       }),
//   //     );

//   //     if (response.statusCode >= 200 && response.statusCode < 300) {
//   //       final responseData = jsonDecode(response.body);
//   //       final newAccessToken = responseData['access'];

//   //       if (newAccessToken != null) {
//   //         await prefs.setString('auth_token', newAccessToken.toString());

//   //         // Update user info from new token
//   //         final userInfo = JwtService.getUserInfo(newAccessToken.toString());
//   //         if (userInfo.isNotEmpty) {
//   //           await prefs.setString('token_payload', jsonEncode(userInfo));
//   //           if (userInfo['expiresAt'] != null) {
//   //             await prefs.setString(
//   //                 'token_expiry', userInfo['expiresAt']!.toIso8601String());
//   //           }
//   //         }

//   //         return {'success': true, 'token': newAccessToken};
//   //       }
//   //     }

//   //     return {'success': false, 'message': 'Failed to refresh token'};
//   //   } catch (e) {
//   //     return {'success': false, 'message': 'Error refreshing token: $e'};
//   //   }
//   // }

//   // Check if token is expired and auto-refresh if needed
//   // Future<String?> getValidToken() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   final token = prefs.getString('auth_token');

//   //   if (token == null) return null;

//   //   // Check if token is expired
//   //   if (JwtService.isTokenExpired(token)) {
//   //     // Try to refresh the token
//   //     final refreshResult = await refreshToken();
//   //     if (refreshResult['success'] == true) {
//   //       return refreshResult['token'];
//   //     }
//   //     return null;
//   //   }

//   //   return token;
//   // }

//   // ✅ Logout
//   //
//   // Supprime le token local (et les infos utilisateur associées). N'appelle
//   // pas d'endpoint distant par défaut — ajoute un appel POST vers
//   // `AppConfig.logout` ici si le backend a besoin d'invalider le token
//   // côté serveur (ex: blacklist JWT).
//   Future<Map<String, dynamic>> logout() async {
//     try {
//       final url = Uri.parse(AppConfig.logout);

//       final response = await _client.post(
//         url,
//         headers: await _getHeaders(),
//       );

//       print("Logout response status: ${response.statusCode}");
//       print("Logout response body: ${response.body}");

//       // Clear local data regardless of server response
//       await _clearLocalData();

//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         print('Logged out from server');
//         return {
//           'success': true,
//           'message': 'Logged out successfully',
//         };
//       } else {
//         // Even if server logout fails, we've cleared local data
//         print('Logged out locally');
//         return {
//           'success': true,
//           'message': 'Logged out successfully',
//           'warning': 'Server logout failed: ${response.statusCode}',
//         };
//       }
//     } catch (e) {
//       print("Logout error: $e");
//       // Clear local data even if network fails
//       await _clearLocalData();
//       return {
//         'success': true,
//         'message': 'Logged out locally',
//         'warning': 'Network error during logout: $e',
//       };
//     }
//   }

//   // Clear all local data
//   Future<void> _clearLocalData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();

//       // Clear all auth-related data
//       await prefs.remove('auth_token');
//       await prefs.remove('refresh_token');
//       await prefs.remove('token_payload');
//       await prefs.remove('token_expiry');
//       await prefs.remove('user_email');
//       await prefs.remove('user_username');
//       await prefs.remove('user_name');
//       await prefs.remove('user_role');
//       await prefs.remove('user_id');
//       await prefs.remove('remember_me');
//       await prefs.remove('remembered_username');
//       await prefs.remove('remembered_email');

//       print('All local data cleared successfully');
//     } catch (e) {
//       print('Error clearing local data: $e');
//     }
//   }

//   // ✅ Vérifie si un token est actuellement stocké localement
//   Future<bool> isLoggedIn() async {
//     final token = await _getToken();
//     return token != null && token.isNotEmpty;
//   }

//   // Create Prospect
//   Future<Map<String, dynamic>> createProspect(Map<String, dynamic> data) async {
//     try {
//       final headers = await _getHeaders();
//       final url = Uri.parse(AppConfig.prospect);
//       print("URL: $url");
//       final response = await _client.post(
//         url,
//         headers: headers,
//         body: jsonEncode(data),
//       );
//       print("prospect: $data");
//       return _handleResponse(response);
//     } catch (e) {
//       throw Exception('Failed to create prospect: $e');
//     }
//   }

//   // ✅ Update Prospect (PUT)
//   //
//   // Met à jour un prospect existant sur le serveur distant via une requête
//   // PUT sur `${AppConfig.prospect}<id>/`. `idProspect` doit être l'identifiant
//   // reconnu par le backend (celui utilisé côté Django, pas forcément l'id
//   // local Isar — adapte le champ envoyé si le backend attend une autre
//   // clé, ex: `remoteId`). Le corps `data` doit contenir la représentation
//   // complète du prospect attendue par le serveur pour un PUT (remplacement
//   // total de la ressource) ; si le backend supporte plutôt une mise à jour
//   // partielle, utilise updateProspectPartial (PATCH, voir plus bas) à la
//   // place.
//   Future<Map<String, dynamic>> updateProspect(
//       String idProspect, Map<String, dynamic> data) async {
//     try {
//       final url = Uri.parse('${AppConfig.prospect}$idProspect/');
//       print("PUT URL: $url");
//       final response = await _client.put(
//         url,
//         headers: await _getHeaders(),
//         body: jsonEncode(data),
//       );
//       print("prospect (update): $data");
//       return _handleResponse(response);
//     } catch (e) {
//       throw Exception('Failed to update prospect: $e');
//     }
//   }

//   // ⚠️ DÉSACTIVÉ CÔTÉ FILE DE SYNCHRO : l'agent terrain ne crée jamais de
//   // Fiche (elles sont pré-existantes / gérées ailleurs). SyncQueue
//   // n'appelle donc plus cette méthode. Elle est conservée ici — avec une
//   // vraie erreur explicite au lieu d'un `Uri.parse('')` silencieux — pour
//   // le jour où un vrai endpoint sera exposé côté Django et où on voudra
//   // la relier (ex: `AppConfig.fiche` à définir en suivant le même modèle
//   // que `AppConfig.ets`/`AppConfig.src`).
//   Future<Map<String, dynamic>> createFiche(Map<String, dynamic> data) async {
//     try {
//       final url = Uri.parse(AppConfig.fiche_sortie);
//       print("URL: $url");
//       final response = await _client.post(
//         url,
//         headers: await _getHeaders(),
//         body: jsonEncode(data),
//       );
//       print("fiche: $data");
//       return _handleResponse(response);
//     } catch (e) {
//       throw Exception('Failed to create fiche: $e');
//     }
//   }

//   // Create Interet
//   Future<Map<String, dynamic>> createInteret(Map<String, dynamic> data) async {
//     try {
//       final url = Uri.parse(AppConfig.interest);
//       print("URL: $url");
//       final response = await _client.post(
//         url,
//         headers: await _getHeaders(),
//         body: jsonEncode(data),
//       );

//       print("interet: $data");
//       return _handleResponse(response);
//     } catch (e) {
//       throw Exception('Failed to create interet: $e');
//     }
//   }

//   // Create Specialite
//   Future<Map<String, dynamic>> createSpecialite(
//       Map<String, dynamic> data) async {
//     try {
//       final url = Uri.parse(AppConfig.speciality);
//       print("URL: $url");
//       final response = await _client.post(
//         url,
//         headers: await _getHeaders(),
//         body: jsonEncode(data),
//       );
//       print("specialite: $data");
//       return _handleResponse(response);
//     } catch (e) {
//       throw Exception('Failed to create specialite: $e');
//     }
//   }

//   // Create Classe
//   Future<Map<String, dynamic>> createClasse(Map<String, dynamic> data) async {
//     try {
//       final headers = await _getHeaders();
//       final url = Uri.parse(AppConfig.classes);
//       print("URL: $url");
//       final response = await _client.post(
//         url,
//         headers: headers,
//         body: jsonEncode(data),
//       );
//       print("classe: $data");
//       return _handleResponse(response);
//     } catch (e) {
//       throw Exception('Failed to create classe: $e');
//     }
//   }

//   // Handle response
//   Map<String, dynamic> _handleResponse(http.Response response) {
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       print("📥 Response: ${response.statusCode}");
//       print("📥 Response Body: ${response.body}");
//       return {
//         'success': true,
//         'data': jsonDecode(response.body),
//       };
//     } else {
//       print("📥 Response: ${response.statusCode}");
//       print("📥 Response Body: ${response.body}");
//       return {
//         'success': false,
//         'message': 'Server error: ${response.statusCode}',
//         'body': response.body,
//       };
//     }
//   }

//   // Create Etablissement
//   Future<Map<String, dynamic>> createEtablissement(
//       Map<String, dynamic> data) async {
//     try {
//       final url = Uri.parse(AppConfig.ets);
//       print("URL: $url");
//       final response = await _client.post(
//         url,
//         headers: await _getHeaders(),
//         body: jsonEncode(data),
//       );
//       print("etablissement: $data");
//       return _handleResponse(response);
//     } catch (e) {
//       throw Exception('Failed to create etablissement: $e');
//     }
//   }

//   // ⚠️ DÉSACTIVÉ CÔTÉ FILE DE SYNCHRO : même raison que createFiche —
//   // l'agent ne crée jamais de Source. Cette méthode a un vrai endpoint
//   // (AppConfig.src) donc elle FONCTIONNERAIT si rappelée manuellement,
//   // mais SyncQueue ne l'appelle plus automatiquement.
//   Future<Map<String, dynamic>> createSource(Map<String, dynamic> data) async {
//     try {
//       final url = Uri.parse(AppConfig.src);
//       print("URL: $url");
//       final response = await _client.post(
//         url,
//         headers: await _getHeaders(),
//         body: jsonEncode(data),
//       );
//       print("source: $data");
//       return _handleResponse(response);
//     } catch (e) {
//       throw Exception('Failed to create source: $e');
//     }
//   }

//   // To check whether the API is reachable
//   //
//   // ⚠️ Toujours en attente d'un vrai endpoint /health/ côté Django — pour
//   // l'instant ça interroge la liste complète des prospects, ce qui peut
//   // être lent (voir l'échange précédent sur le timeout). Dès qu'un
//   // endpoint léger existe, remplace juste l'URL ci-dessous.
//   Future<Map<String, dynamic>> healthCheck() async {
//     final url = Uri.parse(AppConfig.participation);
//     print("The checkHealth Url: $url");
//     try {
//       final response = await _client.get(
//         url,
//         headers: await _getHeaders(),
//       );

//       return _handleResponse(response);
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'API not reachable: $e',
//       };
//     }
//   }

//   // Future<Map<String, dynamic>?> checkParticipation(String userId) async {
//   Future<Map<String, dynamic>?> checkParticipation() async {
//     try {
//       final url = Uri.parse(AppConfig.participation);

//       final headers = await _getHeaders();

//       print('📡 Making request to: $url');
//       print('📡 Headers: $headers');

//       final response = await _client.get(
//         url,
//         headers: headers,
//       );

//       print("📡 Participation check response status: ${response.statusCode}");
//       print("📡 Participation check response body: ${response.body}");

//       // ✅ Handle different status codes
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         final data = jsonDecode(response.body);
//         print('📡 Parsed response: $data');

//         // Check if data has idParticipation
//         if (data['idParticipation'] != null && data['idParticipation'] != '') {
//           return data;
//         }

//         // If no participation found but status is 200
//         return {
//           'idParticipation': null,
//           'message': 'No participation found',
//         };
//       } else if (response.statusCode == 404) {
//         // ✅ 404 means "No participation found" - this is a valid response, NOT an error
//         print('ℹ️ No participation found (404)');
//         return {
//           'idParticipation': null,
//           'message': 'No participation found',
//           'statusCode': 404,
//         };
//       } else if (response.statusCode >= 400 && response.statusCode < 500) {
//         // ✅ Client errors (400, 401, 403, etc.) - stop retrying
//         print('❌ Client error: ${response.statusCode}');
//         try {
//           final errorData = jsonDecode(response.body);
//           return {
//             'idParticipation': null,
//             'error': true,
//             'message': errorData['detail'] ?? 'Client error',
//             'statusCode': response.statusCode,
//           };
//         } catch (e) {
//           return {
//             'idParticipation': null,
//             'error': true,
//             'message': 'Client error: ${response.statusCode}',
//             'statusCode': response.statusCode,
//           };
//         }
//       } else {
//         // ✅ Server errors (500+) - should retry
//         print('❌ Server error: ${response.statusCode}');
//         return {
//           'idParticipation': null,
//           'error': true,
//           'isServerError': true, // ✅ Flag to indicate retry is needed
//           'message': 'Server error: ${response.statusCode}',
//           'statusCode': response.statusCode,
//         };
//       }
//     } catch (e) {
//       // ✅ Network error - should retry
//       print('❌ Network error checking participation: $e');
//       return {
//         'idParticipation': null,
//         'error': true,
//         'isNetworkError': true, // ✅ Flag to indicate retry is needed
//         'message': 'Network error: $e',
//       };
//     }
//   }

//   // Dispose
//   void dispose() {
//     _client.close();
//   }
// }




// lib/services/api_service.dart

// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:isetagcom/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    final cleanToken = authToken
        .trim()
        .replaceAll(RegExp(r'\s'), '');

    print('🔑 Clean token: "${cleanToken.substring(0, cleanToken.length > 20 ? 20 : cleanToken.length)}..."');
    print('🔑 Clean token length: ${cleanToken.length}');
    print('🔑 Clean token contains spaces: ${cleanToken.contains(' ')}');

    final authHeader = 'Bearer $cleanToken';

    print('📋 Auth header: "Bearer ${cleanToken.substring(0, cleanToken.length > 20 ? 20 : cleanToken.length)}..."');

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
  Future<Map<String, dynamic>> createSpecialite(Map<String, dynamic> data) async {
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
  Future<Map<String, dynamic>> createEtablissement(Map<String, dynamic> data) async {
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
  Future<Map<String, dynamic>> updateProspect(String id, Map<String, dynamic> data) async {
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
  Future<Map<String, dynamic>> updateFiche(String id, Map<String, dynamic> data) async {
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
  Future<Map<String, dynamic>> updateInteret(String id, Map<String, dynamic> data) async {
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
  Future<Map<String, dynamic>> updateSpecialite(String id, Map<String, dynamic> data) async {
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
  Future<Map<String, dynamic>> updateClasse(String id, Map<String, dynamic> data) async {
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
  Future<Map<String, dynamic>> updateEtablissement(String id, Map<String, dynamic> data) async {
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

  /// Update a source (PUT)
  Future<Map<String, dynamic>> updateSource(String id, Map<String, dynamic> data) async {
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

  // Dispose
  void dispose() {
    _client.close();
  }
}