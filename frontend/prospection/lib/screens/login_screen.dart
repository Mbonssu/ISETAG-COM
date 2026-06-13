// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:isetagcom/screens/register_screen.dart';
import '../routes/app_router.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _remember = false;
  bool _obscure = true;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Configuration du logo
  final bool useImageLogo =
      true; // Mettre à false pour utiliser le logo par défaut
  final String logoImagePath =
      'assets/images/logo.png'; // Chemin du logo transparent

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculer les espacements dynamiquement en fonction de la hauteur d'écran
    final double topSpacing = screenHeight * 0.02; // 2% de la hauteur
    final double logoSize =
        screenHeight * 0.16; // 16% de la hauteur (ajusté pour mieux voir)
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
                      // Logo et titre
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
                          const Text(
                            'Connectez-vous pour continuer à gérer vos prospections.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Champs de formulaire
                      _emailField(),
                      SizedBox(height: screenHeight * 0.02),
                      _passwordField(),
                      SizedBox(height: screenHeight * 0.015),
                      _rememberRow(),

                      SizedBox(height: screenHeight * 0.035),

                      // Boutons
                      _loginBtn(),
                      SizedBox(height: screenHeight * 0.02),
                      // _orDivider(),
                      // SizedBox(height: screenHeight * 0.02),
                      // _googleBtn(),
                      SizedBox(height: screenHeight * 0.02),
                      _signUpRow(),

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
        // decoration: BoxDecoration(
        //   // Pas de fond coloré pour garder la transparence du logo
        //   borderRadius: BorderRadius.circular(size * 0.27),
        //   // boxShadow: const[
        //   //   BoxShadow(
        //   //     color:  Color(0x66F9A825),
        //   //     blurRadius: 20,
        //   //     offset: Offset(0, 8),
        //   //   ),
        //   // ],
        // ),
        child: ClipRRect(
          // borderRadius: BorderRadius.circular(size * 0.27),
          child: Image.asset(
            // opacity:size * 0.27,
            logoImagePath,
            fit: BoxFit
                .contain, // 'contain' préserve la transparence et les proportions
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
        style: const TextStyle(fontSize: 15, color: Color(0xFF1B5E20)),
        decoration: InputDecoration(
          hintText: 'Email',
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
        style: const TextStyle(fontSize: 15, color: Color(0xFF1B5E20)),
        decoration: InputDecoration(
          hintText: 'Mot de passe',
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
            // onPressed: () {
            //   Navigator.of(context).push(
            //     MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
            //   );
            // },
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
            return 'Mot de passe requis';
          }
          if (value.length < 6) {
            return 'Au moins 6 caractères';
          }
          return null;
        },
      ),
    );
  }

  Widget _rememberRow() {
    return Row(
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: _remember,
            onChanged: (value) {
              setState(() {
                _remember = value ?? false;
              });
            },
            activeColor: const Color(0xFF2E7D32),
            checkColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: BorderSide(color: Colors.grey.shade400, width: 1.5),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Se souvenir de moi',
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Mot de passe oublié ?',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginBtn() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Navigator.of(context).pushReplacement(
            //   MaterialPageRoute(builder: (_) => const HomeScreen()),
            // );

            Navigator.of(context).pushReplacementNamed(AppRoutes.home);
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
        child: const Text(
          'Se connecter',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Widget _orDivider() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: Container(
  //           height: 1,
  //           color: Colors.grey.shade300,
  //         ),
  //       ),
  //       const Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 16),
  //         child: Text(
  //           'OU',
  //           style: TextStyle(fontSize: 12, color: Colors.grey),
  //         ),
  //       ),
  //       Expanded(
  //         child: Container(
  //           height: 1,
  //           color: Colors.grey.shade300,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _googleBtn() {
  //   return SizedBox(
  //     width: double.infinity,
  //     height: 52,
  //     child: OutlinedButton(
  //       onPressed: () {},
  //       style: OutlinedButton.styleFrom(
  //         backgroundColor: Colors.white,
  //         foregroundColor: Colors.black87,
  //         side: BorderSide(color: Colors.grey.shade300),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(14),
  //         ),
  //         elevation: 0,
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           SizedBox(
  //             width: 22,
  //             height: 22,
  //             child: Image.network(
  //               'https://cdn-icons-png.flaticon.com/512/300/300221.png',
  //               errorBuilder: (context, error, stackTrace) {
  //                 return const Icon(Icons.g_mobiledata, size: 22);
  //               },
  //             ),
  //           ),
  //           const SizedBox(width: 12),
  //           const Text(
  //             'Continuer avec Google',
  //             style: TextStyle(
  //               fontSize: 14,
  //               fontWeight: FontWeight.w500,
  //               color: Colors.black87,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _signUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Pas encore de compte ? ',
          style: TextStyle(color: Colors.black54, fontSize: 13),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RegisterScreen()),
            );
          },
          child: const Text(
            'Créer un compte',
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
}
