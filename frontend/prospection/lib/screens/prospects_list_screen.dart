import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isetagcom/models/prospectData.dart';
import '../services/translation_service.dart';
import '../utils/themes/app_colors.dart';
import 'prospect_detail_screen.dart';

class ProspectsListScreen extends StatefulWidget {
  final List<ProspectDetails> allProspects;
  
  const ProspectsListScreen({
    super.key, 
    required this.allProspects,
  });

  @override
  State<ProspectsListScreen> createState() => _ProspectsListScreenState();
}

class _ProspectsListScreenState extends State<ProspectsListScreen> {
  late List<ProspectDetails> _allProspects;
  List<ProspectDetails> _filteredProspects = [];

  bool _isLoading = true;
  String _searchQuery = '';
  String _sortBy = 'date';
  bool _isDescending = true;

  String? _selectedStatus;
  String? _selectedEtablissement;

  final List<String> _statusOptions = ['Tous', 'À relancer', 'Nouveau', 'Contacté'];
  final List<String> _sortOptions = ['date', 'name', 'interest'];
  final Map<String, String> _sortLabels = {
    'date': 'Date',
    'name': 'Nom',
    'interest': 'Intérêt',
  };

  @override
  void initState() {
    super.initState();
    _allProspects = widget.allProspects;
    _applyFilters();
    _isLoading = false;
  }

  void _applyFilters() {
    List<ProspectDetails> filtered = List.from(_allProspects);

    // Filtre par recherche
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.prosp.nomComplet.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p.etablissement.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (p.prosp.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
            p.prosp.telephone.contains(_searchQuery);
      }).toList();
    }

    // Filtre par statut
    if (_selectedStatus != null && _selectedStatus != 'Tous') {
      filtered = filtered.where((p) {
        final status = p.prosp.prospectStatus.name;
        switch (_selectedStatus) {
          case 'À relancer':
            return status == 'relancer';
          case 'Nouveau':
            return status == 'nouveau';
          case 'Contacté':
            return status == 'contacte';
          default:
            return true;
        }
      }).toList();
    }

    // Filtre par établissement
    if (_selectedEtablissement != null && _selectedEtablissement!.isNotEmpty) {
      filtered = filtered.where((p) => p.etablissement == _selectedEtablissement).toList();
    }

    // Tri
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'name':
          comparison = a.prosp.nomComplet.compareTo(b.prosp.nomComplet);
          break;
        case 'interest':
          comparison = a.specialities.length.compareTo(b.specialities.length);
          break;
        case 'date':
        default:
          comparison = a.prosp.createdAt.compareTo(b.prosp.createdAt);
          break;
      }
      return _isDescending ? -comparison : comparison;
    });

    setState(() {
      _filteredProspects = filtered;
    });
  }

  List<String> get _uniqueEtablissements {
    return _allProspects.map((p) => p.etablissement).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildFilterBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProspects.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _filteredProspects.length,
                        itemBuilder: (context, index) => _buildProspectCard(
                            _filteredProspects[index], isSmallScreen),
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
                'prospects'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              '${_filteredProspects.length}',
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _applyFilters();
          });
        },
        decoration: InputDecoration(
          hintText: 'search_hint'.tr,
          hintStyle: const TextStyle(fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _applyFilters();
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              label: 'Tri: ${_sortLabels[_sortBy]}',
              icon: _isDescending ? Icons.arrow_downward : Icons.arrow_upward,
              onTap: () => _showSortDialog(),
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: _selectedStatus ?? 'Statut',
              icon: Icons.filter_list,
              onTap: () => _showStatusDialog(),
            ),
            const SizedBox(width: 8),
            if (_uniqueEtablissements.isNotEmpty)
              _buildFilterChip(
                label: _selectedEtablissement ?? 'Établissement',
                icon: Icons.school,
                onTap: () => _showEtablissementDialog(),
              ),
            const SizedBox(width: 8),
            if (_selectedStatus != null || _selectedEtablissement != null || _sortBy != 'date')
              _buildFilterChip(
                label: 'Réinitialiser',
                icon: Icons.refresh,
                color: Colors.red,
                onTap: () {
                  setState(() {
                    _selectedStatus = null;
                    _selectedEtablissement = null;
                    _sortBy = 'date';
                    _isDescending = true;
                    _applyFilters();
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    VoidCallback? onTap,
    Color color = AppColors.primaryGreen,
  }) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
      onSelected: (_) => onTap?.call(),
      backgroundColor: Colors.white,
      selectedColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }

  void _showSortDialog() {
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
              const Text('Trier par', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ..._sortOptions.map((sort) {
                return ListTile(
                  title: Text(_sortLabels[sort]!),
                  trailing: _sortBy == sort
                      ? IconButton(
                          icon: Icon(_isDescending ? Icons.arrow_downward : Icons.arrow_upward),
                          onPressed: () {
                            setState(() {
                              _isDescending = !_isDescending;
                              _applyFilters();
                            });
                            Navigator.pop(context);
                          },
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _sortBy = sort;
                      _applyFilters();
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showStatusDialog() {
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
              const Text('Filtrer par statut', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ..._statusOptions.map((status) {
                return ListTile(
                  title: Text(status),
                  trailing: _selectedStatus == status
                      ? const Icon(Icons.check_circle, color: AppColors.primaryGreen)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedStatus = status == 'Tous' ? null : status;
                      _applyFilters();
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showEtablissementDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Filtrer par établissement', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _uniqueEtablissements.length,
                  itemBuilder: (context, index) {
                    final ets = _uniqueEtablissements[index];
                    return ListTile(
                      title: Text(ets),
                      trailing: _selectedEtablissement == ets
                          ? const Icon(Icons.check_circle, color: AppColors.primaryGreen)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedEtablissement = ets;
                          _applyFilters();
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProspectCard(ProspectDetails prospectDetail, bool isSmallScreen) {
    final prospect = prospectDetail.prosp;
    final date = DateFormat('dd/MM/yyyy').format(prospect.createdAt);
    final hasSpecialities = prospectDetail.specialities.isNotEmpty;
    final firstSpeciality = hasSpecialities
        ? prospectDetail.specialities[0].libelleSpecialite
        : 'no_specialty'.tr;

    Color getStatusColor() {
      switch (prospect.prospectStatus.name) {
        case 'relancer': return AppColors.statusPending;
        case 'nouveau': return AppColors.statusNew;
        case 'contacte': return AppColors.statusContacted;
        default: return Colors.grey;
      }
    }

    String getStatusText() {
      switch (prospect.prospectStatus.name) {
        case 'relancer': return 'to_relaunch_badge'.tr;
        case 'nouveau': return 'new_badge'.tr;
        case 'contacte': return 'contacted_badge'.tr;
        default: return prospect.prospectStatus.name;
      }
    }

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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProspectDetailScreen(prospect: prospectDetail),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        getStatusColor().withOpacity(0.85),
                        getStatusColor().withOpacity(0.55),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      prospect.nomComplet.isNotEmpty ? prospect.nomComplet[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
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
                        prospect.nomComplet,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        prospect.telephone,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        prospectDetail.etablissement,
                        style: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Intérêt: $firstSpeciality${hasSpecialities && prospectDetail.specialities.length > 1 ? '...' : ''}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        getStatusText(),
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: getStatusColor()),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 12, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Text(date, style: const TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_outline, size: 70, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty ? 'Aucun résultat pour "$_searchQuery"' : 'Aucun prospect',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty ? 'Essayez avec d\'autres mots-clés' : 'Commencez par ajouter des prospects',
            style: const TextStyle(fontSize: 14, color: AppColors.textTertiary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}