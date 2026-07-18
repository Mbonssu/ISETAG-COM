// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isetagcom/models/classe.dart';
import 'package:isetagcom/models/pros.dart';
import '../models/etablissement.dart';
import '../models/fiche.dart';
import '../models/interet_filiere.dart';
import '../models/localStorage/local_storage.dart';
import '../models/source.dart';
import '../models/specialite.dart';
import '../services/export_service.dart';
import '../services/loading_service.dart';
import '../services/translation_service.dart';
import '../utils/status.dart';
import '../utils/sync_queue.dart';
import '../utils/themes/glass_theme.dart';

class AddProspectScreen extends StatefulWidget {
  const AddProspectScreen({super.key});

  @override
  State<AddProspectScreen> createState() => _AddProspectScreenState();
}

class _AddProspectScreenState extends State<AddProspectScreen> {
  @override
  void initState() {
    super.initState();
    init_form();
    _loadInitialData();
  }

  final _formKey = GlobalKey<FormState>();

  // Controllers pour Prospect
  final _nomCompletCtrl = TextEditingController();
  final _telephoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _concerneCtrl = TextEditingController();
  final _adresseCtrl = TextEditingController();
  final _relanceCtrl = TextEditingController();

  // Controllers pour commentaire
  final _commentaireCtrl = TextEditingController();

  // Liste des intérêts (plusieurs filières)
  final List<Map<String, dynamic>> _interetsList = [];

  // Controllers pour ajouter un intérêt
  final TextEditingController _newOrdrePreferenceCtrl = TextEditingController();
  final TextEditingController _newNiveauInteretCtrl = TextEditingController();
  final TextEditingController _newCommentaireInteretCtrl =
      TextEditingController();

  // Variables pour les sélections
  String? _selectedSpecialiteForInteret;
  String _selectedSexe = '';
  String _selectedTypeProspect = '';
  String _selectedEtablissement = '';
  String _selectedClasse = '';
  String _selectedSource = '';
  String _selectedNiveauEtude = '';
  int _scoreInteret = 5;

  DateTime now = DateTime.now();
  DateTime? _date_relance;

  // Sections expansion state
  final Map<String, bool> _sectionsExpanded = {
    'personnelles': true,
    'academiques': false,
    'interet': false,
    'commentaires': false,
    'relance': false,
  };

  // Sources (hardcoded - no add feature)
  final List<String> _sources = [
    'Réseaux sociaux',
    'Recommandation',
    'Site web',
    'Événement',
    'Prospection terrain',
    'Partenariat',
    'Bouche à oreille',
  ];

  final List<String> _sexeOptions = ['Masculin', 'Féminin'];
  final List<String> _typeProspectOptions = [
    'Étudiant',
    'Éleve',
  ];
  final List<String> _niveauEtudeOptions = [
    'Baccalauréat',
    'BTS 1',
    'BTS 2',
    'Licence',
    'Master 1',
    'Master 2',
    'Doctorat'
  ];

  // Data lists loaded from Isar (managed incrementally)
  List<Etablissement> _etablissements = [];
  List<Classe> _classes = [];
  List<Specialite> _specialites = [];

  // Stream subscriptions for incremental updates
  StreamSubscription<List<Etablissement>>? _etsSubscription;
  StreamSubscription<List<Classe>>? _classesSubscription;
  StreamSubscription<List<Specialite>>? _specSubscription;

  // Loading state for initial load
  bool _isLoadingData = true;

  // Type options
  final List<String> _etablissementTypes = ['Secondary', 'University'];

  void init_form() {
    _nomCompletCtrl.text = 'Reo';
    _telephoneCtrl.text = '3212';
    _emailCtrl.text = 'e@gmail.com';
    _concerneCtrl.text = _typeProspectOptions[0];
    _adresseCtrl.text = 'Reo city';

    _commentaireCtrl.text = 'Right';
    _selectedNiveauEtude = _niveauEtudeOptions[0];
    _relanceCtrl.text = '';
    _selectedSexe = _sexeOptions[0];
    _selectedTypeProspect = _typeProspectOptions[0];
    _selectedSource = _sources[0];
    _newOrdrePreferenceCtrl.text = "1";
    _newNiveauInteretCtrl.text = "1";
    _newCommentaireInteretCtrl.text = "Interest comment";
  }

  Future<void> _loadInitialData() async {
    final localStorage = LocalStorage.instance;
    await localStorage.init();

    final etsList = await localStorage.getAllEtablissements();
    final classList = await localStorage.getAllClasses();
    final specList = await localStorage.getAllSpecialites();

    setState(() {
      _etablissements = etsList;
      _classes = classList;
      _specialites = specList;
      _isLoadingData = false;

      if (_etablissements.isNotEmpty) {
        _selectedEtablissement = _etablissements[0].nomEtablissement;
      }
      if (_classes.isNotEmpty) {
        _selectedClasse = _classes[0].libelleClasse;
      }
      if (_specialites.isNotEmpty) {
        _selectedSpecialiteForInteret = _specialites[0].libelleSpecialite;
      }
    });

    _setupWatches();
  }

  void _setupWatches() {
    _etsSubscription = LocalStorage.instance
        .watchEtablissementsIncremental(_etablissements)
        .listen((newEts) {
      if (newEts.isNotEmpty) {
        setState(() {
          _etablissements.addAll(newEts);
        });
      }
    });

    _classesSubscription = LocalStorage.instance
        .watchClassesIncremental(_classes)
        .listen((newClasses) {
      if (newClasses.isNotEmpty) {
        setState(() {
          _classes.addAll(newClasses);
        });
      }
    });

    _specSubscription = LocalStorage.instance
        .watchSpecialitesIncremental(_specialites)
        .listen((newSpecs) {
      if (newSpecs.isNotEmpty) {
        setState(() {
          _specialites.addAll(newSpecs);
        });
      }
    });
  }

  @override
  void dispose() {
    _etsSubscription?.cancel();
    _classesSubscription?.cancel();
    _specSubscription?.cancel();
    super.dispose();
  }

  // ==================== HELPERS ====================

  /// Get allowed class libelles for a given study level
  List<String> _getAllowedClassesForNiveau(String niveau) {
    switch (niveau) {
      case 'Baccalauréat':
        return ['Terminale C', 'Terminale D', 'Terminale A4', 'Terminale TI'];
      case 'BTS 1':
        return ['BTS 1'];
      case 'BTS 2':
        return ['BTS 2'];
      case 'Licence':
        return ['Licence 1', 'Licence 2', 'Licence 3'];
      case 'Master 1':
        return ['Master 1'];
      case 'Master 2':
        return ['Master 2'];
      case 'Doctorat':
        return ['Doctorat'];
      default:
        return [];
    }
  }

  /// Get establishment type required for a given study level
  String? _getEtablissementTypeForNiveau(String niveau) {
    if (niveau == 'Baccalauréat') {
      return 'Secondary';
    } else {
      return 'University';
    }
  }

  /// Get filtered establishments by type
  List<Etablissement> _getFilteredEtablissements() {
    final type = _getEtablissementTypeForNiveau(_selectedNiveauEtude);
    if (type == null) return _etablissements;
    return _etablissements.where((e) => e.typeEtablissement == type).toList();
  }

  /// Get filtered classes by niveau (with duplicates removed)
  List<Classe> _getFilteredClasses() {
    final allowed = _getAllowedClassesForNiveau(_selectedNiveauEtude);
    if (allowed.isEmpty) return _classes;

    // Filter classes and remove duplicates by libelleClasse
    final filtered =
        _classes.where((c) => allowed.contains(c.libelleClasse)).toList();

    // Remove duplicates by libelleClasse (keep first occurrence)
    final seen = <String>{};
    final uniqueClasses = <Classe>[];
    for (final classe in filtered) {
      if (seen.add(classe.libelleClasse)) {
        uniqueClasses.add(classe);
      }
    }

    return uniqueClasses;
  }

  // ==================== BUILD METHODS ====================

  @override
  Widget build(BuildContext context) {
    // Check if class dropdown should be shown:
    // Only when typeProspect is "Éleve" AND niveauEtude is "Baccalauréat"
    final bool showClassDropdown = _selectedTypeProspect == 'Éleve' &&
        _selectedNiveauEtude == 'Baccalauréat';

    return Scaffold(
      body: PageBackground(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoadingData
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      physics: const BouncingScrollPhysics(),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section 1: Informations Personnelles
                            _buildExpandableSection(
                              title: 'personal_info'.tr,
                              icon: Icons.person_outline,
                              isExpanded: _sectionsExpanded['personnelles']!,
                              onToggle: () => _toggleSection('personnelles'),
                              children: [
                                _buildTextField(
                                  controller: _nomCompletCtrl,
                                  label: 'full_name'.tr,
                                  hint: 'enter_full_name'.tr,
                                  icon: Icons.person_outline,
                                  required: true,
                                ),
                                const SizedBox(height: 12),
                                _buildTextField(
                                  controller: _telephoneCtrl,
                                  label: 'phone'.tr,
                                  hint: 'enter_phone'.tr,
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                  required: true,
                                ),
                                const SizedBox(height: 12),
                                _buildTextField(
                                  controller: _emailCtrl,
                                  label: 'email'.tr,
                                  hint: 'enter_email'.tr,
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 12),
                                _buildSearchableDropdown(
                                  value: _selectedSexe,
                                  label: 'gender'.tr,
                                  hint: 'select'.tr,
                                  icon: Icons.man_2,
                                  items: _sexeOptions,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSexe = value!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 12),
                                _buildSearchableDropdown(
                                  value: _selectedNiveauEtude,
                                  label: 'education_level'.tr,
                                  hint: 'select'.tr,
                                  icon: Icons.school_outlined,
                                  items: _niveauEtudeOptions,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedNiveauEtude = value!;
                                      _selectedClasse = '';
                                    });
                                  },
                                ),
                                const SizedBox(height: 12),
                                _buildSearchableDropdown(
                                  value: _selectedTypeProspect,
                                  label: 'who_is_prospect'.tr,
                                  hint: 'select'.tr,
                                  icon: Icons.category_outlined,
                                  items: _typeProspectOptions,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedTypeProspect = value!;
                                      // Reset class when type changes
                                      _selectedClasse = '';
                                    });
                                  },
                                ),
                                const SizedBox(height: 12),
                                _buildTextField(
                                  controller: _adresseCtrl,
                                  label: 'address'.tr,
                                  hint: 'full_address'.tr,
                                  icon: Icons.location_on_outlined,
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Section 2: Informations académiques
                            _buildExpandableSection(
                              title: 'academic_info'.tr,
                              icon: Icons.business_outlined,
                              isExpanded: _sectionsExpanded['academiques']!,
                              onToggle: () => _toggleSection('academiques'),
                              children: [
                                _buildEtablissementDropdown(),
                                // Only show class dropdown if condition is met
                                if (showClassDropdown) ...[
                                  const SizedBox(height: 12),
                                  _buildClasseDropdown(),
                                ],
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Section 3: Intérêt et provenance
                            _buildExpandableSection(
                              title: 'interest_source'.tr,
                              icon: Icons.insights_outlined,
                              isExpanded: _sectionsExpanded['interet']!,
                              onToggle: () => _toggleSection('interet'),
                              children: [
                                // Simple dropdown for source (no add feature)
                                _buildSearchableDropdown(
                                  value: _selectedSource,
                                  label: 'source'.tr,
                                  hint: 'select'.tr,
                                  icon: Icons.source_outlined,
                                  items: _sources,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSource = value!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 12),
                                _buildInteretsListSection(),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Section 4: Commentaires
                            _buildExpandableSection(
                              title: 'comments'.tr,
                              icon: Icons.comment_outlined,
                              isExpanded: _sectionsExpanded['commentaires']!,
                              onToggle: () => _toggleSection('commentaires'),
                              children: [
                                _buildTextField(
                                  controller: _commentaireCtrl,
                                  label: 'general_comment'.tr,
                                  hint: 'add_observations'.tr,
                                  icon: Icons.comment_outlined,
                                  maxLines: 3,
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            _buildExpandableSection(
                              title: 'schedule_followup'.tr,
                              icon: Icons.schedule_rounded,
                              isExpanded: _sectionsExpanded['relance']!,
                              onToggle: () => _toggleSection('relance'),
                              children: [
                                _buildDateTimeField(
                                  controller: _relanceCtrl,
                                  label: 'followup_date'.tr,
                                  hint: 'schedule_followup'.tr,
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      side: BorderSide(
                                          color: Colors.grey.shade400),
                                    ),
                                    child: Text('cancel'.tr,
                                        style: const TextStyle(fontSize: 16)),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _saveProspect();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2E7D32),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                    child: Text('save'.tr,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== ÉTABLISSEMENT DROPDOWN (with Modal) ====================

  Widget _buildEtablissementDropdown() {
    final filtered = _getFilteredEtablissements();
    final items = filtered.map((e) => e.nomEtablissement).toList();
    if (_selectedEtablissement.isNotEmpty &&
        !items.contains(_selectedEtablissement)) {
      _selectedEtablissement = items.isNotEmpty ? items[0] : '';
    }

    return GestureDetector(
      onTap: () => _showEtablissementModal(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.school_outlined,
                color: Color(0xFF2E7D32), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'establishment'.tr,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    _selectedEtablissement.isEmpty
                        ? 'select_establishment'.tr
                        : _selectedEtablissement,
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectedEtablissement.isEmpty
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF2E7D32)),
          ],
        ),
      ),
    );
  }

  void _showEtablissementModal() {
    final filtered = _getFilteredEtablissements();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // Search state inside the modal
        String searchQuery = '';

        return StatefulBuilder(
          builder: (context, setState) {
            // Filter based on search query
            final displayed = searchQuery.isEmpty
                ? filtered
                : filtered
                    .where((e) => e.nomEtablissement
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'select_establishment'.tr,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'search_establishments'.tr,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                  ),
                  Expanded(
                    child: displayed.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.school_outlined,
                                    size: 60, color: Colors.grey.shade300),
                                const SizedBox(height: 8),
                                Text(
                                  'no_establishments'.tr,
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: displayed.length,
                            itemBuilder: (context, index) {
                              final ets = displayed[index];
                              return ListTile(
                                leading: const Icon(Icons.school,
                                    color: Color(0xFF2E7D32)),
                                title: Text(ets.nomEtablissement),
                                subtitle: ets.typeEtablissement != null
                                    ? Text(ets.typeEtablissement == 'Secondary'
                                        ? 'secondary'.tr
                                        : 'university'.tr)
                                    : null,
                                trailing: ets.nomEtablissement ==
                                        _selectedEtablissement
                                    ? const Icon(Icons.check_circle,
                                        color: Colors.green)
                                    : null,
                                onTap: () {
                                  setState(() {
                                    _selectedEtablissement =
                                        ets.nomEtablissement;
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showAddEtablissementDialog();
                      },
                      icon: const Icon(Icons.add),
                      label: Text('add_establishment'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddEtablissementDialog() {
    final TextEditingController nomController = TextEditingController();
    String? selectedType = 'Secondary';
    final TextEditingController adresseController = TextEditingController();
    final TextEditingController telephoneController = TextEditingController();
    final TextEditingController villeController = TextEditingController();
    final TextEditingController regionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('add_establishment'.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nomController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'establishment_name'.tr,
                  hintText: 'enter_establishment_name'.tr,
                  prefixIcon: const Icon(Icons.school),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'required_field'.tr : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: InputDecoration(
                  labelText: 'establishment_type'.tr,
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _etablissementTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(
                        type == 'Secondary' ? 'secondary'.tr : 'university'.tr),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedType = value;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: adresseController,
                decoration: InputDecoration(
                  labelText: 'address'.tr,
                  hintText: 'enter_address'.tr,
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: telephoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'phone'.tr,
                  hintText: 'enter_phone'.tr,
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: villeController,
                decoration: InputDecoration(
                  labelText: 'city'.tr,
                  hintText: 'enter_city'.tr,
                  prefixIcon: const Icon(Icons.location_city),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: regionController,
                decoration: InputDecoration(
                  labelText: 'region'.tr,
                  hintText: 'enter_region'.tr,
                  prefixIcon: const Icon(Icons.map),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nomController.text.isNotEmpty) {
                final newEtablissement = Etablissement(
                  idEtablissement:
                      'ets_${DateTime.now().millisecondsSinceEpoch}',
                  nomEtablissement: nomController.text,
                  typeEtablissement: selectedType,
                  adresse: adresseController.text.isNotEmpty
                      ? adresseController.text
                      : null,
                  telephone: telephoneController.text.isNotEmpty
                      ? telephoneController.text
                      : null,
                  ville: villeController.text.isNotEmpty
                      ? villeController.text
                      : null,
                  region: regionController.text.isNotEmpty
                      ? regionController.text
                      : null,
                  createdAt: DateTime.now(),
                  syncState: SyncState.pending,
                );

                final resultKey = await LocalStorage.instance
                    .addEtablissementIfNotExists(newEtablissement);

                Navigator.pop(context);

                if (resultKey.contains('success')) {
                  _showSnackBar(resultKey.tr, const Color(0xFF2E7D32), 3);
                } else {
                  _showSnackBar(resultKey.tr, Colors.orange, 3);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
            ),
            child: Text('add'.tr),
          ),
        ],
      ),
    );
  }

  // ==================== CLASSE DROPDOWN (Filtered with no duplicates) ====================

  Widget _buildClasseDropdown() {
    final filteredClasses = _getFilteredClasses();
    final items = filteredClasses.map((c) => c.libelleClasse).toList();
    if (_selectedClasse.isNotEmpty && !items.contains(_selectedClasse)) {
      _selectedClasse = items.isNotEmpty ? items[0] : '';
    }

    return _buildSearchableDropdown(
      value: _selectedClasse,
      label: 'class'.tr,
      hint: 'select'.tr,
      icon: Icons.class_outlined,
      items: items,
      onChanged: (value) {
        setState(() {
          _selectedClasse = value!;
        });
      },
    );
  }

  // ==================== SPÉCIALITÉS with FULL MODAL ====================

  Widget _buildInteretsListSection() {
    final availableSpecialites = _specialites
        .map((s) => s.libelleSpecialite)
        .where((spec) =>
            !_interetsList.any((interet) => interet['specialite'] == spec))
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_interetsList.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('selected_specialties'.tr,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B5E20))),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _interetsList.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final interet = _interetsList[index];
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(0xFF2E7D32).withOpacity(0.1),
                    child: Text('${index + 1}',
                        style: const TextStyle(
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ),
                  title: Text(interet['specialite'],
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  subtitle: Text(
                    'order_preference'
                        .tr
                        .replaceFirst(
                            '{order}', '${interet['ordrePreference']}')
                        .replaceFirst('{level}', '${interet['niveauInteret']}'),
                    style: const TextStyle(fontSize: 11),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.red, size: 18),
                    onPressed: () {
                      setState(() {
                        _interetsList.removeAt(index);
                        for (int i = 0; i < _interetsList.length; i++) {
                          _interetsList[i]['ordrePreference'] = i + 1;
                        }
                      });
                    },
                  ),
                  onTap: () => _showEditInteretDialog(index),
                );
              },
            ),
            const Divider(),
          ],
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('add_specialty'.tr,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
                const SizedBox(height: 12),
                _buildSpecialiteSelector(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSmallTextField(
                        controller: _newOrdrePreferenceCtrl,
                        label: 'order'.tr,
                        hint: 'order_hint'.tr,
                        icon: Icons.format_list_numbered,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSmallTextField(
                        controller: _newNiveauInteretCtrl,
                        label: 'level'.tr,
                        hint: 'level_hint'.tr,
                        icon: Icons.star_outline,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSmallTextField(
                  controller: _newCommentaireInteretCtrl,
                  label: 'comment'.tr,
                  hint: 'specify_interest'.tr,
                  icon: Icons.comment_outlined,
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _clearInteretForm,
                        icon: const Icon(Icons.clear, size: 16),
                        label: Text('clear'.tr),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _addInteret,
                        icon: const Icon(Icons.add, size: 16),
                        label: Text('add'.tr),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Specialite selector with full modal (like establishment)
  Widget _buildSpecialiteSelector() {
    final availableSpecialites = _specialites
        .map((s) => s.libelleSpecialite)
        .where((spec) =>
            !_interetsList.any((interet) => interet['specialite'] == spec))
        .toList();

    String? validValue;
    if (_selectedSpecialiteForInteret != null &&
        availableSpecialites.contains(_selectedSpecialiteForInteret)) {
      validValue = _selectedSpecialiteForInteret;
    }

    return GestureDetector(
      onTap: () => _showSpecialiteModal(availableSpecialites),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.5)),
        ),
        child: Row(
          children: [
            const Icon(Icons.school_outlined,
                color: Color(0xFF2E7D32), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'specialty_field'.tr,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    validValue ?? 'select_specialty'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: validValue != null ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF2E7D32)),
          ],
        ),
      ),
    );
  }

  void _showSpecialiteModal(List<String> availableSpecialites) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // Search state inside the modal
        String searchQuery = '';

        return StatefulBuilder(
          builder: (context, setState) {
            // Filter based on search query
            final displayed = searchQuery.isEmpty
                ? availableSpecialites
                : availableSpecialites
                    .where((spec) =>
                        spec.toLowerCase().contains(searchQuery.toLowerCase()))
                    .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'select_specialty'.tr,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'search_specialties'.tr,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                  ),
                  Expanded(
                    child: displayed.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.school_outlined,
                                    size: 60, color: Colors.grey.shade300),
                                const SizedBox(height: 8),
                                Text(
                                  'no_specialties'.tr,
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: displayed.length,
                            itemBuilder: (context, index) {
                              final spec = displayed[index];
                              return ListTile(
                                leading: const Icon(Icons.school,
                                    color: Color(0xFF2E7D32)),
                                title: Text(spec),
                                trailing: spec == _selectedSpecialiteForInteret
                                    ? const Icon(Icons.check_circle,
                                        color: Colors.green)
                                    : null,
                                onTap: () {
                                  setState(() {
                                    _selectedSpecialiteForInteret = spec;
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showAddSpecialiteDialog();
                      },
                      icon: const Icon(Icons.add),
                      label: Text('add_new_specialty'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Add Specialite Dialog (like establishment dialog)
  void _showAddSpecialiteDialog() {
    final TextEditingController nomController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('new_specialty'.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nomController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'specialty_name'.tr,
                  hintText: 'enter_specialty_name'.tr,
                  prefixIcon: const Icon(Icons.school),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'required_field'.tr : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'description'.tr,
                  hintText: 'enter_description'.tr,
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nomController.text.isNotEmpty) {
                final newSpecialite = Specialite(
                  idSpecialite:
                      'specialite_${DateTime.now().millisecondsSinceEpoch}',
                  libelleSpecialite: nomController.text,
                  description: descriptionController.text.isNotEmpty
                      ? descriptionController.text
                      : null,
                  createdAt: DateTime.now(),
                  syncState: SyncState.pending,
                );

                final resultKey = await LocalStorage.instance
                    .addSpecialiteIfNotExists(newSpecialite);

                Navigator.pop(context);

                if (resultKey.contains('success')) {
                  _selectedSpecialiteForInteret = nomController.text;
                  _showSnackBar(resultKey.tr, const Color(0xFF2E7D32), 3);
                } else {
                  _showSnackBar(resultKey.tr, Colors.orange, 3);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
            ),
            child: Text('add'.tr),
          ),
        ],
      ),
    );
  }

  // ==================== AUTRES MÉTHODES ====================

  void _toggleSection(String section) {
    setState(() {
      _sectionsExpanded[section] = !_sectionsExpanded[section]!;
    });
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onToggle,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Icon(icon, size: 22, color: const Color(0xFF2E7D32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(title,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1B5E20))),
                    ),
                    Icon(isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey.shade600, size: 24),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children),
            ),
        ],
      ),
    );
  }

  void _addInteret() {
    final specialite = _selectedSpecialiteForInteret;
    final ordrePreference = int.tryParse(_newOrdrePreferenceCtrl.text.trim());
    final niveauInteret = int.tryParse(_newNiveauInteretCtrl.text.trim());

    if (specialite == null || specialite.isEmpty) {
      _showSnackBar('select_specialty_warning'.tr, Colors.orange, 5);
      return;
    }
    if (ordrePreference == null || ordrePreference < 1) {
      _showSnackBar('invalid_order'.tr, Colors.orange, 5);
      return;
    }
    if (niveauInteret == null || niveauInteret < 1 || niveauInteret > 10) {
      _showSnackBar('invalid_level'.tr, Colors.orange, 5);
      return;
    }
    if (_interetsList.any((i) => i['ordrePreference'] == ordrePreference)) {
      _showSnackBar('order_exists'.tr, Colors.orange, 5);
      return;
    }
    if (_interetsList.any((i) => i['specialite'] == specialite)) {
      _showSnackBar('specialty_exists'.tr, Colors.orange, 5);
      return;
    }

    setState(() {
      _interetsList.add({
        'specialite': specialite,
        'ordrePreference': ordrePreference,
        'niveauInteret': niveauInteret,
        'commentaire': _newCommentaireInteretCtrl.text.trim(),
      });
      _clearInteretForm();
    });
    _showSnackBar('specialty_added_success'.tr, const Color(0xFF2E7D32), 3);
  }

  void _clearInteretForm() {
    setState(() {
      _selectedSpecialiteForInteret = null;
      _newOrdrePreferenceCtrl.clear();
      _newNiveauInteretCtrl.clear();
      _newCommentaireInteretCtrl.clear();
    });
  }

  void _showEditInteretDialog(int index) {
    final interet = _interetsList[index];
    final ordreCtrl =
        TextEditingController(text: interet['ordrePreference'].toString());
    final niveauCtrl =
        TextEditingController(text: interet['niveauInteret'].toString());
    final commentaireCtrl = TextEditingController(text: interet['commentaire']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('modify_specialty'
            .tr
            .replaceFirst('{specialty}', interet['specialite'])),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallTextField(
                controller: ordreCtrl,
                label: 'order'.tr,
                hint: 'order_hint'.tr,
                icon: Icons.format_list_numbered),
            const SizedBox(height: 12),
            _buildSmallTextField(
                controller: niveauCtrl,
                label: 'level'.tr,
                hint: 'level_hint'.tr,
                icon: Icons.star_outline),
            const SizedBox(height: 12),
            _buildSmallTextField(
                controller: commentaireCtrl,
                label: 'comment'.tr,
                hint: 'specify_interest'.tr,
                icon: Icons.comment_outlined,
                maxLines: 2),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr)),
          ElevatedButton(
            onPressed: () {
              final ordre = int.tryParse(ordreCtrl.text);
              final niveau = int.tryParse(niveauCtrl.text);
              if (ordre != null &&
                  ordre >= 1 &&
                  niveau != null &&
                  niveau >= 1 &&
                  niveau <= 10) {
                setState(() {
                  _interetsList[index]['ordrePreference'] = ordre;
                  _interetsList[index]['niveauInteret'] = niveau;
                  _interetsList[index]['commentaire'] = commentaireCtrl.text;
                  _interetsList.sort((a, b) =>
                      a['ordrePreference'].compareTo(b['ordrePreference']));
                  for (int i = 0; i < _interetsList.length; i++) {
                    _interetsList[i]['ordrePreference'] = i + 1;
                  }
                });
                Navigator.pop(context);
                _showSnackBar('modify_success'.tr, const Color(0xFF2E7D32), 3);
              } else {
                _showSnackBar('invalid_values'.tr, Colors.orange, 3);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32)),
            child: Text('save'.tr, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color, int dur) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: Duration(seconds: dur)),
    );
  }

  // ==================== WIDGETS DE SAISIE ====================

  Widget _buildSmallTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.5)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF2E7D32), size: 16),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: Color(0xFF2E7D32),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child:
                  const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'new_prospect'.tr,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12)),
              child:
                  const Icon(Icons.person_add, color: Colors.white, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool required = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelStyle: const TextStyle(color: Colors.grey),
        ),
        validator: required
            ? (value) =>
                value == null || value.isEmpty ? 'required_field'.tr : null
            : null,
      ),
    );
  }

  // ==================== DROPDOWNS ====================

  Widget _buildSearchableDropdown({
    required String? value,
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return GestureDetector(
      onTap: () => _showSimpleSearchableDialog(items, label, onChanged),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            labelStyle: const TextStyle(color: Colors.grey),
          ),
          child: Row(
            children: [
              Expanded(
                  child: Text(value ?? hint,
                      style: TextStyle(
                          color: value != null ? Colors.black87 : Colors.grey,
                          fontSize: 14))),
              const Icon(Icons.arrow_drop_down, color: Color(0xFF2E7D32)),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== DIALOGUES DE RECHERCHE ====================

  void _showSimpleSearchableDialog(
      List<String> items, String title, Function(String?) onChanged) {
    TextEditingController searchController = TextEditingController();
    List<String> filteredItems = List.from(items);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${'select'.tr} $title',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'search'.tr,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              setState(() => filteredItems = List.from(items));
                            })
                        : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (value) => setState(() {
                    filteredItems = value.isEmpty
                        ? List.from(items)
                        : items
                            .where((item) => item
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                  }),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: filteredItems.isEmpty
                      ? Center(
                          child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text('no_result'.tr)))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) => ListTile(
                            leading: const Icon(Icons.check_circle_outline,
                                color: Color(0xFF2E7D32)),
                            title: Text(filteredItems[index]),
                            onTap: () {
                              onChanged(filteredItems[index]);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== DATE TIME PICKER ====================

  Widget _buildDateTimeField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    const Color green = Color(0xFF2E7D32);

    Future<void> pickDateTime(BuildContext context) async {
      final DateTime? dateRelance = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: green),
          ),
          child: child!,
        ),
      );
      if (dateRelance == null) return;

      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: green),
          ),
          child: child!,
        ),
      );
      if (time == null) return;

      _date_relance = DateTime(dateRelance.year, dateRelance.month,
          dateRelance.day, time.hour, time.minute);

      controller.text = '${_date_relance?.day.toString().padLeft(2, '0')}/'
          '${_date_relance?.month.toString().padLeft(2, '0')}/'
          '${_date_relance?.year} '
          '${time.hour.toString().padLeft(2, '0')}:'
          '${time.minute.toString().padLeft(2, '0')}';
    }

    return GestureDetector(
      onTap: () => pickDateTime(context),
      child: AbsorbPointer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: green.withOpacity(0.5)),
          ),
          child: TextFormField(
            controller: controller,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon:
                  const Icon(Icons.calendar_today, color: green, size: 16),
              suffixIcon: const Icon(Icons.access_time, color: green, size: 16),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  // ==================== SAUVEGARDE ====================

  // Future<void> _saveProspect() async {
  //   LoadingService().show(context, message: 'saving_prospect'.tr);

  //   if (!_formKey.currentState!.validate()) {
  //     LoadingService().hide();
  //     return;
  //   }

  //   // Validate that a source is selected
  //   if (_selectedSource.isEmpty) {
  //     _showSnackBar('Please select a source'.tr, Colors.orange, 5);
  //     LoadingService().hide();
  //     return;
  //   }

  //   if (_interetsList.isEmpty) {
  //     _showSnackBar('add_specialty_warning'.tr, Colors.orange, 5);
  //     _toggleSection('interet');
  //     LoadingService().hide();
  //     return;
  //   }

  //   Source? src = await LocalStorage.instance.getLastRecSource();
  //   Fiche? f = await LocalStorage.instance.getLastRecFiche();

  //   print(
  //       "Last Src: ${src?.toLocalJson()}, and Last fiche: ${f?.toLocalJson()}");

  //   if (src == null || f == null) {
  //     _showSnackBar('missing_source_or_fiche'.tr, Colors.red, 5);
  //     LoadingService().hide();
  //     return;
  //   }

  //   final now = DateTime.now();

  //   // List to store saved specialites for queue
  //   final List<Specialite> savedSpecialites = [];
  //   final List<InteretFiliere> savedInterets = [];

  //   // Check if establishment already exists
  //   Etablissement? existingEts = await LocalStorage.instance
  //       .getEtablissementByNom(_selectedEtablissement);
  //   Etablissement ets;

  //   if (existingEts != null) {
  //     ets = existingEts;
  //     print('Using existing establishment: ${ets.nomEtablissement}');
  //   } else {
  //     ets = Etablissement(
  //         idEtablissement: 'ets_${DateTime.now().millisecondsSinceEpoch}',
  //         nomEtablissement: _selectedEtablissement,
  //         typeEtablissement:
  //             _getEtablissementTypeForNiveau(_selectedNiveauEtude),
  //         adresse: null,
  //         telephone: null,
  //         ville: null,
  //         region: null,
  //         createdAt: now,
  //         syncState: SyncState.pending);
  //     String resultKey =
  //         await LocalStorage.instance.addEtablissementIfNotExists(ets);
  //     _showSnackBar(
  //         resultKey.tr,
  //         resultKey.contains('success')
  //             ? const Color(0xFF2E7D32)
  //             : Colors.orange,
  //         3);
  //     if (!resultKey.contains('success')) {
  //       LoadingService().hide();
  //       return;
  //     }
  //   }

  //   // Check if class already exists for this establishment
  //   Classe? existingClasse = await LocalStorage.instance
  //       .getClasseByLibelleAndEts(_selectedClasse, ets.idEtablissement);
  //   Classe clse;

  //   if (existingClasse != null) {
  //     clse = existingClasse;
  //     print('Using existing class: ${clse.libelleClasse}');
  //   } else {
  //     clse = Classe(
  //         idClasse: 'classe_${DateTime.now().millisecondsSinceEpoch}',
  //         idEts: ets.idEtablissement,
  //         libelleClasse: _selectedClasse,
  //         createdAt: now,
  //         syncState: SyncState.pending);
  //     String resultKey = await LocalStorage.instance.saveClasse(clse);
  //     if (!resultKey.contains('success')) {
  //       _showSnackBar(resultKey.tr, Colors.orange, 3);
  //       LoadingService().hide();
  //       return;
  //     }
  //   }

  //   // Create prospect with source_infos from dropdown
  //   final prospect = Prospect(
  //     idProspect: 'prospect_${DateTime.now().millisecondsSinceEpoch}',
  //     idfiche: f.idFiche,
  //     idClass: clse.idClasse,
  //     nomComplet: _nomCompletCtrl.text,
  //     telephone: _telephoneCtrl.text,
  //     email: _emailCtrl.text.isEmpty ? null : _emailCtrl.text,
  //     niveauEtude: _selectedNiveauEtude,
  //     adresse: _adresseCtrl.text.isEmpty ? null : _adresseCtrl.text,
  //     sexe: _selectedSexe,
  //     typeProspect: _selectedTypeProspect,
  //     source_infos: _selectedSource,
  //     commentaireGen: _commentaireCtrl.text,
  //     concerne: null,
  //     date_relance: _date_relance,
  //     createdAt: now,
  //     syncState: SyncState.pending,
  //     prospectStatus: ProspectStatus.nouveau,
  //   );

  //   print("Prospect data form \n: ${prospect.toLocalJson()}");
  //   print("Source info: ${prospect.source_infos}");
  //   String prospectResult = await LocalStorage.instance.saveProspect(prospect);

  //   if (!prospectResult.contains('success')) {
  //     _showSnackBar(prospectResult.tr, Colors.orange, 5);
  //     LoadingService().hide();
  //     return;
  //   }

  //   int savedInteretsCount = 0;
  //   for (var item in _interetsList) {
  //     // Check if specialite already exists
  //     Specialite? specialite =
  //         await LocalStorage.instance.getSpecialiteByNom(item['specialite']);
  //     String specialiteResult;

  //     if (specialite == null) {
  //       specialite = Specialite(
  //         idSpecialite:
  //             'specialite_${DateTime.now().millisecondsSinceEpoch}_$savedInteretsCount',
  //         libelleSpecialite: item['specialite'],
  //         description: null,
  //         createdAt: now,
  //         syncState: SyncState.pending,
  //       );
  //       specialiteResult =
  //           await LocalStorage.instance.addSpecialiteIfNotExists(specialite);
  //       if (!specialiteResult.contains('success')) {
  //         _showSnackBar(specialiteResult.tr, Colors.orange, 3);
  //         continue;
  //       }
  //     }

  //     // Add to saved list for queue
  //     savedSpecialites.add(specialite);

  //     // Check if interest already exists
  //     InteretFiliere? existingInteret = await LocalStorage.instance
  //         .getInteretByProspectAndSpecialite(
  //             prospect.idProspect, specialite.idSpecialite);

  //     if (existingInteret != null) {
  //       print('Interest already exists for this prospect and specialite');
  //       continue;
  //     }

  //     final interet = InteretFiliere(
  //       idInteret:
  //           'interet_${DateTime.now().millisecondsSinceEpoch}_${item['ordrePreference']}',
  //       idProspect: prospect.idProspect,
  //       idSpecialite: specialite.idSpecialite,
  //       ordrePreference: item['ordrePreference'] ?? 0,
  //       niveauInteret: item['niveauInteret'] ?? 0,
  //       commentaire: item['commentaire'] ?? '',
  //       createdAt: now,
  //       syncState: SyncState.pending,
  //     );

  //     interet.prospect.value = prospect;
  //     interet.specialite.value = specialite;

  //     await LocalStorage.instance.saveInteret(interet);
  //     savedInterets.add(interet);
  //     savedInteretsCount++;
  //   }

  //   _showSnackBar(
  //       'prospect_saved'.tr.replaceFirst('{count}', '$savedInteretsCount'),
  //       const Color(0xFF2E7D32),
  //       3);

  //   _resetForm();
  //   LoadingService().hide();

  //   // Add all data to queue with correct priority
  //   try {
  //     await SyncQueue().syncNow();
  //     print(' All items added to sync queue');
  //   } catch (e) {
  //     print(' Error adding to queue: $e');
  //     // Data is already saved locally, will be picked up on next sync
  //   }
  // }

  Future<void> _saveProspect() async {
    LoadingService().show(context, message: 'saving_prospect'.tr);

    if (!_formKey.currentState!.validate()) {
      LoadingService().hide();
      return;
    }

    // Validate that a source is selected
    if (_selectedSource.isEmpty) {
      _showSnackBar('Please select a source'.tr, Colors.orange, 5);
      LoadingService().hide();
      return;
    }

    if (_interetsList.isEmpty) {
      _showSnackBar('add_specialty_warning'.tr, Colors.orange, 5);
      _toggleSection('interet');
      LoadingService().hide();
      return;
    }

    Source? src = await LocalStorage.instance.getLastRecSource();
    Fiche? f = await LocalStorage.instance.getLastRecFiche();

    print(
        "Last Src: ${src?.toLocalJson()}, and Last fiche: ${f?.toLocalJson()}");

    if (src == null || f == null) {
      _showSnackBar('missing_source_or_fiche'.tr, Colors.red, 5);
      LoadingService().hide();
      return;
    }

    final now = DateTime.now();

    // List to store saved specialites for queue
    final List<Specialite> savedSpecialites = [];
    final List<InteretFiliere> savedInterets = [];

    // Check if establishment already exists
    Etablissement? existingEts = await LocalStorage.instance
        .getEtablissementByNom(_selectedEtablissement);
    Etablissement ets;

    if (existingEts != null) {
      ets = existingEts;
      print('Using existing establishment: ${ets.nomEtablissement}');
    } else {
      ets = Etablissement(
          idEtablissement: 'ets_${DateTime.now().millisecondsSinceEpoch}',
          nomEtablissement: _selectedEtablissement,
          typeEtablissement:
              _getEtablissementTypeForNiveau(_selectedNiveauEtude),
          adresse: null,
          telephone: null,
          ville: null,
          region: null,
          createdAt: now,
          syncState: SyncState.pending);
      String resultKey =
          await LocalStorage.instance.addEtablissementIfNotExists(ets);
      _showSnackBar(
          resultKey.tr,
          resultKey.contains('success')
              ? const Color(0xFF2E7D32)
              : Colors.orange,
          3);
      if (!resultKey.contains('success')) {
        LoadingService().hide();
        return;
      }
    }

    // Check if class already exists for this establishment
    Classe? existingClasse = await LocalStorage.instance
        .getClasseByLibelleAndEts(_selectedClasse, ets.idEtablissement);
    Classe clse;

    if (existingClasse != null) {
      clse = existingClasse;
      print('Using existing class: ${clse.libelleClasse}');
    } else {
      clse = Classe(
          idClasse: 'classe_${DateTime.now().millisecondsSinceEpoch}',
          idEts: ets.idEtablissement,
          libelleClasse: _selectedClasse,
          createdAt: now,
          syncState: SyncState.pending);
      String resultKey = await LocalStorage.instance.saveClasse(clse);
      if (!resultKey.contains('success')) {
        _showSnackBar(resultKey.tr, Colors.orange, 3);
        LoadingService().hide();
        return;
      }
    }

    //  FIX: Create prospect with the Classe object linked
    final prospect = Prospect(
      idProspect: 'prospect_${DateTime.now().millisecondsSinceEpoch}',
      idfiche: f.idFiche,
      idClass: clse.idClasse, // Keep this for direct reference
      nomComplet: _nomCompletCtrl.text,
      telephone: _telephoneCtrl.text,
      email: _emailCtrl.text.isEmpty ? null : _emailCtrl.text,
      niveauEtude: _selectedNiveauEtude,
      adresse: _adresseCtrl.text.isEmpty ? null : _adresseCtrl.text,
      sexe: _selectedSexe,
      typeProspect: _selectedTypeProspect,
      source_infos: _selectedSource,
      commentaireGen: _commentaireCtrl.text,
      concerne: null,
      date_relance: _date_relance,
      createdAt: now,
      syncState: SyncState.pending,
      prospectStatus: ProspectStatus.nouveau,
    );

    //  CRITICAL: Link the Classe object to the prospect
    prospect.classe.value = clse;

    //  Also link the Fiche object
    prospect.fiche.value = f;

    print("Prospect data form \n: ${prospect.toLocalJson()}");
    print("Source info: ${prospect.source_infos}");
    print("Classe linked: ${prospect.classe.value?.libelleClasse}");
    print("Etablissement linked: ${clse.ets.value?.nomEtablissement}");

    //  Save prospect with its relationships
    String prospectResult = await LocalStorage.instance.saveProspect(prospect);

    if (!prospectResult.contains('success')) {
      _showSnackBar(prospectResult.tr, Colors.orange, 5);
      LoadingService().hide();
      return;
    }

    int savedInteretsCount = 0;
    for (var item in _interetsList) {
      // Check if specialite already exists
      Specialite? specialite =
          await LocalStorage.instance.getSpecialiteByNom(item['specialite']);
      String specialiteResult;

      if (specialite == null) {
        specialite = Specialite(
          idSpecialite:
              'specialite_${DateTime.now().millisecondsSinceEpoch}_$savedInteretsCount',
          libelleSpecialite: item['specialite'],
          description: null,
          createdAt: now,
          syncState: SyncState.pending,
        );
        specialiteResult =
            await LocalStorage.instance.addSpecialiteIfNotExists(specialite);
        if (!specialiteResult.contains('success')) {
          _showSnackBar(specialiteResult.tr, Colors.orange, 3);
          continue;
        }
      }

      savedSpecialites.add(specialite);

      // Check if interest already exists
      InteretFiliere? existingInteret = await LocalStorage.instance
          .getInteretByProspectAndSpecialite(
              prospect.idProspect, specialite.idSpecialite);

      if (existingInteret != null) {
        print('Interest already exists for this prospect and specialite');
        continue;
      }

      final interet = InteretFiliere(
        idInteret:
            'interet_${DateTime.now().millisecondsSinceEpoch}_${item['ordrePreference']}',
        idProspect: prospect.idProspect,
        idSpecialite: specialite.idSpecialite,
        ordrePreference: item['ordrePreference'] ?? 0,
        niveauInteret: item['niveauInteret'] ?? 0,
        commentaire: item['commentaire'] ?? '',
        createdAt: now,
        syncState: SyncState.pending,
      );

      //  Link relationships
      interet.prospect.value = prospect;
      interet.specialite.value = specialite;

      await LocalStorage.instance.saveInteret(interet);
      savedInterets.add(interet);
      savedInteretsCount++;
    }

    _showSnackBar(
        'prospect_saved'.tr.replaceFirst('{count}', '$savedInteretsCount'),
        const Color(0xFF2E7D32),
        3);

    _resetForm();
    LoadingService().hide();

    // Add all data to queue with correct priority
    try {
      await SyncQueue().syncNow();
      print(' All items added to sync queue');
    } catch (e) {
      print(' Error adding to queue: $e');
    }
  }

  void _resetForm() {
    _nomCompletCtrl.clear();
    _telephoneCtrl.clear();
    _emailCtrl.clear();
    _adresseCtrl.clear();
    _commentaireCtrl.clear();
    _concerneCtrl.clear();

    setState(() {
      _selectedSexe = '';
      _selectedTypeProspect = '';
      _selectedEtablissement = '';
      _selectedClasse = '';
      _selectedSource = '';
      _selectedNiveauEtude = '';
      _scoreInteret = 5;
      _interetsList.clear();
    });
    _navigateBack();
  }

  Future<void> _showExportOptions(Fiche fiche) async {
    await Future.delayed(const Duration(milliseconds: 500));
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: Colors.white,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text('fiche_saved_success'.tr,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32))),
            const SizedBox(height: 8),
            Text('export_fiche_question'.tr,
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const Divider(height: 24),
            ListTile(
              leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.picture_as_pdf,
                      color: Colors.red.shade700, size: 24)),
              title: Text('preview_pdf'.tr),
              subtitle: Text('preview_before_export'.tr),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () async {
                Navigator.pop(context);
                await ExportService.previewFichePDF(fiche);
              },
            ),
            ListTile(
              leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.picture_as_pdf,
                      color: Colors.red.shade700, size: 24)),
              title: Text('export_pdf'.tr),
              subtitle: Text('download_or_share'.tr),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () async {
                Navigator.pop(context);
                await _exportAndSharePDF(fiche);
              },
            ),
            ListTile(
              leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.table_chart,
                      color: Color(0xFF2E7D32), size: 24)),
              title: Text('preview_excel'.tr),
              subtitle: Text('preview_before_export'.tr),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () async {
                Navigator.pop(context);
                await ExportService.previewFicheExcel(fiche);
              },
            ),
            ListTile(
              leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.table_chart,
                      color: Color(0xFF2E7D32), size: 24)),
              title: Text('export_excel'.tr),
              subtitle: Text('download_or_share'.tr),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () async {
                Navigator.pop(context);
                await _exportAndShareExcel(fiche);
              },
            ),
            const SizedBox(height: 8),
            TextButton(
                onPressed: () => _navigateBack(),
                child: Text('later'.tr, style: const TextStyle(fontSize: 14))),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _exportAndSharePDF(Fiche fiche) async {
    _showLoadingDialog('generating_pdf'.tr);
    final file = await ExportService.exportFicheToPDF(fiche);
    if (mounted) Navigator.pop(context);
    if (file != null && mounted) {
      await ExportService.shareFile(file, file.path.split('/').last);
      _showSnackBar('pdf_export_success'.tr, const Color(0xFF2E7D32), 5);
      _navigateBack();
    } else {
      _showSnackBar('pdf_export_error'.tr, Colors.red, 5);
    }
  }

  Future<void> _exportAndShareExcel(Fiche fiche) async {
    _showLoadingDialog('generating_excel'.tr);
    final file = await ExportService.exportFicheToExcel(fiche);
    if (mounted) Navigator.pop(context);
    if (file != null && mounted) {
      await ExportService.shareFile(file, file.path.split('/').last);
      _showSnackBar('excel_export_success'.tr, const Color(0xFF2E7D32), 3);
      _navigateBack();
    } else {
      _showSnackBar('excel_export_error'.tr, Colors.red, 5);
    }
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message)
        ]),
      ),
    );
  }

  void _navigateBack() => Navigator.pop(context);
}
