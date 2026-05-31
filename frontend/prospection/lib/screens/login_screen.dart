import 'package:flutter/material.dart';
import '../utils/themes/glass_theme.dart';
//import '../routes/app_router.dart';
// import '../config/app_config.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _remember = false;
  bool _obscure = true;
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 44),
                _logo(),
                const SizedBox(height: 8),
                const Text('ISETAG',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
                      color: G.green, letterSpacing: 3)),
                const SizedBox(height: 2),
                const Text('Prospection & Communication',
                  style: TextStyle(fontSize: 11, color: G.green)),
                const SizedBox(height: 28),
                const Text('Bienvenue !',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                      color: G.textDark)),
                const SizedBox(height: 6),
                const Text('Connectez-vous pour continuer\nà gérer vos prospections.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: G.textMedium, height: 1.5)),
                const SizedBox(height: 28),
                _glassField(
                  controller: _emailCtrl,
                  hint: 'Email',
                  icon: Icons.mail_outline,
                ),
                const SizedBox(height: 12),
                _glassPasswordField(),
                const SizedBox(height: 12),
                _rememberRow(),
                const SizedBox(height: 22),
                _loginBtn(),
                const SizedBox(height: 16),
                _orDivider(),
                const SizedBox(height: 16),
                _googleBtn(),
                const SizedBox(height: 26),
                RichText(text: const TextSpan(
                  text: 'Pas encore de compte ? ',
                  style: TextStyle(color: G.textMedium, fontSize: 12),
                  children: [TextSpan(
                    text: 'Créer un compte',
                    style: TextStyle(color: G.green, fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: G.green),
                  )],
                )),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Logo dans un cercle glass ──
  Widget _logo() {
    return GlassBox(
      borderRadius: 50, width: 90, height: 90,
      bgColor: const Color(0x73FFFFFF),
      borderColor: const Color(0xBFFFFFFF),
      shadows: [
        BoxShadow(color: G.green.withValues(alpha: 0.22), blurRadius: 28, offset: const Offset(0,8)),
        BoxShadow(color: Colors.white.withValues(alpha: 0.9), blurRadius: 0, offset: const Offset(0,1)),
      ],
      child: Center(child: _IsetagLogo()),
    );
  }

  // ── Champ texte glass ──
  Widget _glassField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return GlassBox(
      height: 52, borderRadius: 13,
      bgColor: G.glassInput, borderColor: G.glassBorder,
      shadows: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(children: [
          Icon(icon, color: G.textLight, size: 19),
          const SizedBox(width: 10),
          Expanded(child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 13, color: G.textDark),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: G.textLight, fontSize: 13),
              border: InputBorder.none,
              isCollapsed: true,
            ),
          )),
        ]),
      ),
    );
  }

  Widget _glassPasswordField() {
    return GlassBox(
      height: 52, borderRadius: 13,
      bgColor: G.glassInput, borderColor: G.glassBorder,
      shadows: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(children: [
          const Icon(Icons.lock_outline, color: G.textLight, size: 19),
          const SizedBox(width: 10),
          Expanded(child: TextField(
            controller: _passCtrl,
            obscureText: _obscure,
            style: const TextStyle(fontSize: 13, color: G.textDark),
            decoration: const InputDecoration(
              hintText: 'Mot de passe',
              hintStyle: TextStyle(color: G.textLight, fontSize: 13),
              border: InputBorder.none, isCollapsed: true,
            ),
          )),
          GestureDetector(
            onTap: () => setState(() => _obscure = !_obscure),
            child: Icon(
              _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: G.textLight, size: 19,
            ),
          ),
        ]),
      ),
    );
  }

  Widget _rememberRow() {
    return Row(children: [
      GestureDetector(
        onTap: () => setState(() => _remember = !_remember),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 16, height: 16,
          decoration: BoxDecoration(
            border: Border.all(
              color: _remember ? G.green : Colors.grey.shade400, width: 1.5),
            borderRadius: BorderRadius.circular(4),
            color: _remember ? G.green.withValues(alpha: 0.15) : Colors.transparent,
          ),
          child: _remember
              ? const Icon(Icons.check, color: G.green, size: 11)
              : null,
        ),
      ),
      const SizedBox(width: 8),
      const Text('Se souvenir de moi',
          style: TextStyle(fontSize: 12, color: G.textMedium)),
      const Spacer(),
      const Text('Mot de passe oublié ?',
          style: TextStyle(fontSize: 12, color: G.green, fontWeight: FontWeight.w700)),
    ]);
  }

  Widget _loginBtn() {
    return GlassBox(
      height: 52, borderRadius: 14,
      bgColor: G.btnPrimaryBg,
      borderColor: G.btnPrimaryBorder,
      shadows: [
        BoxShadow(color: G.green.withValues(alpha: 0.40), blurRadius: 20, offset: const Offset(0,6)),
        BoxShadow(color: Colors.white.withValues(alpha: 0.15), blurRadius: 0, offset: const Offset(0,1)),
      ],
      onTap: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen())),
      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Se connecter',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
        SizedBox(width: 8),
        Icon(Icons.arrow_forward, color: Colors.white, size: 18),
      ]),
    );
  }

  Widget _orDivider() {
    return Row(children: [
      Expanded(child: Container(height: 1, color: Colors.black.withValues(alpha: 0.1))),
      const Padding(padding: EdgeInsets.symmetric(horizontal: 14),
          child: Text('OU', style: TextStyle(fontSize: 11, color: G.textLight))),
      Expanded(child: Container(height: 1, color: Colors.black.withValues(alpha: 0.1))),
    ]);
  }

  Widget _googleBtn() {
    return GlassBox(
      height: 52, borderRadius: 14,
      bgColor: G.glassInput, borderColor: G.glassBorder,
      shadows: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      onTap: () {},
      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _GoogleIcon(),
        SizedBox(width: 10),
        Text('Continuer avec Google',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: G.textDark)),
      ]),
    );
  }
}

// ── Logo ISETAG custom paint ──────────────────────────────────────────────────
class _IsetagLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      SizedBox(width: 58, height: 58, child: CustomPaint(painter: _LogoPainter()));
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2;
    // Bouclier
    final shield = Path()
      ..moveTo(cx, s.height * 0.04)
      ..lineTo(s.width * 0.92, s.height * 0.20)
      ..lineTo(s.width * 0.92, s.height * 0.62)
      ..quadraticBezierTo(s.width * 0.92, s.height * 0.88, cx, s.height * 0.98)
      ..quadraticBezierTo(s.width * 0.08, s.height * 0.88, s.width * 0.08, s.height * 0.62)
      ..lineTo(s.width * 0.08, s.height * 0.20)
      ..close();
    canvas.drawPath(shield,
        Paint()..color = G.green.withValues(alpha: 0.08)..style = PaintingStyle.fill);
    canvas.drawPath(shield,
        Paint()..color = G.green..style = PaintingStyle.stroke..strokeWidth = 2.5);
    // Globe
    canvas.drawCircle(Offset(cx, cy), s.width * 0.26,
        Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 1.4);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy),
        width: s.width * 0.52, height: s.width * 0.34),
        Paint()..color = G.green..style = PaintingStyle.stroke..strokeWidth = 1.5);
    // Silhouette gauche
    final p = Paint()..color = G.green..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 6.5, cy - 3), 4.5, p);
    canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 10, cy + 2, 7.5, 9.5), const Radius.circular(3)), p);
    // Silhouette droite
    canvas.drawCircle(Offset(cx + 6.5, cy - 3), 4.5, p);
    canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 2.5, cy + 2, 7.5, 9.5), const Radius.circular(3)), p);
    // Texte ISETAG
    final tp = TextPainter(
      text: const TextSpan(text: 'ISETAG',
          style: TextStyle(color: Color(0xFFD4A017), fontSize: 8,
              fontWeight: FontWeight.w900, letterSpacing: 0.8)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, s.height * 0.07));
  }
  @override bool shouldRepaint(_) => false;
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();
  @override
  Widget build(BuildContext context) =>
      SizedBox(width: 18, height: 18, child: CustomPaint(painter: _GooglePainter()));
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2, r = s.width / 2 - 0.5;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    final sw = Paint()..strokeWidth = 3.2..style = PaintingStyle.stroke;
    canvas.drawArc(rect, -1.57, 3.14, false, sw..color = const Color(0xFF4285F4));
    canvas.drawArc(rect, 1.57, 1.57, false, sw..color = const Color(0xFF34A853));
    canvas.drawArc(rect, -1.57, -3.14, false, sw..color = const Color(0xFFEA4335));
    canvas.drawArc(rect, 0.0, 1.57, false, sw..color = const Color(0xFFFBBC05));
    canvas.drawRect(Rect.fromLTWH(cx, cy - 1.6, r - 0.5, 3.2),
        Paint()..color = const Color(0xFF4285F4));
  }
  @override bool shouldRepaint(_) => false;
}
