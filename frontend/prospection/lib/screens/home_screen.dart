// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:isetagcom/models/initializer.dart';
import 'package:isetagcom/models/stats.dart';
import '../models/localStorage/local_storage.dart';
import '../services/translation_service.dart';
import '../utils/themes/app_colors.dart';
import '../widgets/sync_progress.dart';
import 'prospect_detail_screen.dart';
import '../models/prospectData.dart';
import '../routes/app_router.dart';
import '../services/loading_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Cache pour les prospects
  List<ProspectDetails> _cachedProspectsFull = [];
  List<ProspectDetails> _cachedProspects = [];
  bool _isLoadingProspects = true;

  // Contrôleur pour le rafraîchissement
  late StreamSubscription<List<ProspectDetails>> _prospectsSubscription;

  // Service de chargement
  final LoadingService _loadingService = LoadingService();

  @override
  void initState() {
    super.initState();
    _initProspectsStream();
  }

  void _initProspectsStream() {
    _prospectsSubscription =
        LocalStorage.watchProspectsWithSpecs().listen((prospects) {
      if (mounted) {
        setState(() {
          // Just 4 last recorded Prospects
          _cachedProspects =
              prospects.reversed.take(7).toList().reversed.toList();
          // Just full recorded Prospects
          _cachedProspectsFull = prospects;

          _isLoadingProspects = false;
          Stats["all_prosp"] = prospects.length;
        });
      }
    }, onError: (error) {
      print('Erreur stream prospects: $error');
      if (mounted) {
        setState(() => _isLoadingProspects = false);
      }
    });
  }

  @override
  void dispose() {
    _prospectsSubscription.cancel();
    super.dispose();
  }

  Future<void> _refreshData() async {
    _loadingService.show(context, message: 'refreshing'.tr);
    await Future.delayed(const Duration(milliseconds: 500));
    _loadingService.hide();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: _buildNeumorphicBackground(
        child: Column(
          children: [
            //  SyncProgress in a Container with proper padding
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const SyncProgress(),
            ),
            const SizedBox(height: 4),
            _buildNeumorphicHeader(isSmallScreen),
            Expanded(child: _buildBody(isSmallScreen)),
          ],
        ),
      ),
      bottomNavigationBar: _buildNeumorphicBottomNav(screenWidth),
      floatingActionButton: _buildNeumorphicFab(isSmallScreen),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildNeumorphicBackground({required Widget child}) {
    return Container(
      color: AppColors.backgroundGrey,
      child: child,
    );
  }

  Widget _buildNeumorphicHeader(bool isSmallScreen) {
    final double headerMargin = isSmallScreen ? 12.0 : 16.0;
    final double headerPadding = isSmallScreen ? 16.0 : 20.0;
    final double avatarSize = isSmallScreen ? 44.0 : 52.0;
    final double fontSizeTitle = isSmallScreen ? 22.0 : 26.0;
    final double fontSizeSubtitle = isSmallScreen ? 13.0 : 15.0;

    return Container(
      margin: EdgeInsets.all(headerMargin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            blurRadius: 15,
            offset: const Offset(-5, -5),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(6, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryGreen,
                AppColors.secondaryGreen,
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.all(headerPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'good_morning'.tr,
                              style: TextStyle(
                                fontSize: fontSizeSubtitle,
                                color: AppColors.textWhite70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Jean Morreaux.',
                              style: TextStyle(
                                fontSize: fontSizeTitle,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textOnPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.25),
                              blurRadius: 6,
                              offset: const Offset(-2, -2),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 6,
                              offset: const Offset(3, 3),
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          color: AppColors.textOnPrimary,
                          size: avatarSize * 0.5,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: avatarSize,
                            height: avatarSize,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.25),
                                  blurRadius: 6,
                                  offset: const Offset(-2, -2),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 6,
                                  offset: const Offset(3, 3),
                                ),
                              ],
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.25),
                                  Colors.white.withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: Icon(
                              Icons.notifications_none_outlined,
                              color: AppColors.textOnPrimary,
                              size: avatarSize * 0.5,
                            ),
                          ),
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.badgeOrange,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.badgeOrange.withOpacity(0.4),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                    color: AppColors.textOnPrimary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: isSmallScreen ? 48 : 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      color: AppColors.backgroundGrey,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.6),
                          blurRadius: 8,
                          offset: const Offset(-3, -3),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(4, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Icon(
                          Icons.search,
                          color: AppColors.textTertiary,
                          size: isSmallScreen ? 20 : 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            onTap: () {
                              _loadingService.show(context,
                                  message: 'Chargement...');
                              Future.delayed(const Duration(milliseconds: 300),
                                  () {
                                _loadingService.hide();
                                Navigator.pushNamed(
                                    context, AppRoutes.prospectsList,
                                    arguments: {
                                      'prospectsList': _cachedProspectsFull
                                    });
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'search_hint'.tr,
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: isSmallScreen ? 13 : 14,
                              ),
                              border: InputBorder.none,
                            ),
                            readOnly: true,
                          ),
                        ),
                        Container(
                          width: isSmallScreen ? 36 : 40,
                          height: isSmallScreen ? 36 : 40,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                blurRadius: 4,
                                offset: const Offset(-2, -2),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0.15),
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.tune_outlined,
                            color: AppColors.primaryGreen,
                            size: isSmallScreen ? 18 : 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNeumorphicBottomNav(double screenWidth) {
    final items = [
      {
        'icon': Icons.home_outlined,
        'activeIcon': Icons.home,
        'label': 'home'.tr,
        'badge': null,
        'route': AppRoutes.home
      },
      {
        'icon': Icons.people_outline,
        'activeIcon': Icons.people,
        'label': 'prospects'.tr,
        'badge': null,
        'route': AppRoutes.fiches
      },
      {
        'icon': Icons.access_time_outlined,
        'activeIcon': Icons.access_time,
        'label': 'follow_ups'.tr,
        'badge': 2,
        'route': AppRoutes.relances
      },
      {
        'icon': Icons.settings_outlined,
        'activeIcon': Icons.settings,
        'label': 'settings'.tr,
        'badge': null,
        'route': AppRoutes.settings
      },
    ];

    final double navMargin = screenWidth < 600 ? 16.0 : 20.0;
    final double navHeight = screenWidth < 600 ? 60 : 65;
    final double iconSize = screenWidth < 600 ? 20 : 22;
    const double borderRadius = 30;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: navMargin, vertical: 12),
      height: navHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: AppColors.backgroundGrey,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 10,
            offset: const Offset(-4, -4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          int index = entry.key;
          var item = entry.value;
          bool isActive = _selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (index == 0) {
                  setState(() => _selectedIndex = index);
                } else if (item['route'] != null) {
                  Navigator.pushNamed(context, item['route'] as String);
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: isActive
                      ? Colors.white.withOpacity(0.3)
                      : Colors.transparent,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          isActive
                              ? (item['activeIcon'] as IconData)
                              : (item['icon'] as IconData),
                          color: isActive
                              ? AppColors.primaryGreen
                              : AppColors.textTertiary,
                          size: iconSize,
                        ),
                        if (item['badge'] != null && !isActive)
                          Positioned(
                            top: -6,
                            right: -10,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: AppColors.badgeOrange,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${item['badge']}',
                                style: const TextStyle(
                                  color: AppColors.textOnPrimary,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        fontSize: screenWidth < 600 ? 10 : 11,
                        color: isActive
                            ? AppColors.primaryGreen
                            : AppColors.textTertiary,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBody(bool isSmallScreen) {
    final double bodyPadding = isSmallScreen ? 12.0 : 16.0;

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppColors.primaryGreen,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: bodyPadding, vertical: 12),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'today_overview'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildNeumorphicStatsGrid(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'recent_prospections'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _loadingService.show(context, message: 'loading'.tr);
                    Future.delayed(const Duration(milliseconds: 500), () {
                      _loadingService.hide();
                      Navigator.pushNamed(context, AppRoutes.prospectsList,
                          arguments: {'prospectsList': _cachedProspectsFull});
                    });
                  },
                  child: Text(
                    'view_all'.tr,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Affichage à partir du cache
            _isLoadingProspects
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                      ),
                    ),
                  )
                : _cachedProspects.isEmpty
                    ? Column(
                        children: [
                          const SizedBox(height: 40),
                          const Icon(
                            Icons.person_off_outlined,
                            size: 62,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              'no_prospects_found'.tr,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _cachedProspects.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index) {
                          final prospectDetail = _cachedProspects[index];
                          return _buildNeumorphicProspectCard(
                              prospectDetail, isSmallScreen);
                        },
                      ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildNeumorphicStatsGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final double cardPadding = isSmallScreen ? 12.0 : 14.0;
    final double iconSize = isSmallScreen ? 20 : 22;
    final double valueFontSize = isSmallScreen ? 20 : 22;

    return StreamBuilder<Map<String, dynamic>>(
      stream: LocalStorage.instance.watchStatsOptimized(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(4, (_) => _buildShimmerCard()),
          );
        }

        final stats = snapshot.data!;

        final statsData = [
          {
            'icon': Icons.people_outline,
            'value': stats['totalFormatted'] ?? '0',
            'label': 'prospects_added'.tr,
            'color': AppColors.statGreen
          },
          {
            'icon': Icons.access_time_outlined,
            'value': stats['aRelancerFormatted'] ?? '0',
            'label': 'to_relaunch'.tr,
            'color': AppColors.statOrange
          },
          {
            'icon': Icons.file_copy_sharp,
            // 'value': stats['visitesFormatted'] ?? '0',
            'value': stats['fiche_formatted'] ?? '0',
            'label': 'all_fiches'.tr,
            'color': AppColors.statBlue
          },
          {
            'icon': Icons.person_add_outlined,
            'value': stats['nouveauxFormatted'] ?? '0',
            'label': 'new_established'.tr,
            'color': AppColors.statYellow
          },
        ];

        return GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: statsData.map((s) {
            return Container(
              padding: EdgeInsets.all(cardPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.backgroundGrey,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.6),
                    blurRadius: 6,
                    offset: const Offset(-3, -3),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: iconSize + 14,
                    height: iconSize + 14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(-2, -2),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.4),
                          Colors.white.withOpacity(0.15),
                        ],
                      ),
                    ),
                    child: Icon(s['icon'] as IconData,
                        color: s['color'] as Color, size: iconSize),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          s['value'] as String,
                          style: TextStyle(
                            fontSize: valueFontSize,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s['label'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade200,
      ),
    );
  }

  Widget _buildNeumorphicProspectCard(
      ProspectDetails prospectDetail, bool isSmallScreen) {
    final double cardPadding = isSmallScreen ? 12.0 : 14.0;
    final double avatarSize = isSmallScreen ? 46 : 52;
    final double fontSize = isSmallScreen ? 14 : 15;

    final hasSpecialities = prospectDetail.specialities.isNotEmpty;
    final firstSpeciality = hasSpecialities
        ? prospectDetail.specialities[0].libelleSpecialite
        : 'no_specialty'.tr;
    final hasMultipleSpecialities = prospectDetail.specialities.length > 1;

    final interestText = hasMultipleSpecialities
        ? 'interested_in_etc'.tr.replaceFirst('{spec}', firstSpeciality)
        : 'interested_in'.tr.replaceFirst('{spec}', firstSpeciality);

    final firstLetter = prospectDetail.prosp.nomComplet.isNotEmpty
        ? prospectDetail.prosp.nomComplet[0]
        : '?';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.backgroundGrey,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.7),
              blurRadius: 8,
              offset: const Offset(-3, -3),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(5, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              _loadingService.show(context, message: 'Chargement...');
              Future.delayed(const Duration(milliseconds: 200), () {
                _loadingService.hide();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProspectDetailScreen(prospect: prospectDetail),
                  ),
                );
              });
            },
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Row(
                children: [
                  Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 5,
                          offset: const Offset(-2, -2),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(3, 3),
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(prospectDetail.color).withOpacity(0.85),
                          Color(prospectDetail.color).withOpacity(0.55),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        firstLetter.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: fontSize - 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prospectDetail.prosp.nomComplet,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          prospectDetail.etablissement,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          interestText,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildNeumorphicBadge(
                      prospectDetail.prosp.prospectStatus.name),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right,
                      color: AppColors.textTertiary, size: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNeumorphicBadge(String status) {
    Color badgeColor;
    String label;

    switch (status.toLowerCase()) {
      case 'relancer':
        badgeColor = AppColors.statusPending;
        label = 'to_relaunch_badge'.tr;
        break;
      case 'nouveau':
        badgeColor = AppColors.statusNew;
        label = 'new_badge'.tr;
        break;
      case 'contacte':
        badgeColor = AppColors.statusContacted;
        label = 'contacted_badge'.tr;
        break;
      default:
        badgeColor = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: badgeColor.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.4),
            blurRadius: 3,
            offset: const Offset(-1, -1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 3,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: badgeColor,
        ),
      ),
    );
  }

  Widget _buildNeumorphicFab(bool isSmallScreen) {
    final double fabSize = isSmallScreen ? 54 : 58;
    final double iconSize = isSmallScreen ? 26 : 30;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          _loadingService.show(context, message: 'Chargement...');
          Future.delayed(const Duration(milliseconds: 300), () {
            _loadingService.hide();
            Navigator.pushNamed(context, AppRoutes.addProspect);
          });
        },
        child: Container(
          width: fabSize,
          height: fabSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryGreen,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.6),
                blurRadius: 8,
                offset: const Offset(-3, -3),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(5, 5),
              ),
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryGreen,
                AppColors.secondaryGreen,
              ],
            ),
          ),
          child:
              Icon(Icons.add, color: AppColors.textOnPrimary, size: iconSize),
        ),
      ),
    );
  }
}