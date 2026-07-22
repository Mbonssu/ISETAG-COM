// lib/screens/legal_detail_screen.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:isetagcom/utils/legal_texts.dart';
import 'package:isetagcom/utils/themes/app_colors.dart';
import 'package:isetagcom/services/translation_service.dart';

enum LegalSection { version, terms, privacy }

class LegalDetailScreen extends StatefulWidget {
  final LegalSection section;

  const LegalDetailScreen({super.key, required this.section});

  @override
  State<LegalDetailScreen> createState() => _LegalDetailScreenState();
}

class _LegalDetailScreenState extends State<LegalDetailScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final version = await LegalTexts.getAppVersion();
    if (mounted) {
      setState(() {
        _version = version;
      });
    }
  }

  String get _title {
    switch (widget.section) {
      case LegalSection.version:
        return 'version'.tr;
      case LegalSection.terms:
        return 'terms_of_use'.tr;
      case LegalSection.privacy:
        return 'privacy_policy'.tr;
    }
  }

  String get _content {
    switch (widget.section) {
      case LegalSection.version:
        return 'App Version: $_version';
      case LegalSection.terms:
        return LegalTexts.termsOfUse;
      case LegalSection.privacy:
        return LegalTexts.privacyPolicy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(
          _title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: widget.section == LegalSection.version
          ? _buildVersionBody()
          : _buildLegalBody(),
    );
  }

  // ─── Version (centered) ─────────────────────────────────────────────

  Widget _buildVersionBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(32),
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
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'App Version',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _version.isEmpty ? 'Loading...' : _version,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Legal texts (scrollable) ───────────────────────────────────────

  Widget _buildLegalBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
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
        child: Text(
          _content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}