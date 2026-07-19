// // ignore_for_file: use_build_context_synchronously, deprecated_member_use

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:isar_community/isar.dart';
// import 'package:isetagcom/models/stats.dart';
// import 'package:provider/provider.dart';
// import '../models/classe.dart';
// import '../models/etablissement.dart';
// import '../models/interet_filiere.dart';
// import '../models/localStorage/local_storage.dart';
// import '../models/pros.dart';
// import '../models/specialite.dart';
// import '../models/user.dart';
// import '../provider/auth_provider.dart';
// import '../services/translation_service.dart';
// import '../utils/status.dart';
// import '../utils/themes/app_colors.dart';
// import '../widgets/sync_progress.dart';
// import 'prospect_detail_screen.dart';
// import '../models/prospectData.dart';
// import '../routes/app_router.dart';
// import '../services/loading_service.dart';
// import '../services/notification_counter_service.dart';

// // ignore_for_file: use_build_context_synchronously, deprecated_member_use
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
//   // ✅ Uniquement les 10 derniers prospects
//   List<ProspectDetails> _cachedProspects = [];
//   List<ProspectDetails> _cachedProspectsFull = [];
//   bool _isLoading = true;

//   // ✅ Nombre de notifications (relances programmées)
//   int _notificationCount = 0;
//   Timer? _notificationTimer;

//   // Service de chargement
//   final LoadingService _loadingService = LoadingService();
//   final NotificationCounterService _notificationService =
//       NotificationCounterService();

//   // ✅ Current locale
//   Locale _currentLocale = const Locale('fr');

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _currentLocale = TranslationService.currentLocale;
//     _loadLastProspects();
//     _loadNotificationCount();
//     _startNotificationTimer();

//     // ✅ Recharge la session persistée (nom/agent connecté) depuis le
//     // SharedPreferences local si ce n'est pas déjà fait.
//     context.read<AuthProvider>().init();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _notificationTimer?.cancel();
//     super.dispose();
//   }

//   // ✅ Rafraîchir le compteur quand l'app revient au premier plan
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _loadNotificationCount();
//     }
//   }

//   // ✅ Charger le nombre de notifications depuis SharedPreferences
//   Future<void> _loadNotificationCount() async {
//     final count = await _notificationService.getNotificationCount();
//     if (mounted) {
//       setState(() {
//         _notificationCount = count;
//       });
//     }
//   }

//   // ✅ Mettre à jour périodiquement le compteur de notifications
//   void _startNotificationTimer() {
//     _notificationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
//       _loadNotificationCount();
//     });
//   }

//   // ✅ Charger uniquement les 10 derniers prospects
//   Future<void> _loadLastProspects() async {
//     setState(() {
//       _isLoading = true;
//       _cachedProspects = [];
//       _cachedProspectsFull = [];
//     });

//     try {
//       final prospects = await _getLast10Prospects();

//       setState(() {
//         _cachedProspects = prospects;
//         _cachedProspectsFull = prospects;
//         _isLoading = false;
//         Stats["all_prosp"] = prospects.length;
//       });

//       // ✅ Mettre à jour le compteur de notifications
//       await _loadNotificationCount();
//     } catch (e) {
//       print('Error loading prospects: $e');
//       setState(() => _isLoading = false);
//     }
//   }

//   // ✅ Récupérer les 10 derniers prospects enregistrés
//   Future<List<ProspectDetails>> _getLast10Prospects() async {
//     final localStorage = LocalStorage.instance;
//     final isar = localStorage.isar;

//     // ✅ Récupérer UNIQUEMENT les 10 derniers prospects
//     final prospects = await isar.prospects
//         .where()
//         .sortByCreatedAtDesc()
//         .limit(10)
//         .findAll();

//     if (prospects.isEmpty) return [];

//     // ✅ Batch load all relations
//     final prospectIds = prospects.map((p) => p.idProspect).toList();

//     final allInterets = await isar.interetFilieres
//         .where()
//         .filter()
//         .anyOf(prospectIds, (q, id) => q.idProspectEqualTo(id))
//         .findAll();

//     final specialiteIds = allInterets.map((i) => i.idSpecialite).toList();
//     final allSpecialites = specialiteIds.isNotEmpty
//         ? await isar.specialites
//             .where()
//             .anyOf(specialiteIds, (q, id) => q.idSpecialiteEqualTo(id))
//             .findAll()
//         : [];

//     final specialiteMap = {for (var s in allSpecialites) s.idSpecialite: s};

//     final classeIds = prospects.map((p) => p.idClass).toList();
//     final allClasses = await isar.classes
//         .where()
//         .anyOf(classeIds, (q, id) => q.idClasseEqualTo(id))
//         .findAll();

//     final classeMap = {for (var c in allClasses) c.idClasse: c};

//     final etsIds = allClasses.map((c) => c.idEts).toList();
//     final allEts = await isar.etablissements
//         .where()
//         .anyOf(etsIds, (q, id) => q.idEtablissementEqualTo(id))
//         .findAll();

//     final etsMap = {for (var e in allEts) e.idEtablissement: e};

//     // ✅ Build details
//     final detailsList = <ProspectDetails>[];
//     for (final prospect in prospects) {
//       final interets = allInterets
//           .where((i) => i.idProspect == prospect.idProspect)
//           .toList();
//       final specialities = interets
//           .map((i) {
//             final spec = specialiteMap[i.idSpecialite];
//             return spec != null
//                 ? SpecialityDetail(
//                     libelleSpecialite: spec.libelleSpecialite,
//                     orderPreference: i.ordrePreference,
//                     niveau: i.niveauInteret,
//                     commentaire: i.commentaire ?? '',
//                   )
//                 : null;
//           })
//           .whereType<SpecialityDetail>()
//           .toList()
//         ..sort((a, b) => a.orderPreference.compareTo(b.orderPreference));

//       final classe = classeMap[prospect.idClass];
//       final ets = classe != null ? etsMap[classe.idEts] : null;

//       detailsList.add(ProspectDetails(
//         prosp: prospect,
//         etablissement: ets ??
//             Etablissement(
//               idEtablissement: '',
//               nomEtablissement: 'Non spécifié',
//               typeEtablissement: '',
//               createdAt: DateTime.now(),
//               syncState: SyncState.pending,
//             ),
//         classe: classe ??
//             Classe(
//               idClasse: '',
//               idEts: '',
//               libelleClasse: 'Non spécifié',
//               createdAt: DateTime.now(),
//               syncState: SyncState.pending,
//             ),
//         specialities: specialities,
//       ));
//     }

//     return detailsList;
//   }

//   Future<void> _refreshData() async {
//     await _loadLastProspects();
//   }

//   // ✅ Nom affiché dans l'en-tête : celui de l'agent connecté (persisté via
//   // AuthProvider/SharedPreferences), avec un fallback propre.
//   String _getDisplayName(User? currentUser) {
//     if (currentUser == null) return 'Agent';

//     // Try full name first
//     final fullName = currentUser.fullName.trim();
//     if (fullName.isNotEmpty && fullName != 'Utilisateur') {
//       return fullName;
//     }

//     // Try prenom (first name)
//     if (currentUser.prenom.isNotEmpty) {
//       return currentUser.prenom;
//     }

//     // Try nom (last name)
//     if (currentUser.nom.isNotEmpty) {
//       return currentUser.nom;
//     }

//     return 'Agent';
//   }

//   // ✅ Obtenir le nom d'affichage du rôle
//   String _getRoleDisplayName(String role) {
//     switch (role.toLowerCase()) {
//       case 'admin':
//         return 'Administrateur';
//       case 'agent':
//         return 'Agent de Pospection';
//       case 'user':
//         return 'Utilisateur';
//       default:
//         return role;
//     }
//   }

//   // ✅ Get user initials safely
//   String _getUserInitials(AuthProvider authProvider) {
//     if (!authProvider.isAuthenticated) return 'A';
//     final initials = authProvider.initials;
//     return initials.isNotEmpty ? initials : 'A';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth < 600;

//     // ✅ Vérifier si la langue a changé
//     final Locale newLocale = TranslationService.currentLocale;
//     if (_currentLocale.languageCode != newLocale.languageCode) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           setState(() {
//             _currentLocale = newLocale;
//           });
//         }
//       });
//     }

//     return Scaffold(
//       backgroundColor: AppColors.backgroundGrey,
//       body: _buildNeumorphicBackground(
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: const SyncProgress(),
//             ),
//             const SizedBox(height: 4),
//             _buildNeumorphicHeader(isSmallScreen),
//             Expanded(child: _buildBody(isSmallScreen)),
//           ],
//         ),
//       ),
//       floatingActionButton: _buildNeumorphicFab(isSmallScreen),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//     );
//   }

//   Widget _buildNeumorphicBackground({required Widget child}) {
//     return Container(
//       color: AppColors.backgroundGrey,
//       child: child,
//     );
//   }

//   // ✅ HEADER AVEC BADGE DE NOTIFICATION DYNAMIQUE
//   Widget _buildNeumorphicHeader(bool isSmallScreen) {
//     final double headerMargin = isSmallScreen ? 12.0 : 16.0;
//     final double headerPadding = isSmallScreen ? 16.0 : 20.0;
//     final double avatarSize = isSmallScreen ? 44.0 : 52.0;
//     final double fontSizeTitle = isSmallScreen ? 22.0 : 26.0;
//     final double fontSizeSubtitle = isSmallScreen ? 13.0 : 15.0;

//     // ✅ Récupérer les données de l'utilisateur depuis AuthProvider
//     final authProvider = context.watch<AuthProvider>();
//     final currentUser = authProvider.currentUser;

//     // ✅ Afficher le nom de l'utilisateur
//     final displayName = _getDisplayName(currentUser);
//     final userInitials = _getUserInitials(authProvider);
//     final userRole = currentUser?.role ?? 'Agent';
//     final isAgent = authProvider.isAgent;
//     final agentMatricule = authProvider.agentMatricule;
//     final isAuthenticated = authProvider.isAuthenticated;

//     return Container(
//       margin: EdgeInsets.all(headerMargin),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(28),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.white.withOpacity(0.7),
//             blurRadius: 15,
//             offset: const Offset(-5, -5),
//           ),
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 15,
//             offset: const Offset(6, 6),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(28),
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 AppColors.primaryGreen,
//                 AppColors.secondaryGreen,
//               ],
//             ),
//           ),
//           child: SafeArea(
//             bottom: false,
//             child: Padding(
//               padding: EdgeInsets.all(headerPadding),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // ✅ Bonjour + nom
//                             Text(
//                               'good_morning'.tr,
//                               style: TextStyle(
//                                 fontSize: fontSizeSubtitle,
//                                 color: AppColors.textWhite70,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               '$displayName.',
//                               style: TextStyle(
//                                 fontSize: fontSizeTitle,
//                                 fontWeight: FontWeight.w800,
//                                 color: AppColors.textOnPrimary,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             // ✅ Rôle et matricule de l'agent
//                             if (isAuthenticated) ...[
//                               const SizedBox(height: 2),
//                               Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 8,
//                                       vertical: 2,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white.withOpacity(0.2),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Text(
//                                       _getRoleDisplayName(userRole),
//                                       style: TextStyle(
//                                         fontSize: 10,
//                                         color: Colors.white.withOpacity(0.9),
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                   if (isAgent && agentMatricule.isNotEmpty) ...[
//                                     const SizedBox(width: 6),
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 8,
//                                         vertical: 2,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white.withOpacity(0.15),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: Text(
//                                         'Matricule: $agentMatricule',
//                                         style: TextStyle(
//                                           fontSize: 9,
//                                           color: Colors.white.withOpacity(0.8),
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ],
//                               ),
//                             ],
//                           ],
//                         ),
//                       ),
//                       // ✅ Avatar avec les initiales
//                       Container(
//                         width: avatarSize,
//                         height: avatarSize,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           gradient: LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [
//                               Colors.white.withOpacity(0.25),
//                               Colors.white.withOpacity(0.1),
//                             ],
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             userInitials,
//                             style: TextStyle(
//                               color: AppColors.textOnPrimary,
//                               fontSize: avatarSize * 0.45,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       // ✅ Icône de notification avec badge
//                       // GestureDetector(
//                       //   onTap: () {
//                       //     Navigator.pushNamed(context, AppRoutes.relances)
//                       //         .then((_) => _loadNotificationCount());
//                       //   },
//                       //   child: Stack(
//                       //     clipBehavior: Clip.none,
//                       //     children: [
//                       //       Container(
//                       //         width: avatarSize,
//                       //         height: avatarSize,
//                       //         decoration: BoxDecoration(
//                       //           borderRadius: BorderRadius.circular(14),
//                       //           gradient: LinearGradient(
//                       //             begin: Alignment.topLeft,
//                       //             end: Alignment.bottomRight,
//                       //             colors: [
//                       //               Colors.white.withOpacity(0.25),
//                       //               Colors.white.withOpacity(0.1),
//                       //             ],
//                       //           ),
//                       //         ),
//                       //         child: Icon(
//                       //           Icons.notifications_none_outlined,
//                       //           color: AppColors.textOnPrimary,
//                       //           size: avatarSize * 0.5,
//                       //         ),
//                       //       ),
//                       //       if (_notificationCount > 0)
//                       //         Positioned(
//                       //           top: -4,
//                       //           right: -4,
//                       //           child: Container(
//                       //             padding: const EdgeInsets.all(4),
//                       //             decoration: const BoxDecoration(
//                       //               color: AppColors.badgeOrange,
//                       //               shape: BoxShape.circle,
//                       //             ),
//                       //             constraints: const BoxConstraints(
//                       //               minWidth: 20,
//                       //               minHeight: 20,
//                       //             ),
//                       //             child: Center(
//                       //               child: Text(
//                       //                 _notificationCount > 99
//                       //                     ? '99+'
//                       //                     : '$_notificationCount',
//                       //                 style: const TextStyle(
//                       //                   color: AppColors.textOnPrimary,
//                       //                   fontSize: 10,
//                       //                   fontWeight: FontWeight.w800,
//                       //                 ),
//                       //               ),
//                       //             ),
//                       //           ),
//                       //         ),
//                       //     ],
//                       //   ),
//                       // ),

//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   // ✅ Barre de recherche
//                   GestureDetector(
//                     onTap: () {
//                       _loadingService.show(context, message: 'loading'.tr);
//                       Future.delayed(const Duration(milliseconds: 300), () {
//                         _loadingService.hide();
//                         Navigator.pushNamed(context, AppRoutes.prospectsList,
//                             arguments: {'prospectsList': _cachedProspectsFull});
//                       });
//                     },
//                     child: Container(
//                       height: isSmallScreen ? 48 : 54,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(27),
//                         color: AppColors.backgroundGrey,
//                       ),
//                       child: Row(
//                         children: [
//                           const SizedBox(width: 16),
//                           Icon(
//                             Icons.search,
//                             color: AppColors.textTertiary,
//                             size: isSmallScreen ? 20 : 22,
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Text(
//                               'search_hint'.tr,
//                               style: TextStyle(
//                                 color: AppColors.textSecondary,
//                                 fontSize: isSmallScreen ? 13 : 14,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             width: isSmallScreen ? 36 : 40,
//                             height: isSmallScreen ? 36 : 40,
//                             margin: const EdgeInsets.only(right: 8),
//                             child: Icon(
//                               Icons.tune_outlined,
//                               color: AppColors.primaryGreen,
//                               size: isSmallScreen ? 18 : 20,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBody(bool isSmallScreen) {
//     final double bodyPadding = isSmallScreen ? 12.0 : 16.0;

//     return RefreshIndicator(
//       onRefresh: _refreshData,
//       color: AppColors.primaryGreen,
//       child: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: bodyPadding, vertical: 12),
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'today_overview'.tr,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildNeumorphicStatsGrid(),
//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     'recent_prospections'.tr,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     _loadingService.show(context, message: 'loading'.tr);
//                     Future.delayed(const Duration(milliseconds: 500), () {
//                       _loadingService.hide();
//                       Navigator.pushNamed(context, AppRoutes.prospectsList,
//                           arguments: {'prospectsList': _cachedProspectsFull});
//                     });
//                   },
//                   child: Text(
//                     'view_all'.tr,
//                     style: const TextStyle(
//                       fontSize: 13,
//                       color: AppColors.primaryGreen,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // ✅ Affichage des 10 derniers prospects
//             _isLoading
//                 ? const Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(32),
//                       child: CircularProgressIndicator(
//                         valueColor:
//                             AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
//                       ),
//                     ),
//                   )
//                 : _cachedProspects.isEmpty
//                     ? Column(
//                         children: [
//                           const SizedBox(height: 40),
//                           const Icon(
//                             Icons.person_off_outlined,
//                             size: 62,
//                             color: Colors.redAccent,
//                           ),
//                           const SizedBox(height: 8),
//                           Center(
//                             child: Text(
//                               'no_prospects_found'.tr,
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                           ),
//                         ],
//                       )
//                     : Column(
//                         children: [
//                           ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: _cachedProspects.length,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemBuilder: (_, index) {
//                               final prospectDetail = _cachedProspects[index];
//                               return _buildNeumorphicProspectCard(
//                                   prospectDetail, isSmallScreen);
//                             },
//                           ),
//                         ],
//                       ),
//             const SizedBox(height: 100),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNeumorphicStatsGrid() {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth < 600;
//     final double cardPadding = isSmallScreen ? 12.0 : 14.0;
//     final double iconSize = isSmallScreen ? 20 : 22;
//     final double valueFontSize = isSmallScreen ? 20 : 22;

//     return StreamBuilder<Map<String, dynamic>>(
//       stream: LocalStorage.instance.watchStatsOptimized(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return GridView.count(
//             crossAxisCount: 2,
//             mainAxisSpacing: 12,
//             crossAxisSpacing: 12,
//             childAspectRatio: 1.6,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             children: List.generate(4, (_) => _buildShimmerCard()),
//           );
//         }

//         final stats = snapshot.data!;

//         final statsData = [
//           {
//             'icon': Icons.people_outline,
//             'value': stats['totalFormatted'] ?? '0',
//             'label': 'prospects_added'.tr,
//             'color': AppColors.statGreen
//           },
//           {
//             'icon': Icons.access_time_outlined,
//             'value': stats['aRelancerFormatted'] ?? '0',
//             'label': 'to_relaunch'.tr,
//             'color': AppColors.statOrange
//           },
//           {
//             'icon': Icons.file_copy_sharp,
//             'value': stats['fichesFormatted'] ?? '0',
//             'label': 'all_fiches'.tr,
//             'color': AppColors.statBlue
//           },
//           {
//             'icon': Icons.person_add_outlined,
//             'value': stats['nouveauxFormatted'] ?? '0',
//             'label': 'new_established'.tr,
//             'color': AppColors.statYellow
//           },
//         ];

//         return GridView.count(
//           crossAxisCount: 2,
//           mainAxisSpacing: 12,
//           crossAxisSpacing: 12,
//           childAspectRatio: 1.6,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           children: statsData.map((s) {
//             return Container(
//               padding: EdgeInsets.all(cardPadding),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 color: AppColors.backgroundGrey,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.white.withOpacity(0.6),
//                     blurRadius: 6,
//                     offset: const Offset(-3, -3),
//                   ),
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.06),
//                     blurRadius: 8,
//                     offset: const Offset(4, 4),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: iconSize + 14,
//                     height: iconSize + 14,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.white.withOpacity(0.5),
//                           blurRadius: 4,
//                           offset: const Offset(-2, -2),
//                         ),
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.08),
//                           blurRadius: 4,
//                           offset: const Offset(2, 2),
//                         ),
//                       ],
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           Colors.white.withOpacity(0.4),
//                           Colors.white.withOpacity(0.15),
//                         ],
//                       ),
//                     ),
//                     child: Icon(s['icon'] as IconData,
//                         color: s['color'] as Color, size: iconSize),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           s['value'] as String,
//                           style: TextStyle(
//                             fontSize: valueFontSize,
//                             fontWeight: FontWeight.w800,
//                             color: AppColors.textPrimary,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           s['label'] as String,
//                           style: const TextStyle(
//                             fontSize: 11,
//                             color: AppColors.textSecondary,
//                           ),
//                           maxLines: 2,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }

//   Widget _buildShimmerCard() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: Colors.grey.shade200,
//       ),
//     );
//   }

//   Widget _buildNeumorphicProspectCard(
//       ProspectDetails prospectDetail, bool isSmallScreen) {
//     final double cardPadding = isSmallScreen ? 12.0 : 14.0;
//     final double avatarSize = isSmallScreen ? 46 : 52;
//     final double fontSize = isSmallScreen ? 14 : 15;

//     final hasSpecialities = prospectDetail.specialities.isNotEmpty;
//     final firstSpeciality = hasSpecialities
//         ? prospectDetail.specialities[0].libelleSpecialite.tr
//         : 'no_specialty'.tr;
//     final hasMultipleSpecialities = prospectDetail.specialities.length > 1;

//     final interestText = hasMultipleSpecialities
//         ? 'interested_in_etc'.tr.replaceFirst('{spec}', firstSpeciality)
//         : 'interested_in'.tr.replaceFirst('{spec}', firstSpeciality);

//     final firstLetter = prospectDetail.prosp.nomComplet.isNotEmpty
//         ? prospectDetail.prosp.nomComplet[0]
//         : '?';

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           color: AppColors.backgroundGrey,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.white.withOpacity(0.7),
//               blurRadius: 8,
//               offset: const Offset(-3, -3),
//             ),
//             BoxShadow(
//               color: Colors.black.withOpacity(0.06),
//               blurRadius: 8,
//               offset: const Offset(5, 5),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(16),
//             onTap: () {
//               _loadingService.show(context, message: 'loading'.tr);
//               Future.delayed(const Duration(milliseconds: 200), () {
//                 _loadingService.hide();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) =>
//                         ProspectDetailScreen(prospect: prospectDetail),
//                   ),
//                 ).then((_) {
//                   _loadNotificationCount();
//                 });
//               });
//             },
//             child: Padding(
//               padding: EdgeInsets.all(cardPadding),
//               child: Row(
//                 children: [
//                   Container(
//                     width: avatarSize,
//                     height: avatarSize,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(24),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.white.withOpacity(0.5),
//                           blurRadius: 5,
//                           offset: const Offset(-2, -2),
//                         ),
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 5,
//                           offset: const Offset(3, 3),
//                         ),
//                       ],
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           Color(prospectDetail.color).withOpacity(0.85),
//                           Color(prospectDetail.color).withOpacity(0.55),
//                         ],
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         firstLetter.toUpperCase(),
//                         style: TextStyle(
//                           color: AppColors.textOnPrimary,
//                           fontWeight: FontWeight.w800,
//                           fontSize: fontSize - 2,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           prospectDetail.prosp.nomComplet,
//                           style: TextStyle(
//                             fontSize: fontSize,
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.textPrimary,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           prospectDetail.etablissement.nomEtablissement,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: AppColors.textSecondary,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           interestText,
//                           style: const TextStyle(
//                             fontSize: 11,
//                             color: AppColors.textTertiary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   _buildNeumorphicBadge(
//                       prospectDetail.prosp.prospectStatus.name),
//                   const SizedBox(width: 6),
//                   const Icon(Icons.chevron_right,
//                       color: AppColors.textTertiary, size: 18),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNeumorphicBadge(String status) {
//     Color badgeColor;
//     String label;

//     switch (status.toLowerCase()) {
//       case 'relancer':
//         badgeColor = AppColors.statusPending;
//         label = 'to_relaunch_badge'.tr;
//         break;
//       case 'nouveau':
//         badgeColor = AppColors.statusNew;
//         label = 'new_badge'.tr;
//         break;
//       case 'contacte':
//         badgeColor = AppColors.statusContacted;
//         label = 'contacted_badge'.tr;
//         break;
//       default:
//         badgeColor = Colors.grey;
//         label = status;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14),
//         color: badgeColor.withOpacity(0.1),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.white.withOpacity(0.4),
//             blurRadius: 3,
//             offset: const Offset(-1, -1),
//           ),
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 3,
//             offset: const Offset(2, 2),
//           ),
//         ],
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.w600,
//           color: badgeColor,
//         ),
//       ),
//     );
//   }

//   Widget _buildNeumorphicFab(bool isSmallScreen) {
//     final double fabSize = isSmallScreen ? 54 : 58;
//     final double iconSize = isSmallScreen ? 26 : 30;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: GestureDetector(
//         onTap: () {
//           _loadingService.show(context, message: 'loading'.tr);
//           Future.delayed(const Duration(milliseconds: 300), () {
//             _loadingService.hide();
//             Navigator.pushNamed(context, AppRoutes.addProspect)
//                 .then((_) {
//               _loadLastProspects();
//               _loadNotificationCount();
//             });
//           });
//         },
//         child: Container(
//           width: fabSize,
//           height: fabSize,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: AppColors.primaryGreen,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.white.withOpacity(0.6),
//                 blurRadius: 8,
//                 offset: const Offset(-3, -3),
//               ),
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.15),
//                 blurRadius: 10,
//                 offset: const Offset(5, 5),
//               ),
//               BoxShadow(
//                 color: AppColors.primaryGreen.withOpacity(0.4),
//                 blurRadius: 8,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//             gradient: const LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 AppColors.primaryGreen,
//                 AppColors.secondaryGreen,
//               ],
//             ),
//           ),
//           child:
//               Icon(Icons.add, color: AppColors.textOnPrimary, size: iconSize),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';
import 'package:isetagcom/models/stats.dart';
import 'package:provider/provider.dart';
import '../models/classe.dart';
import '../models/etablissement.dart';
import '../models/interet_filiere.dart';
import '../models/localStorage/local_storage.dart';
import '../models/pros.dart';
import '../models/specialite.dart';
import '../models/user.dart';
import '../provider/auth_provider.dart';
import '../services/translation_service.dart';
import '../utils/status.dart';
import '../utils/themes/app_colors.dart';
import '../widgets/sync_progress.dart';
import 'prospect_detail_screen.dart';
import '../models/prospectData.dart';
import '../routes/app_router.dart';
import '../services/loading_service.dart';
import '../services/notification_counter_service.dart';

// ignore_for_file: use_build_context_synchronously, deprecated_member_use
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // ✅ Uniquement les 10 derniers prospects
  List<ProspectDetails> _cachedProspects = [];
  List<ProspectDetails> _cachedProspectsFull = [];
  bool _isLoading = true;

  // ✅ Nombre de notifications (relances programmées)
  int _notificationCount = 0;
  Timer? _notificationTimer;

  // Service de chargement
  final LoadingService _loadingService = LoadingService();
  final NotificationCounterService _notificationService =
      NotificationCounterService();

  // ✅ Current locale
  Locale _currentLocale = const Locale('fr');

  // ✅ Flag to track if the widget is mounted
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    WidgetsBinding.instance.addObserver(this);
    _currentLocale = TranslationService.currentLocale;
    _loadLastProspects();
    _loadNotificationCount();
    _startNotificationTimer();

    // ✅ Recharge la session persistée (nom/agent connecté) depuis le
    // SharedPreferences local si ce n'est pas déjà fait.
    context.read<AuthProvider>().init();
  }

  @override
  void dispose() {
    _isMounted = false;
    WidgetsBinding.instance.removeObserver(this);
    _notificationTimer?.cancel();
    super.dispose();
  }

  // ✅ Rafraîchir le compteur quand l'app revient au premier plan
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadNotificationCount();
    }
  }

  // ✅ Charger le nombre de notifications depuis SharedPreferences
  Future<void> _loadNotificationCount() async {
    // ✅ Check mounted before setState
    if (!_isMounted || !mounted) return;

    final count = await _notificationService.getNotificationCount();
    if (_isMounted && mounted) {
      setState(() {
        _notificationCount = count;
      });
    }
  }

  // ✅ Mettre à jour périodiquement le compteur de notifications
  void _startNotificationTimer() {
    _notificationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _loadNotificationCount();
    });
  }

  Future<void> _loadLastProspects() async {
    if (!mounted) return; // ✅ guard before starting

    setState(() {
      _isLoading = true;
      _cachedProspects = [];
      _cachedProspectsFull = [];
    });

    try {
      final prospects = await _getLast10Prospects();

      if (!mounted) return; // ✅ guard after the await

      setState(() {
        _cachedProspects = prospects;
        _cachedProspectsFull = prospects;
        _isLoading = false;
        Stats["all_prosp"] = prospects.length;
      });

      await _loadNotificationCount();
    } catch (e) {
      print('Error loading prospects: $e');
      if (mounted) {
        // ✅ guard in catch block
        setState(() => _isLoading = false);
      }
    }
  }

  // ✅ Récupérer les 10 derniers prospects enregistrés
  Future<List<ProspectDetails>> _getLast10Prospects() async {
    final localStorage = LocalStorage.instance;
    final isar = localStorage.isar;

    // ✅ Récupérer UNIQUEMENT les 10 derniers prospects
    final prospects =
        await isar.prospects.where().sortByCreatedAtDesc().limit(10).findAll();

    if (prospects.isEmpty) return [];

    // ✅ Batch load all relations
    final prospectIds = prospects.map((p) => p.idProspect).toList();

    final allInterets = await isar.interetFilieres
        .where()
        .filter()
        .anyOf(prospectIds, (q, id) => q.idProspectEqualTo(id))
        .findAll();

    final specialiteIds = allInterets.map((i) => i.idSpecialite).toList();
    final allSpecialites = specialiteIds.isNotEmpty
        ? await isar.specialites
            .where()
            .anyOf(specialiteIds, (q, id) => q.idSpecialiteEqualTo(id))
            .findAll()
        : [];

    final specialiteMap = {for (var s in allSpecialites) s.idSpecialite: s};

    final classeIds = prospects.map((p) => p.idClass).toList();
    final allClasses = await isar.classes
        .where()
        .anyOf(classeIds, (q, id) => q.idClasseEqualTo(id))
        .findAll();

    final classeMap = {for (var c in allClasses) c.idClasse: c};

    final etsIds = allClasses.map((c) => c.idEts).toList();
    final allEts = await isar.etablissements
        .where()
        .anyOf(etsIds, (q, id) => q.idEtablissementEqualTo(id))
        .findAll();

    final etsMap = {for (var e in allEts) e.idEtablissement: e};

    // ✅ Build details
    final detailsList = <ProspectDetails>[];
    for (final prospect in prospects) {
      final interets = allInterets
          .where((i) => i.idProspect == prospect.idProspect)
          .toList();
      final specialities = interets
          .map((i) {
            final spec = specialiteMap[i.idSpecialite];
            return spec != null
                ? SpecialityDetail(
                    libelleSpecialite: spec.libelleSpecialite,
                    orderPreference: i.ordrePreference,
                    niveau: i.niveauInteret,
                    commentaire: i.commentaire ?? '',
                  )
                : null;
          })
          .whereType<SpecialityDetail>()
          .toList()
        ..sort((a, b) => a.orderPreference.compareTo(b.orderPreference));

      final classe = classeMap[prospect.idClass];
      final ets = classe != null ? etsMap[classe.idEts] : null;

      detailsList.add(ProspectDetails(
        prosp: prospect,
        etablissement: ets ??
            Etablissement(
              idEtablissement: '',
              nomEtablissement: 'Non spécifié',
              typeEtablissement: '',
              createdAt: DateTime.now(),
              syncState: SyncState.pending,
            ),
        classe: classe ??
            Classe(
              idClasse: '',
              idEts: '',
              libelleClasse: 'Non spécifié',
              createdAt: DateTime.now(),
              syncState: SyncState.pending,
            ),
        specialities: specialities,
      ));
    }

    return detailsList;
  }

  Future<void> _refreshData() async {
    await _loadLastProspects();
  }

  // ✅ Nom affiché dans l'en-tête : celui de l'agent connecté (persisté via
  // AuthProvider/SharedPreferences), avec un fallback propre.
  String _getDisplayName(User? currentUser) {
    if (currentUser == null) return 'Agent';

    // Try full name first
    final fullName = currentUser.fullName.trim();
    if (fullName.isNotEmpty && fullName != 'Utilisateur') {
      return fullName;
    }

    // Try prenom (first name)
    if (currentUser.prenom.isNotEmpty) {
      return currentUser.prenom;
    }

    // Try nom (last name)
    if (currentUser.nom.isNotEmpty) {
      return currentUser.nom;
    }

    return 'Agent';
  }

  // ✅ Obtenir le nom d'affichage du rôle
  String _getRoleDisplayName(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Administrateur';
      case 'agent':
        return 'Agent de Prospection';
      case 'user':
        return 'Utilisateur';
      default:
        return role;
    }
  }

  // ✅ Get user initials safely
  String _getUserInitials(AuthProvider authProvider) {
    if (!authProvider.isAuthenticated) return 'A';
    final initials = authProvider.initials;
    return initials.isNotEmpty ? initials : 'A';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    // ✅ Vérifier si la langue a changé
    final Locale newLocale = TranslationService.currentLocale;
    if (_currentLocale.languageCode != newLocale.languageCode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isMounted && mounted) {
          setState(() {
            _currentLocale = newLocale;
          });
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: _buildNeumorphicBackground(
        child: Column(
          children: [
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

  // ✅ HEADER AVEC BADGE DE NOTIFICATION DYNAMIQUE
  Widget _buildNeumorphicHeader(bool isSmallScreen) {
    final double headerMargin = isSmallScreen ? 12.0 : 16.0;
    final double headerPadding = isSmallScreen ? 16.0 : 20.0;
    final double avatarSize = isSmallScreen ? 44.0 : 52.0;
    final double fontSizeTitle = isSmallScreen ? 22.0 : 26.0;
    final double fontSizeSubtitle = isSmallScreen ? 13.0 : 15.0;

    // ✅ Récupérer les données de l'utilisateur depuis AuthProvider
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;

    // ✅ Afficher le nom de l'utilisateur
    final displayName = _getDisplayName(currentUser);
    final userInitials = _getUserInitials(authProvider);
    final userRole = currentUser?.role ?? 'Agent';
    final isAgent = authProvider.isAgent;
    final agentMatricule = authProvider.agentMatricule;
    final isAuthenticated = authProvider.isAuthenticated;

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
                            // ✅ Bonjour + nom
                            Text(
                              'good_morning'.tr,
                              style: TextStyle(
                                fontSize: fontSizeSubtitle,
                                color: AppColors.textWhite70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$displayName.',
                              style: TextStyle(
                                fontSize: fontSizeTitle,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textOnPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            // ✅ Rôle et matricule de l'agent
                            if (isAuthenticated) ...[
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _getRoleDisplayName(userRole),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  if (isAgent && agentMatricule.isNotEmpty) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        'Matricule: $agentMatricule',
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.white.withOpacity(0.8),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      // ✅ Avatar avec les initiales
                      Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            userInitials,
                            style: TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: avatarSize * 0.45,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // ✅ Barre de recherche
                  GestureDetector(
                    onTap: () {
                      _loadingService.show(context, message: 'loading'.tr);
                      Future.delayed(const Duration(milliseconds: 300), () {
                        _loadingService.hide();
                        Navigator.pushNamed(context, AppRoutes.prospectsList,
                            arguments: {'prospectsList': _cachedProspectsFull});
                      });
                    },
                    child: Container(
                      height: isSmallScreen ? 48 : 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        color: AppColors.backgroundGrey,
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
                            child: Text(
                              'search_hint'.tr,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: isSmallScreen ? 13 : 14,
                              ),
                            ),
                          ),
                          Container(
                            width: isSmallScreen ? 36 : 40,
                            height: isSmallScreen ? 36 : 40,
                            margin: const EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.tune_outlined,
                              color: AppColors.primaryGreen,
                              size: isSmallScreen ? 18 : 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
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

            // ✅ Affichage des 10 derniers prospects
            _isLoading
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
                    : Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _cachedProspects.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) {
                              final prospectDetail = _cachedProspects[index];
                              return _buildNeumorphicProspectCard(
                                  prospectDetail, isSmallScreen);
                            },
                          ),
                        ],
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
            'value': stats['fichesFormatted'] ?? '0',
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
        ? prospectDetail.specialities[0].libelleSpecialite.tr
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
              _loadingService.show(context, message: 'loading'.tr);
              Future.delayed(const Duration(milliseconds: 200), () {
                _loadingService.hide();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProspectDetailScreen(prospect: prospectDetail),
                  ),
                ).then((_) {
                  if (_isMounted && mounted) {
                    _loadNotificationCount();
                  }
                });
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
                          prospectDetail.etablissement.nomEtablissement,
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
          _loadingService.show(context, message: 'loading'.tr);
          Future.delayed(const Duration(milliseconds: 300), () {
            _loadingService.hide();
            Navigator.pushNamed(context, AppRoutes.addProspect).then((_) {
              // ✅ Vérifier si le widget est toujours monté avant de rafraîchir
              if (_isMounted && mounted) {
                _loadLastProspects();
                _loadNotificationCount();
              }
            });
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
