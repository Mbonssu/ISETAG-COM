// ignore_for_file: avoid_print, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/localStorage/local_storage.dart';
import '../provider/auth_provider.dart';
import '../routes/app_router.dart';
import '../services/api_service.dart';
import '../services/translation_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _remember = false;
  bool _obscure = true;
  bool _isLoading = false;

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final ApiService _apiService = ApiService();

  final bool useImageLogo = true;
  final String logoImagePath = 'assets/images/app_icon.png';

  @override
  void initState() {
    super.initState();
    _loadRememberedEmail();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _apiService.dispose();
    super.dispose();
  }

  // ✅ Pré-remplit l'email si "se souvenir de moi" avait été coché
  Future<void> _loadRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final remembered = prefs.getBool('remember_me') ?? false;
    if (remembered) {
      final savedEmail = prefs.getString('remembered_email');
      if (mounted) {
        setState(() {
          _remember = true;
          if (savedEmail != null) {
            _emailCtrl.text = savedEmail;
          }
        });
      }
    }
  }

  // ─── SYNC DIALOG ────────────────────────────────────────────────

  /// Shows a non‑dismissible loading dialog with a warning message.
  void _showSyncDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'sync_in_progress'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'keep_internet_on'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Hides the sync dialog.
  void _hideSyncDialog() {
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  // ─── SYNC LOGIC WITH RETRY ──────────────────────────────────────

  /// Fetches specialties from the server and replaces local ones.
  /// Retries up to [maxRetries] times with exponential backoff.
  Future<void> _syncSpecialitiesWithRetry({int maxRetries = 3}) async {
    print('🔄 Starting sync...');
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        // Small delay before first attempt to let the session settle
        if (attempt == 0) {
          await Future.delayed(const Duration(milliseconds: 500));
        }

        final specialties = await _apiService.fetchSpecialities();
        await LocalStorage.instance.replaceAllSpecialites(specialties);
        print('✅ Specialties synced: ${specialties.length} items');
        return; // Success – exit the loop
      } catch (e) {
        attempt++;
        print('❌ Sync attempt $attempt failed: $e');

        if (attempt < maxRetries) {
          final delay = Duration(seconds: attempt * 2);
          print('⏳ Retrying in ${delay.inSeconds}s...');
          await Future.delayed(delay);
        } else {
          // All retries exhausted
          print('❌ All sync attempts failed');
          rethrow;
        }
      }
    }
  }

  // ─── LOGIN ────────────────────────────────────────────────────────

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isLoading) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );

      if (!mounted) return;

      if (success) {
        await authProvider.saveRememberMe(_remember, _emailCtrl.text.trim());

        // ── Show sync dialog (non‑blocking) ──
        _showSyncDialog();

        bool syncSuccess = false;
        try {
          await _syncSpecialitiesWithRetry();
          syncSuccess = true;
        } catch (e) {
          print('❌ Final sync failure: $e');
        }

        // ── Close the sync dialog ──
        _hideSyncDialog();

        // ── If sync failed, show error dialog with retry/continue ──
        if (!syncSuccess) {
          final shouldRetry = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text('sync_failed_title'.tr),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, color: Colors.orange, size: 48),
                  const SizedBox(height: 12),
                  Text('sync_failed_message'.tr),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('continue_without_sync'.tr),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                  ),
                  child: Text(
                    'retry'.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );

          if (shouldRetry == true) {
            // Retry sync – show dialog again, retry, then close and proceed
            _showSyncDialog();
            try {
              await _syncSpecialitiesWithRetry();
              syncSuccess = true;
            } catch (e) {
              print('❌ Retry sync also failed: $e');
            }
            _hideSyncDialog();
          }
        }

        // ── Navigate to home regardless ──
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.main,
          (route) => false,
        );
      } else {
        _showError(authProvider.errorMessage ?? 'login_failed'.tr);
      }
    } catch (e) {
      if (!mounted) return;
      _showError('login_error'.tr);
      print("Login exception: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFD32F2F),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ─── BUILD ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final double topSpacing = screenHeight * 0.02;
    final double logoSize = screenHeight * 0.16;
    final double betweenSpacing = screenHeight * 0.018;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Background_ISETAG-COM.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: const Color(0xB3FFFFFF).withOpacity(0.200),
          ),
          SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 28)
                  .copyWith(bottom: 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      screenHeight - MediaQuery.of(context).padding.vertical,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          _logo(size: logoSize),
                          SizedBox(height: topSpacing),
                          const Text(
                            'ISETAG',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2E7D32),
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Prospection & Communication',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: betweenSpacing),
                          Text(
                            'login_subtitle'.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      _emailField(),
                      SizedBox(height: screenHeight * 0.02),
                      _passwordField(),
                      SizedBox(height: screenHeight * 0.015),
                      _loginBtn(),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── UI WIDGETS ──────────────────────────────────────────────────

  Widget _logo({required double size}) {
    if (useImageLogo) {
      return SizedBox(
        width: size,
        height: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: Image.asset(
            logoImagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Erreur de chargement du logo: $error');
              return _buildDefaultLogo(size);
            },
          ),
        ),
      );
    } else {
      return _buildDefaultLogo(size);
    }
  }

  Widget _buildDefaultLogo(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF9A825), Color(0xFFF57F17)],
        ),
        borderRadius: BorderRadius.circular(size * 0.27),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66F9A825),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'I',
          style: TextStyle(
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _emailField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _emailCtrl,
        enabled: !_isLoading,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(fontSize: 15, color: Color(0xFF1B5E20)),
        decoration: InputDecoration(
          hintText: 'email'.tr,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
          prefixIcon: const Icon(Icons.email_outlined,
              color: Color(0xFFF9A825), size: 22),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
          errorStyle: const TextStyle(
            fontSize: 12,
            height: 0.8,
            color: Color(0xFFD32F2F),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'email_required'.tr;
          }
          if (!value.contains('@') || !value.contains('.')) {
            return 'invalid_email'.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _passCtrl,
        obscureText: _obscure,
        enabled: !_isLoading,
        style: const TextStyle(fontSize: 15, color: Color(0xFF1B5E20)),
        onFieldSubmitted: (_) => _login(),
        decoration: InputDecoration(
          hintText: 'password'.tr,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
          prefixIcon: const Icon(Icons.lock_outline,
              color: Color(0xFFF9A825), size: 22),
          suffixIcon: IconButton(
            icon: Icon(
              _obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
          errorStyle: const TextStyle(
            fontSize: 12,
            height: 0.8,
            color: Color(0xFFD32F2F),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'password_required'.tr;
          }
          if (value.length < 6) {
            return 'password_min_length'.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget _loginBtn() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          disabledBackgroundColor: const Color(0xFF2E7D32).withOpacity(0.6),
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: const Color(0x4D2E7D32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'login'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}