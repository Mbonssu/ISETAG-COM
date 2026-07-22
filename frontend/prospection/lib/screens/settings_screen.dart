// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/auth_provider.dart';
import '../services/translation_service.dart';
import '../services/loading_service.dart';
import '../services/api_service.dart';
import '../utils/themes/app_colors.dart';
import '../routes/app_router.dart';
import 'legal_infos_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'fr';

  // Social media URLs
  final String _whatsappUrl = 'https://wa.me/2376XXXXXXX';
  final String _linkedinUrl = 'https://www.linkedin.com/company/isetag';
  final String _facebookUrl = 'https://www.facebook.com/isetag';
  final String _twitterUrl = 'https://twitter.com/isetag';
  final String _websiteUrl = 'https://www.isetag.com';

  final LoadingService _loadingService = LoadingService();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'fr';
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    _loadingService.show(context, message: 'language_toggle'.tr);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    await TranslationService.setLocale(Locale(languageCode));

    setState(() {
      _selectedLanguage = languageCode;
    });

    await Future.delayed(const Duration(milliseconds: 800));
    _loadingService.hide();
  }

  Future<void> _launchUrl(String url) async {
    _loadingService.show(context, message: 'opening'.tr);

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await Future.delayed(const Duration(milliseconds: 200));
      _loadingService.hide();
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _loadingService.hide();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('cannot_open_link'.tr),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ─── LOGOUT METHOD ──────────────────────────────────────────────────────

  Future<void> _performLogout() async {
    _loadingService.show(context, message: 'logging_out'.tr);

    try {
      final result = await _apiService.logout();

      await Future.delayed(const Duration(milliseconds: 500));
      _loadingService.hide();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'logged_out_successfully'.tr),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );
      }
    } catch (e) {
      _loadingService.hide();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('logout_error'.tr),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );
      }
    }
  }

  // ─── BUILD ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;
    final agent = authProvider.currentAgent;

    final userName = user?.fullName ?? 'Utilisateur';
    final userEmail = user?.email ?? 'Non renseigné';
    final userPhone = user?.telephone ?? 'Non renseigné';
    final userInitials = user?.initials ?? 'U';
    final userRole = user?.role ?? 'agent';
    final agentMatricule = agent?.matriculeAgent ?? 'Non renseigné';
    final isAgent = authProvider.isAgent;

    String registrationDate = 'Non renseignée';
    if (user?.createdAt != null) {
      try {
        registrationDate =
            '${user!.createdAt!.day} ${_getMonthName(user.createdAt!.month)} ${user.createdAt!.year}';
      } catch (e) {
        registrationDate = 'Non renseignée';
      }
    }

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
                  _buildProfileCard(
                    userName: userName,
                    userEmail: userEmail,
                    userPhone: userPhone,
                    userInitials: userInitials,
                    userRole: userRole,
                    isAgent: isAgent,
                    agentMatricule: agentMatricule,
                  ),
                  const SizedBox(height: 16),
                  _buildAccountCard(
                    userEmail: userEmail,
                    userPhone: userPhone,
                    registrationDate: registrationDate,
                  ),
                  const SizedBox(height: 16),
                  _buildSystemCard(),
                  const SizedBox(height: 16),
                  _buildAboutCard(),
                  const SizedBox(height: 24),
                  _buildLogoutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── HEADER ──────────────────────────────────────────────────────────────

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
            // GestureDetector(
            //   onTap: () => Navigator.pushNamed(context, AppRoutes.main),
            //   child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            // ),
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.settings_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── PROFIL ──────────────────────────────────────────────────────────────

  Widget _buildProfileCard({
    required String userName,
    required String userEmail,
    required String userPhone,
    required String userInitials,
    required String userRole,
    required bool isAgent,
    required String agentMatricule,
  }) {
    String roleDisplayName;
    switch (userRole.toLowerCase()) {
      case 'admin':
        roleDisplayName = 'Administrateur';
        break;
      case 'agent':
        roleDisplayName = 'Agent de Prospection';
        break;
      case 'user':
        roleDisplayName = 'Utilisateur';
        break;
      default:
        roleDisplayName = userRole;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar and Name Row
          Row(
            children: [
              // Avatar
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryGreen,
                      AppColors.primaryGreen.withOpacity(0.7)
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    userInitials,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Name and Role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            roleDisplayName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                        if (isAgent && agentMatricule != 'Non renseigné') ...[
                          const SizedBox(width: 8),
                          // Container(
                          //   padding: const EdgeInsets.symmetric(
                          //     horizontal: 10,
                          //     vertical: 3,
                          //   ),
                          //   decoration: BoxDecoration(
                          //     color: Colors.grey.withOpacity(0.1),
                          //     borderRadius: BorderRadius.circular(12),
                          //   ),
                          //   child: Text(
                          //     'Matricule: $agentMatricule',
                          //     style: TextStyle(
                          //       fontSize: 11,
                          //       fontWeight: FontWeight.w500,
                          //       color: Colors.grey.shade700,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // const Divider(height: 1, color: Colors.grey),
          // const SizedBox(height: 16),
          // Contact Information
          // Row(
          //   children: [
          //     Expanded(
          //       child: _buildContactInfo(
          //         icon: Icons.email_outlined,
          //         label: 'Email',
          //         value: userEmail,
          //       ),
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: _buildContactInfo(
          //         icon: Icons.phone_outlined,
          //         label: 'Téléphone',
          //         value: userPhone,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildContactInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ─── COMPTE ──────────────────────────────────────────────────────────────

  Widget _buildAccountCard({
    required String userEmail,
    required String userPhone,
    required String registrationDate,
  }) {
    return _buildSectionCard(
      title: 'account_info'.tr,
      icon: Icons.account_circle_outlined,
      children: [
        _buildInfoTile(
          icon: Icons.email_outlined,
          title: 'email'.tr,
          value: userEmail,
        ),
        Divider(height: 1, color: Colors.grey.shade200),
        _buildInfoTile(
          icon: Icons.phone_outlined,
          title: 'phone'.tr,
          value: userPhone,
        ),
        Divider(height: 1, color: Colors.grey.shade200),
        _buildInfoTile(
          icon: Icons.calendar_today_outlined,
          title: 'registration_date'.tr,
          value: registrationDate,
        ),
      ],
    );
  }

  // ─── SYSTÈME ─────────────────────────────────────────────────────────────

  Widget _buildSystemCard() {
    return _buildSectionCard(
      title: 'system'.tr,
      icon: Icons.settings_applications,
      children: [
        _buildMenuTile(
          icon: Icons.language_rounded,
          title: 'language'.tr,
          subtitle: _selectedLanguage == 'fr' ? 'Français' : 'English',
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: _showLanguageDialog,
        ),
        Divider(height: 1, color: Colors.grey.shade200),
        _buildMenuTile(
          icon: Icons.sync_rounded,
          title: 'sync_status'.tr,
          subtitle: 'view_sync_progress'.tr,
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () => Navigator.pushNamed(context, AppRoutes.syncRoute),
        ),
        // Divider(height: 1, color: Colors.grey.shade200),
        // _buildMenuTile(
        //   icon: Icons.notifications_rounded,
        //   title: 'notifications'.tr,
        //   subtitle: 'manage_notifications'.tr,
        //   trailing: Switch(
        //     value: true,
        //     onChanged: (_) {},
        //     activeColor: AppColors.primaryGreen,
        //   ),
        //   onTap: () {},
        // ),
      ],
    );
  }

  // ─── À PROPOS ────────────────────────────────────────────────────────────

// In _SettingsScreenState, replace the existing _buildAboutCard and add a helper.

Widget _buildAboutCard() {
  return _buildSectionCard(
    title: 'about'.tr,
    icon: Icons.info_outline,
    children: [
      _buildMenuTile(
        icon: Icons.verified_user_outlined,
        title: 'version'.tr,
        subtitle: 'view_version'.tr,   // make sure to add this translation
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => _navigateToLegal(LegalSection.version),
      ),
      Divider(height: 1, color: Colors.grey.shade200),
      _buildMenuTile(
        icon: Icons.description_outlined,
        title: 'terms_of_use'.tr,
        subtitle: 'read_terms'.tr,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => _navigateToLegal(LegalSection.terms),
      ),
      Divider(height: 1, color: Colors.grey.shade200),
      _buildMenuTile(
        icon: Icons.privacy_tip_outlined,
        title: 'privacy_policy'.tr,
        subtitle: 'read_privacy_policy'.tr,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => _navigateToLegal(LegalSection.privacy),
      ),
    ],
  );
}

// Helper method
void _navigateToLegal(LegalSection section) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => LegalDetailScreen(section: section),
    ),
  );
}

  // ─── BOUTON DÉCONNEXION ────────────────────────────────────────────────

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: _showLogoutDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_outlined, color: Colors.red, size: 22),
            const SizedBox(width: 12),
            Text(
              'logout'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── WIDGETS GÉNÉRIQUES ────────────────────────────────────────────────

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primaryGreen, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primaryGreen),
          ),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.primaryGreen),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  // ─── DIALOGUES ──────────────────────────────────────────────────────────

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.language_rounded,
                size: 48,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(height: 12),
              Text(
                'select_language'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'choose_your_preferred_language'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildLanguageOption(
                flag: '🇫🇷',
                label: 'Français',
                code: 'fr',
                isSelected: _selectedLanguage == 'fr',
                onTap: () {
                  Navigator.pop(context);
                  _changeLanguage('fr');
                },
              ),
              const SizedBox(height: 8),
              _buildLanguageOption(
                flag: '🇬🇧',
                label: 'English',
                code: 'en',
                isSelected: _selectedLanguage == 'en',
                onTap: () {
                  Navigator.pop(context);
                  _changeLanguage('en');
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'cancel'.tr,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String flag,
    required String label,
    required String code,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primaryGreen
                      : AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primaryGreen,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  // ─── LOGOUT DIALOG ──────────────────────────────────────────────────────

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_outlined,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'logout'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'logout_confirmation'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('cancel'.tr),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _performLogout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'logout'.tr,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── HELPER METHODS ────────────────────────────────────────────────────

  String _getMonthName(int month) {
    const months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ];
    return months[month - 1];
  }
}
