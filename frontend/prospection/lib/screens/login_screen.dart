// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:isetagcom/screens/register_screen.dart';
// import '../routes/app_router.dart';
// import '../services/translation_service.dart';
// import 'forgot_password.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool _remember = false;
//   bool _obscure = true;
//   final _emailCtrl = TextEditingController();
//   final _passCtrl = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   final bool useImageLogo = true;
//   final String logoImagePath = 'assets/images/logo.png';

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     final double topSpacing = screenHeight * 0.02;
//     final double logoSize = screenHeight * 0.16;
//     final double betweenSpacing = screenHeight * 0.018;

//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/Background_ISETAG-COM.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Container(
//             color: const Color(0xB3FFFFFF).withOpacity(0.200),
//           ),
//           SafeArea(
//             child: SingleChildScrollView(
//               keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//               padding: const EdgeInsets.symmetric(horizontal: 28).copyWith(bottom: 28),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minHeight: screenHeight - MediaQuery.of(context).padding.vertical,
//                 ),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Column(
//                         children: [
//                           _logo(size: logoSize),
//                           SizedBox(height: topSpacing),
//                           const Text(
//                             'ISETAG',
//                             style: TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.w800,
//                               color: Color(0xFF2E7D32),
//                               letterSpacing: 3,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           const Text(
//                             'Prospection & Communication',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Color(0xFF2E7D32),
//                               fontWeight: FontWeight.w500,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                           SizedBox(height: betweenSpacing),
//                           Text(
//                             'login_subtitle'.tr,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.black54,
//                               height: 1.3,
//                             ),
//                           ),
//                         ],
//                       ),

//                       SizedBox(height: screenHeight * 0.03),

//                       _emailField(),
//                       SizedBox(height: screenHeight * 0.02),
//                       _passwordField(),
//                       SizedBox(height: screenHeight * 0.015),
//                       _rememberRow(),

//                       SizedBox(height: screenHeight * 0.035),

//                       _loginBtn(),
//                       SizedBox(height: screenHeight * 0.02),
//                       _signUpRow(),

//                       SizedBox(height: screenHeight * 0.02),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _logo({required double size}) {
//     if (useImageLogo) {
//       return SizedBox(
//         width: size,
//         height: size,
//         child: ClipRRect(
//           child: Image.asset(
//             logoImagePath,
//             fit: BoxFit.contain,
//             errorBuilder: (context, error, stackTrace) {
//               print('Erreur de chargement du logo: $error');
//               return _buildDefaultLogo(size);
//             },
//           ),
//         ),
//       );
//     } else {
//       return _buildDefaultLogo(size);
//     }
//   }

//   Widget _buildDefaultLogo(double size) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFFF9A825), Color(0xFFF57F17)],
//         ),
//         borderRadius: BorderRadius.circular(size * 0.27),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x66F9A825),
//             blurRadius: 20,
//             offset: Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Center(
//         child: Text(
//           'I',
//           style: TextStyle(
//             fontSize: size * 0.5,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _emailField() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: const [
//           BoxShadow(
//             color: Color.fromRGBO(0, 0, 0, 0.05),
//             blurRadius: 8,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextFormField(
//         controller: _emailCtrl,
//         style: const TextStyle(fontSize: 15, color: Color(0xFF1B5E20)),
//         decoration: InputDecoration(
//           hintText: 'email'.tr,
//           hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
//           prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFF9A825), size: 22),
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide.none,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
//           ),
//           contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
//           errorStyle: const TextStyle(
//             fontSize: 12,
//             height: 0.8,
//             color: Color(0xFFD32F2F),
//           ),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'email_required'.tr;
//           }
//           if (!value.contains('@') || !value.contains('.')) {
//             return 'invalid_email'.tr;
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   Widget _passwordField() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: const [
//           BoxShadow(
//             color: Color.fromRGBO(0, 0, 0, 0.05),
//             blurRadius: 8,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextFormField(
//         controller: _passCtrl,
//         obscureText: _obscure,
//         style: const TextStyle(fontSize: 15, color: Color(0xFF1B5E20)),
//         decoration: InputDecoration(
//           hintText: 'password'.tr,
//           hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
//           prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFF9A825), size: 22),
//           suffixIcon: IconButton(
//             icon: Icon(
//               _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
//               color: Colors.grey,
//               size: 20,
//             ),
//             onPressed: () => setState(() => _obscure = !_obscure),
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide.none,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
//           ),
//           contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
//           errorStyle: const TextStyle(
//             fontSize: 12,
//             height: 0.8,
//             color: Color(0xFFD32F2F),
//           ),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'password_required'.tr;
//           }
//           if (value.length < 6) {
//             return 'password_min_length'.tr;
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   Widget _rememberRow() {
//     return Row(
//       children: [
//         SizedBox(
//           width: 22,
//           height: 22,
//           child: Checkbox(
//             value: _remember,
//             onChanged: (value) {
//               setState(() {
//                 _remember = value ?? false;
//               });
//             },
//             activeColor: const Color(0xFF2E7D32),
//             checkColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(5),
//             ),
//             side: BorderSide(color: Colors.grey.shade400, width: 1.5),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Text(
//           'remember_me'.tr,
//           style: const TextStyle(fontSize: 13, color: Colors.black54),
//         ),
//         const Spacer(),
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
//             );
//           },
//           style: TextButton.styleFrom(
//             padding: EdgeInsets.zero,
//             minimumSize: const Size(0, 0),
//             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           ),
//           child: Text(
//             'forgot_password'.tr,
//             style: const TextStyle(
//               fontSize: 13,
//               color: Color(0xFF2E7D32),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _loginBtn() {
//     return SizedBox(
//       width: double.infinity,
//       height: 52,
//       child: ElevatedButton(
//         onPressed: () {

//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF2E7D32),
//           foregroundColor: Colors.white,
//           elevation: 2,
//           shadowColor: const Color(0x4D2E7D32),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//         ),
//         child: Text(
//           'login'.tr,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _signUpRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           'no_account'.tr,
//           style: const TextStyle(color: Colors.black54, fontSize: 13),
//         ),
//         GestureDetector(
//           onTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(builder: (_) => const RegisterScreen()),
//             );
//           },
//           child: Text(
//             'create_account'.tr,
//             style: const TextStyle(
//               color: Color(0xFF2E7D32),
//               fontWeight: FontWeight.w700,
//               fontSize: 13,
//               decoration: TextDecoration.underline,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// ignore_for_file: avoid_print, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:isetagcom/screens/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/auth_provider.dart';
import '../routes/app_router.dart';
import '../services/api_service.dart';
import '../services/translation_service.dart';
import 'forgot_password.dart';

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

  // ✅ Méthode de login
  // Future<void> _login() async {
  //   // Valide le formulaire (email/mdp) avant tout appel réseau
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }

  //   // Empêche les doubles soumissions pendant l'appel en cours
  //   if (_isLoading) return;

  //   FocusScope.of(context).unfocus();

  //   setState(() => _isLoading = true);

  //   try {
  //     final result = await _apiService.login(
  //       _emailCtrl.text.trim(),
  //       _passCtrl.text,
  //     );

  //     if (!mounted) return;

  //     if (result['success'] == true) {
  //       // ✅ Persiste ou efface l'email mémorisé selon la case "remember me"
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setBool('remember_me', _remember);
  //       if (_remember) {
  //         await prefs.setString('remembered_email', _emailCtrl.text.trim());
  //       } else {
  //         await prefs.remove('remembered_email');
  //       }

  //       // ✅ Redirige vers l'accueil en vidant la pile de navigation
  //       // pour empêcher un retour arrière vers l'écran de login.
  //       Navigator.of(context).pushNamedAndRemoveUntil(
  //         AppRoutes.home,
  //         (route) => false,
  //       );
  //     } else {
  //       _showError(result['body']?.toString() ?? 'login_failed'.tr);
  //       print(result['body']?.toString());
  //     }
  //   } catch (e) {
  //     if (!mounted) return;
  //     _showError('login_error'.tr);
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }

  Future<void> _login() async {
    // Validate the form before making the network call
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Prevent double submissions
    if (_isLoading) return;

    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
      // ✅ Use AuthProvider to login
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );

      if (!mounted) return;

      if (success) {
        // ✅ Save remember me preference using AuthProvider
        await authProvider.saveRememberMe(_remember, _emailCtrl.text.trim());

        // ✅ Navigate to home screen
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.main,
          (route) => false,
        );
      } else {
        // Show error from provider
        final errorMessage = authProvider.errorMessage ?? 'login_failed'.tr;
        _showError("Try again");
        print("Login error: $errorMessage");
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

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
                      // _rememberRow(),

                      // SizedBox(height: screenHeight * 0.035),

                      _loginBtn(),
                      // SizedBox(height: screenHeight * 0.02),
                      // _signUpRow(),

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

  Widget _rememberRow() {
    return Row(
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: _remember,
            onChanged: _isLoading
                ? null
                : (value) {
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
        Text(
          'remember_me'.tr,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const Spacer(),
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen()),
                  );
                },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'forgot_password'.tr,
            style: const TextStyle(
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

  Widget _signUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'no_account'.tr,
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
        GestureDetector(
          onTap: _isLoading
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
          child: Text(
            'create_account'.tr,
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
}
