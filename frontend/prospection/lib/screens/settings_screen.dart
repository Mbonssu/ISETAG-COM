// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/translation_service.dart';
import '../services/loading_service.dart';
import '../utils/themes/app_colors.dart';
import '../routes/app_router.dart'; // Add this import

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'fr';
  final String _userName = 'Jean Morreaux';
  final String _userEmail = 'jean.morreaux@isetag.com';
  final String _userPhone = '+237 6XX XXX XXX';

  // Social media URLs
  final String _whatsappUrl = 'https://wa.me/2376XXXXXXX';
  final String _linkedinUrl = 'https://www.linkedin.com/company/isetag';
  final String _facebookUrl = 'https://www.facebook.com/isetag';
  final String _twitterUrl = 'https://twitter.com/isetag';
  final String _websiteUrl = 'https://www.isetag.com';

  final LoadingService _loadingService = LoadingService();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'fr';
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    _loadingService.show(context, message: 'language_toggle'.tr);
    
    // Sauvegarder la préférence
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    
    // Appliquer la nouvelle langue
    await TranslationService.setLocale(Locale(languageCode));
    
    setState(() {
      _selectedLanguage = languageCode;
    });
    
    await Future.delayed(const Duration(milliseconds: 1000));
    _loadingService.hide();
    
    // Reconstruire l'application avec la nouvelle langue
    // if (mounted) {
    //   Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (_) => const SplashScreen()),
    //     (route) => false,
    //   );
    // }
  }

  Future<void> _launchUrl(String url) async {
    _loadingService.show(context, message: 'Ouverture...');
    
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await Future.delayed(const Duration(milliseconds: 200));
      _loadingService.hide();
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _loadingService.hide();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossible d\'ouvrir le lien'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileSection(),
                  const SizedBox(height: 16),
                  _buildAccountSection(),
                  const SizedBox(height: 16),
                  _buildSystemSection(),
                  const SizedBox(height: 16),
                  _buildSocialSection(),
                  const SizedBox(height: 16),
                  _buildAboutSection(),
                  const SizedBox(height: 16),
                  _buildLogoutSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'settings'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: 8),
              Text(
                'user_profile'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              _userName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              _userEmail,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Center(
            child: Text(
              _userPhone,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_circle_outlined, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: 8),
              Text(
                'account_info'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAccountTile(
            icon: Icons.email_outlined,
            title: 'email'.tr,
            value: _userEmail,
          ),
          _buildAccountTile(
            icon: Icons.phone_outlined,
            title: 'phone'.tr,
            value: _userPhone,
          ),
          _buildAccountTile(
            icon: Icons.calendar_today_outlined,
            title: 'registration_date'.tr,
            value: '15 Mars 2024',
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ NEW: System Section
  Widget _buildSystemSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.settings_applications, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: 8),
              Text(
                'system'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // ✅ Language option
          ListTile(
            leading: const Icon(Icons.language, color: AppColors.primaryGreen),
            title: Text('language'.tr),
            subtitle: Text(
              _selectedLanguage == 'fr' ? 'Français' : 'English',
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          const Divider(height: 1, color: Colors.grey),
          // ✅ Sync option
          ListTile(
            leading: const Icon(Icons.sync, color: AppColors.primaryGreen),
            title: Text('sync_status'.tr),
            subtitle: Text('view_sync_progress'.tr),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.syncRoute);
            },
          ),
        ],
      ),
    );
  }

  // ✅ Language Dialog
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('select_language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.flag),
              title: Text('language_french'.tr),
              trailing: Radio<String>(
                value: 'fr',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  Navigator.pop(context);
                  _changeLanguage(value!);
                },
                activeColor: AppColors.primaryGreen,
              ),
              onTap: () {
                Navigator.pop(context);
                _changeLanguage('fr');
              },
            ),
            ListTile(
              leading: const Icon(Icons.translate),
              title: Text('language_english'.tr),
              trailing: Radio<String>(
                value: 'en',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  Navigator.pop(context);
                  _changeLanguage(value!);
                },
                activeColor: AppColors.primaryGreen,
              ),
              onTap: () {
                Navigator.pop(context);
                _changeLanguage('en');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
        ],
      ),
    );
  }


  Widget _buildSocialSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.share_outlined, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: 8),
              Text(
                'follow_us'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSocialButton(
                icon: Icons.chat_bubble_outline,
                label: 'whatsapp'.tr,
                color: const Color(0xFF25D366),
                onTap: () => _launchUrl(_whatsappUrl),
              ),
              _buildSocialButton(
                icon: Icons.work_outline,
                label: 'linkedin'.tr,
                color: const Color(0xFF0077B5),
                onTap: () => _launchUrl(_linkedinUrl),
              ),
              _buildSocialButton(
                icon: Icons.facebook,
                label: 'facebook'.tr,
                color: const Color(0xFF1877F2),
                onTap: () => _launchUrl(_facebookUrl),
              ),
              _buildSocialButton(
                icon: Icons.web_outlined,
                label: 'website'.tr,
                color: AppColors.primaryGreen,
                onTap: () => _launchUrl(_websiteUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: 8),
              Text(
                'about'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.verified_user_outlined, color: AppColors.primaryGreen),
            title: Text('version'.tr),
            trailing: const Text('1.0.0'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined, color: AppColors.primaryGreen),
            title: Text('terms_of_use'.tr),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primaryGreen),
            title: Text('privacy_policy'.tr),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.lightShadow,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.logout_outlined, color: Colors.red, size: 22),
        ),
        title: Text(
          'logout'.tr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
        subtitle: Text('logout_subtitle'.tr),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => _showLogoutDialog(),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('logout'.tr),
        content: Text('logout_confirmation'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () async {
              _loadingService.show(context, message: 'Déconnexion...');
              await Future.delayed(const Duration(milliseconds: 500));
              _loadingService.hide();
              Navigator.pop(context);
              // Naviguer vers l'écran de connexion
              // Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('logout'.tr),
          ),
        ],
      ),
    );
  }
}