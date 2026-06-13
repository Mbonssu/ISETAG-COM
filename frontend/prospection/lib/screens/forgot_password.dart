// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _emailSent = false;

  // Configuration du logo
  final bool useImageLogo = true;
  final String logoImagePath = 'assets/images/logo.png';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
              padding: const EdgeInsets.symmetric(horizontal: 28).copyWith(bottom: 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight - MediaQuery.of(context).padding.vertical,
                ),
                child: _emailSent ? _buildSuccessView() : _buildFormView(screenHeight),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormView(double screenHeight) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo et titre
          Column(
            children: [
              _logo(size: screenHeight * 0.14),
              SizedBox(height: screenHeight * 0.02),
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
              const SizedBox(height: 30),
              const Icon(
                Icons.lock_reset_rounded,
                size: 70,
                color: Color(0xFFF9A825),
              ),
              const SizedBox(height: 20),
              const Text(
                'Mot de passe oublié ?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Entrez votre adresse email et nous vous enverrons un lien pour réinitialiser votre mot de passe.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.05),

          // Champ email
          _emailField(),

          SizedBox(height: screenHeight * 0.035),

          // Bouton envoyer
          _sendBtn(),

          SizedBox(height: screenHeight * 0.02),

          // Lien retour connexion
          _backToLoginRow(),

          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Logo et succès
        Column(
          children: [
            _logo(size: 100),
            const SizedBox(height: 20),
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
            const SizedBox(height: 40),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 60,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Email envoyé !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Un lien de réinitialisation a été envoyé à\n${_emailCtrl.text}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Veuillez vérifier votre boîte de réception et vos spams.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),

        // Bouton retour connexion
        _backToLoginBtn(),

        const SizedBox(height: 20),

        // Réessayer avec autre email
        _tryAgainRow(),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _logo({required double size}) {
    if (useImageLogo) {
      return SizedBox(
        width: size,
        height: size,
        child: ClipRRect(
          child: Image.asset(
            logoImagePath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
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
        style: const TextStyle(fontSize: 15, color: Color(0xFF1B5E20)),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFF9A825), size: 22),
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
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
          errorStyle: const TextStyle(
            fontSize: 12,
            height: 0.8,
            color: Color(0xFFD32F2F),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email requis';
          }
          if (!value.contains('@') || !value.contains('.')) {
            return 'Email invalide';
          }
          return null;
        },
      ),
    );
  }

  Widget _sendBtn() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _sendResetEmail,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
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
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Envoyer le lien',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _backToLoginRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Vous vous rappelez ? ',
          style: TextStyle(color: Colors.black54, fontSize: 13),
        ),
        GestureDetector(
          // onTap: () {
          //   Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(builder: (_) => const LoginScreen()),
          //   );
          // },
          onTap: () => Navigator.pop(context),
          
          child: const Text(
            'Retour à la connexion',
            style: TextStyle(
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

  Widget _backToLoginBtn() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF2E7D32),
          side: const BorderSide(color: Color(0xFF2E7D32)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Retour à la connexion',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _tryAgainRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Vous n\'avez pas reçu d\'email ? ',
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _emailSent = false;
              _emailCtrl.clear();
            });
          },
          child: const Text(
            'Réessayer',
            style: TextStyle(
              color: Color(0xFFF9A825),
              fontWeight: FontWeight.w700,
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _sendResetEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simuler l'envoi d'email (à remplacer par votre logique backend)
      await Future.delayed(const Duration(seconds: 2));
      
      // Ici vous appelleriez votre API pour envoyer l'email
      // Exemple: await AuthService.forgotPassword(_emailCtrl.text);
      
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    }
  }
}