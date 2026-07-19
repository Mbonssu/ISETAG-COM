// // lib/screens/fiche_list_screen.dart
// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:isetagcom/models/fiche.dart';
// import 'package:isetagcom/models/localStorage/local_storage.dart';
// import 'package:isetagcom/routes/app_router.dart';
// import '../services/translation_service.dart';
// import '../utils/themes/app_colors.dart';

// class FicheListScreen extends StatefulWidget {
//   const FicheListScreen({super.key});

//   @override
//   State<FicheListScreen> createState() => _FicheListScreenState();
// }

// class _FicheListScreenState extends State<FicheListScreen> {
//   String _selectedFilter = 'all';
//   List<Fiche> _allFiches = [];

//   final Map<String, String> _filterOptions = {
//     'all': 'all'.tr,
//     'today': 'today'.tr,
//     'week': 'this_week'.tr,
//     'month': 'this_month'.tr,
//     'year': 'this_year'.tr,
//   };

//   List<Fiche> _getFilteredFiches(List<Fiche> fiches) {
//     final now = DateTime.now();

//     switch (_selectedFilter) {
//       case 'today':
//         final startOfDay = DateTime(now.year, now.month, now.day);
//         return fiches.where((f) => f.dateCollecte.isAfter(startOfDay)).toList();
//       case 'week':
//         final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
//         return fiches
//             .where((f) => f.dateCollecte.isAfter(startOfWeek))
//             .toList();
//       case 'month':
//         return fiches
//             .where((f) =>
//                 f.dateCollecte.year == now.year &&
//                 f.dateCollecte.month == now.month)
//             .toList();
//       case 'year':
//         return fiches.where((f) => f.dateCollecte.year == now.year).toList();
//       default:
//         return fiches;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth < 600;

//     return Scaffold(
//       backgroundColor: AppColors.backgroundGrey,
//       body: Column(
//         children: [
//           _buildHeader(context),
//           _buildFilterBar(isSmallScreen),
//           Expanded(
//             child: StreamBuilder<List<Fiche>>(
//               stream: LocalStorage.instance.watchAllFiches(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError) {
//                   return Center(child: Text('error_occurred'.tr));
//                 }

//                 _allFiches = snapshot.data ?? [];
//                 final filteredFiches = _getFilteredFiches(_allFiches);
//                 final totalProspects = filteredFiches.fold(0, (sum, f) => sum + f.prospects.length);

//                 if (filteredFiches.isEmpty) {
//                   return _buildEmptyState();
//                 }

//                 return _buildFicheList(
//                     filteredFiches, totalProspects, isSmallScreen, context);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext ctx) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
//       decoration: const BoxDecoration(
//         color: AppColors.primaryGreen,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(24),
//           bottomRight: Radius.circular(24),
//         ),
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Row(
//           children: [
//             GestureDetector(
//               onTap: () =>  Navigator.pushNamed(context, AppRoutes.main),
//               child:
//                   const Icon(Icons.arrow_back, color: Colors.white, size: 24),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 'my_records'.tr,
//                 style: const TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterBar(bool isSmallScreen) {
//     final filterText = _filterOptions[_selectedFilter] ?? 'all'.tr;

//     return Container(
//       margin: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Expanded(
//             child: GestureDetector(
//               onTap: () => _showFilterDialog(),
//               child: Container(
//                 height: 45,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: AppColors.lightShadow,
//                 ),
//                 child: Row(
//                   children: [
//                     const SizedBox(width: 12),
//                     const Icon(Icons.filter_list,
//                         color: AppColors.primaryGreen, size: 20),
//                     const SizedBox(width: 8),
//                     Flexible(
//                       child: Text(
//                         'filter_by'.tr.replaceFirst('{filter}', filterText),
//                         style: const TextStyle(
//                             fontSize: 14, color: AppColors.textPrimary),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showFilterDialog() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'filter_records'.tr,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               ..._filterOptions.entries.map((entry) {
//                 return ListTile(
//                   title: Text(entry.value),
//                   leading: Radio<String>(
//                     value: entry.key,
//                     groupValue: _selectedFilter,
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedFilter = value!;
//                       });
//                       Navigator.pop(context);
//                     },
//                     activeColor: AppColors.primaryGreen,
//                   ),
//                 );
//               }),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFicheList(List<Fiche> fiches, int totalProspects,
//       bool isSmallScreen, BuildContext context) {
//     return Column(
//       children: [
//         _buildStatsHeader(fiches.length, totalProspects, isSmallScreen),
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: fiches.length,
//             itemBuilder: (ctx, index) =>
//                 _buildFicheCard(fiches[index], isSmallScreen, ctx),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatsHeader(
//       int fichesCount, int prospectsCount, bool isSmallScreen) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           _buildStatCard(
//             icon: Icons.folder_outlined,
//             label: 'records'.tr,
//             value: fichesCount.toString(),
//             isSmallScreen: isSmallScreen,
//           ),
//           const SizedBox(width: 12),
//           _buildStatCard(
//             icon: Icons.people_outline,
//             label: 'prospects'.tr,
//             value: prospectsCount.toString(),
//             isSmallScreen: isSmallScreen,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard({
//     required IconData icon,
//     required String label,
//     required String value,
//     required bool isSmallScreen,
//   }) {
//     final double fontSize = isSmallScreen ? 18 : 20;
//     final double iconSize = isSmallScreen ? 20 : 24;
//     final double padding = isSmallScreen ? 8 : 12;

//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: padding),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: AppColors.lightShadow,
//         ),
//         child: Column(
//           children: [
//             Icon(icon, size: iconSize, color: AppColors.primaryGreen),
//             const SizedBox(height: 4),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             Text(
//               label,
//               style:
//                   const TextStyle(fontSize: 11, color: AppColors.textSecondary),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFicheCard(
//       Fiche fiche, bool isSmallScreen, BuildContext context) {
//     final date = DateFormat('dd/MM/yyyy').format(fiche.dateCollecte);
//     final time = DateFormat('HH:mm').format(fiche.dateCollecte);

//     final double avatarSize = isSmallScreen ? 40 : 48;
//     final double iconSize = isSmallScreen ? 22 : 28;
//     final double titleSize = isSmallScreen ? 14 : 16;
//     final double timeSize = isSmallScreen ? 10 : 12;
//     final double cardPadding = isSmallScreen ? 12 : 16;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: AppColors.lightShadow,
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: () => Navigator.pushNamed(
//             context,
//             AppRoutes.ficheDetail,
//             arguments: {'ficheId': fiche.idFiche},
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(cardPadding),
//             child: Row(
//               children: [
//                 Container(
//                   width: avatarSize,
//                   height: avatarSize,
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryGreen.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(Icons.folder,
//                       color: AppColors.primaryGreen, size: iconSize),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         date,
//                         style: TextStyle(
//                           fontSize: titleSize,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Wrap(
//                         spacing: 12,
//                         runSpacing: 4,
//                         children: [
//                           _buildInfoChip(
//                             icon: Icons.people_outline,
//                             text: '${fiche.prospects.length}',
//                             isSmallScreen: isSmallScreen,
//                           ),
//                           // _buildInfoChip(
//                           //   icon: Icons.star,
//                           //   text: '${fiche.scoreInteret}/10',
//                           //   isSmallScreen: isSmallScreen,
//                           //   color: AppColors.starYellow,
//                           // ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryGreen.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     time,
//                     style: TextStyle(
//                       fontSize: timeSize,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.primaryGreen,
//                     ),
//                   ),
//                 ),
//                 const Icon(Icons.chevron_right,
//                     color: AppColors.textTertiary, size: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoChip({
//     required IconData icon,
//     required String text,
//     required bool isSmallScreen,
//     Color? color,
//   }) {
//     final double iconSize = isSmallScreen ? 12 : 14;
//     final double fontSize = isSmallScreen ? 11 : 12;

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: iconSize, color: color ?? AppColors.textTertiary),
//         const SizedBox(width: 4),
//         Text(
//           text,
//           style: TextStyle(
//               fontSize: fontSize, color: color ?? AppColors.textTertiary),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.folder_open, size: 80, color: Colors.grey),
//           const SizedBox(height: 16),
//           Text(
//             'no_records'.tr,
//             style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textSecondary),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'create_first_record'.tr,
//             style: const TextStyle(fontSize: 14, color: AppColors.textTertiary),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }

// lib/screens/fiche_list_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';
import 'package:isetagcom/models/fiche.dart';
import 'package:isetagcom/models/localStorage/local_storage.dart';
import 'package:isetagcom/routes/app_router.dart';
import '../models/interet_filiere.dart';
import '../models/pros.dart';
import '../services/translation_service.dart';
import '../utils/themes/app_colors.dart';

class FicheListScreen extends StatefulWidget {
  const FicheListScreen({super.key});

  @override
  State<FicheListScreen> createState() => _FicheListScreenState();
}

class _FicheListScreenState extends State<FicheListScreen> {
  String _selectedFilter = 'all';
  List<Fiche> _allFiches = [];
  bool _isLoading = true;

  final Map<String, String> _filterOptions = {
    'all': 'all'.tr,
    'today': 'today'.tr,
    'week': 'this_week'.tr,
    'month': 'this_month'.tr,
    'year': 'this_year'.tr,
  };

  List<Fiche> _getFilteredFiches(List<Fiche> fiches) {
    final now = DateTime.now();

    switch (_selectedFilter) {
      case 'today':
        final startOfDay = DateTime(now.year, now.month, now.day);
        return fiches.where((f) => f.dateCollecte.isAfter(startOfDay)).toList();
      case 'week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return fiches
            .where((f) => f.dateCollecte.isAfter(startOfWeek))
            .toList();
      case 'month':
        return fiches
            .where((f) =>
                f.dateCollecte.year == now.year &&
                f.dateCollecte.month == now.month)
            .toList();
      case 'year':
        return fiches.where((f) => f.dateCollecte.year == now.year).toList();
      default:
        return fiches;
    }
  }

  // ✅ Récupérer les 10 dernières fiches OPTIMISÉ
  Future<List<Fiche>> _getLast10Fiches() async {
    final localStorage = LocalStorage.instance;
    final isar = localStorage.isar;

    // ✅ Récupérer UNIQUEMENT les 10 dernières fiches
    final fiches =
        await isar.fiches.where().sortByDateCollecteDesc().limit(10).findAll();

    if (fiches.isEmpty) return [];

    // ✅ OPTIMISATION: Charger les relations en BATCH au lieu de une par une
    final ficheIds = fiches.map((f) => f.idFiche).toList();

    // Charger tous les prospects pour toutes les fiches en une seule requête
    final allProspects = await isar.prospects
        .where()
        .filter()
        .anyOf(ficheIds, (q, id) => q.idficheEqualTo(id))
        .findAll();

    // Grouper les prospects par fiche
    final prospectsByFiche = <String, List<Prospect>>{};
    for (final prospect in allProspects) {
      prospectsByFiche.putIfAbsent(prospect.idfiche, () => []).add(prospect);
    }

    // Charger les intérêts pour tous les prospects en une seule requête
    final prospectIds = allProspects.map((p) => p.idProspect).toList();
    final allInterets = prospectIds.isNotEmpty
        ? await isar.interetFilieres
            .where()
            .filter()
            .anyOf(prospectIds, (q, id) => q.idProspectEqualTo(id))
            .findAll()
        : [];

    // Grouper les intérêts par prospect
    final interetsByProspect = <String, List<InteretFiliere>>{};
    for (final interet in allInterets) {
      interetsByProspect.putIfAbsent(interet.idProspect, () => []).add(interet);
    }

    // ✅ Attacher les relations aux fiches
    for (final fiche in fiches) {
      // Charger la source (1 seule par fiche)
      await fiche.source.load();

      // Récupérer les prospects de cette fiche
      final prospects = prospectsByFiche[fiche.idFiche] ?? [];

      // Attacher les prospects à la fiche
      for (final prospect in prospects) {
        final interets = interetsByProspect[prospect.idProspect] ?? [];
        prospect.interets.addAll(interets);
        fiche.prospects.add(prospect);
      }
    }

    return fiches;
  }

  Future<void> _loadFiches() async {
    setState(() {
      _isLoading = true;
      _allFiches = [];
    });

    try {
      final fiches = await _getLast10Fiches();
      setState(() {
        _allFiches = fiches;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading fiches: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFiches();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          _buildHeader(context),
          _buildFilterBar(isSmallScreen),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _allFiches.isEmpty
                    ? _buildEmptyState()
                    : _buildFicheListContent(isSmallScreen, context),
          ),
        ],
      ),
    );
  }

  Widget _buildFicheListContent(bool isSmallScreen, BuildContext context) {
    final filteredFiches = _getFilteredFiches(_allFiches);
    final totalProspects =
        filteredFiches.fold(0, (sum, f) => sum + f.prospects.length);

    if (filteredFiches.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildStatsHeader(filteredFiches.length, totalProspects, isSmallScreen),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredFiches.length,
            itemBuilder: (ctx, index) =>
                _buildFicheCard(filteredFiches[index], isSmallScreen, ctx),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext ctx) {
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
            //   child:
            //       const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            // ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'my_records'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _loadFiches,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar(bool isSmallScreen) {
    final filterText = _filterOptions[_selectedFilter] ?? 'all'.tr;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _showFilterDialog(),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppColors.lightShadow,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.filter_list,
                        color: AppColors.primaryGreen, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'filter_by'.tr.replaceFirst('{filter}', filterText),
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'filter_records'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ..._filterOptions.entries.map((entry) {
                return ListTile(
                  title: Text(entry.value),
                  leading: Radio<String>(
                    value: entry.key,
                    groupValue: _selectedFilter,
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value!;
                      });
                      Navigator.pop(context);
                    },
                    activeColor: AppColors.primaryGreen,
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsHeader(
      int fichesCount, int prospectsCount, bool isSmallScreen) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildStatCard(
            icon: Icons.folder_outlined,
            label: 'records'.tr,
            value: fichesCount.toString(),
            isSmallScreen: isSmallScreen,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            icon: Icons.people_outline,
            label: 'prospects'.tr,
            value: prospectsCount.toString(),
            isSmallScreen: isSmallScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required bool isSmallScreen,
  }) {
    final double fontSize = isSmallScreen ? 18 : 20;
    final double iconSize = isSmallScreen ? 20 : 24;
    final double padding = isSmallScreen ? 8 : 12;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: padding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppColors.lightShadow,
        ),
        child: Column(
          children: [
            Icon(icon, size: iconSize, color: AppColors.primaryGreen),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style:
                  const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFicheCard(
      Fiche fiche, bool isSmallScreen, BuildContext context) {
    final date = DateFormat('dd/MM/yyyy').format(fiche.dateCollecte);
    final time = DateFormat('HH:mm').format(fiche.dateCollecte);

    final double avatarSize = isSmallScreen ? 40 : 48;
    final double iconSize = isSmallScreen ? 22 : 28;
    final double titleSize = isSmallScreen ? 14 : 16;
    final double timeSize = isSmallScreen ? 10 : 12;
    final double cardPadding = isSmallScreen ? 12 : 16;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.lightShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.ficheDetail,
            arguments: {'ficheId': fiche.idFiche},
          ),
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Row(
              children: [
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.folder,
                      color: AppColors.primaryGreen, size: iconSize),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 12,
                        runSpacing: 4,
                        children: [
                          _buildInfoChip(
                            icon: Icons.people_outline,
                            text: '${fiche.prospects.length}',
                            isSmallScreen: isSmallScreen,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: timeSize,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right,
                    color: AppColors.textTertiary, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required bool isSmallScreen,
    Color? color,
  }) {
    final double iconSize = isSmallScreen ? 12 : 14;
    final double fontSize = isSmallScreen ? 11 : 12;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: iconSize, color: color ?? AppColors.textTertiary),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
              fontSize: fontSize, color: color ?? AppColors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder_open, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'no_records'.tr,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'create_first_record'.tr,
            style: const TextStyle(fontSize: 14, color: AppColors.textTertiary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
