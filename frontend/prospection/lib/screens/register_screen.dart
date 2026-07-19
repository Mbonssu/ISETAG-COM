// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../services/translation_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _referralCodeCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final bool useImageLogo = true;
  final String logoImagePath = 'assets/images/app_icon.png';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double topSpacing = screenHeight * 0.02;
    final double logoSize = screenHeight * 0.14;
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
                            'register_subtitle'.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      _referralCodeField(),
                      SizedBox(height: screenHeight * 0.02),
                      _passwordField(),
                      SizedBox(height: screenHeight * 0.02),
                      _confirmPasswordField(),
                      SizedBox(height: screenHeight * 0.03),
                      _registerBtn(),
                      SizedBox(height: screenHeight * 0.02),
                      _loginRow(),
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

  Widget _referralCodeField() {
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
        controller: _referralCodeCtrl,
        style: const TextStyle(fontSize: 15, color: Color(0xFF1B5E20)),
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        decoration: InputDecoration(
          hintText: 'referral_code_hint'.tr,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
          prefixIcon: const Icon(Icons.lock_person_outlined,
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
        ),
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
        controller: _passwordCtrl,
        obscureText: _obscurePassword,
        style: const TextStyle(fontSize: 15, color: Color(0xFF1B5E20)),
        decoration: InputDecoration(
          hintText: 'password'.tr,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
          prefixIcon: const Icon(Icons.lock_outline,
              color: Color(0xFFF9A825), size: 22),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
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
              fontSize: 12, height: 0.8, color: Color(0xFFD32F2F)),
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

  Widget _confirmPasswordField() {
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
        controller: _confirmPasswordCtrl,
        obscureText: _obscureConfirmPassword,
        style: const TextStyle(fontSize: 15, color: Color(0xFF1B5E20)),
        decoration: InputDecoration(
          hintText: 'confirm_password'.tr,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
          prefixIcon: const Icon(Icons.lock_outline,
              color: Color(0xFFF9A825), size: 22),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword),
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
              fontSize: 12, height: 0.8, color: Color(0xFFD32F2F)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'confirm_password_required'.tr;
          }
          if (value != _passwordCtrl.text) {
            return 'password_mismatch'.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget _registerBtn() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('register_success'.tr),
                backgroundColor: const Color(0xFF2E7D32),
                duration: const Duration(seconds: 2),
              ),
            );

            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: const Color(0x4D2E7D32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          'register'.tr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _loginRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'already_have_account'.tr,
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            'login'.tr,
            style: const TextStyle(
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.w700,
              fontSize: 13,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _referralCodeCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }
}
