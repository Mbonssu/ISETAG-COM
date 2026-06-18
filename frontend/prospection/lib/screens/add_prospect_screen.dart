// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use

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

  // Listes dynamiques
  final List<String> _etablissements = [
    'Lycée de Biyem-Assi',
    'Lycée Technique d\'Efouan',
    'Institut Confucius',
    'Lycée Général Leclerc',
    'Collège Vogt',
  ];

  final List<String> _classes = [
    'Terminale C',
    'Terminale D',
    'Terminale A4',
    'Terminale TI',
  ];

  final List<String> _specialites = [
    'Génie Logiciel',
    'Génie Civil',
    'Marketing',
    'Réseaux et Télécoms',
    'Comptabilité',
    'Ressources Humaines',
  ];

  final List<String> _sources = [
    'Réseaux sociaux',
    'Recommandation',
    'Site web',
    'Événement',
    'Prospection terrain',
    'Partenariat',
  ];

  final List<String> _sexeOptions = ['Masculin', 'Féminin'];
  final List<String> _typeProspectOptions = [
    'Étudiant',
    'Éleve',
    'Parent',
    'Enseignant',
    'Chef d\'établissement',
    'Autre'
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

  void init_form() {
    _nomCompletCtrl.text = 'Reo';
    _telephoneCtrl.text = '3212';
    _emailCtrl.text = 'e@gmail.com';
    _concerneCtrl.text = _typeProspectOptions[0];
    _adresseCtrl.text = 'Reo city';

    _commentaireCtrl.text = 'Right';
    _selectedEtablissement = _etablissements[0];
    _selectedClasse = _classes[0];
    _selectedNiveauEtude = _niveauEtudeOptions[0];
    _relanceCtrl.text = '';
    _selectedSexe = _sexeOptions[0];
    _selectedTypeProspect = _typeProspectOptions[0];
    _selectedSource = _sources[0];
    _selectedNiveauEtude = _niveauEtudeOptions[0];
    _newOrdrePreferenceCtrl.text = "1";
    _newNiveauInteretCtrl.text = "1";
    _newCommentaireInteretCtrl.text = "Interest comment";

    if (_specialites.isNotEmpty) {
      _selectedSpecialiteForInteret = _specialites[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBackground(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
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
                          _buildSearchableDropdownWithAdd(
                            value: _selectedEtablissement,
                            label: 'establishment'.tr,
                            hint: 'select_or_add'.tr,
                            icon: Icons.school_outlined,
                            items: _etablissements,
                            onChanged: (value) {
                              setState(() {
                                _selectedEtablissement = value!;
                              });
                            },
                            onAdd: (newValue) async {
                              final newEtablissement = Etablissement(
                                idEtablissement:
                                    'ets_${DateTime.now().millisecondsSinceEpoch}',
                                nomEtablissement: newValue,
                                createdAt: DateTime.now(),
                                syncState: SyncState.pending,
                              );

                              String resultKey = await LocalStorage.instance
                                  .saveEtablissement(newEtablissement);

                              if (resultKey.contains('success')) {
                                setState(() {
                                  _etablissements.add(newValue);
                                  _selectedEtablissement = newValue;
                                });
                                _showSnackBar(
                                    resultKey.tr, const Color(0xFF2E7D32), 3);
                              } else {
                                setState(() {
                                  if (!_etablissements.contains(newValue)) {
                                    _etablissements.add(newValue);
                                  }
                                  _selectedEtablissement = newValue;
                                });
                                _showSnackBar(resultKey.tr, Colors.orange, 3);
                              }
                            },
                          ),
                          if (_selectedNiveauEtude == 'Baccalauréat') ...[
                            const SizedBox(height: 12),
                            _buildSearchableDropdownWithAdd(
                              value: _selectedClasse,
                              label: 'class'.tr,
                              hint: 'select_or_add'.tr,
                              icon: Icons.class_outlined,
                              items: _classes,
                              onChanged: (value) {
                                setState(() {
                                  _selectedClasse = value!;
                                });
                              },
                              onAdd: (newValue) async {
                                if (_selectedEtablissement.isEmpty) {
                                  _showSnackBar('select_establishment_first'.tr,
                                      Colors.orange, 3);
                                  return;
                                }

                                Etablissement? existingEts = await LocalStorage
                                    .instance
                                    .getEtablissementByNom(
                                        _selectedEtablissement);

                                String etsId;
                                if (existingEts != null) {
                                  etsId = existingEts.idEtablissement;
                                } else {
                                  final newEts = Etablissement(
                                    idEtablissement:
                                        'ets_${DateTime.now().millisecondsSinceEpoch}',
                                    nomEtablissement: _selectedEtablissement,
                                    createdAt: DateTime.now(),
                                    syncState: SyncState.pending
                                  );
                                  await LocalStorage.instance
                                      .saveEtablissement(newEts);
                                  etsId = newEts.idEtablissement;
                                }

                                final newClasse = Classe(
                                  idClasse:
                                      'classe_${DateTime.now().millisecondsSinceEpoch}',
                                  idEts: etsId,
                                  libelleClasse: newValue,
                                  createdAt: DateTime.now(),
                                  syncState: SyncState.pending
                                );

                                String resultKey = await LocalStorage.instance
                                    .saveClasse(newClasse);

                                if (resultKey.contains('success')) {
                                  setState(() {
                                    _classes.add(newValue);
                                    _selectedClasse = newValue;
                                  });
                                  _showSnackBar(
                                      resultKey.tr, const Color(0xFF2E7D32), 3);
                                } else {
                                  setState(() {
                                    if (!_classes.contains(newValue)) {
                                      _classes.add(newValue);
                                    }
                                    _selectedClasse = newValue;
                                  });
                                  _showSnackBar(resultKey.tr, Colors.orange, 3);
                                }
                              },
                            ),
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
                          _buildSearchableDropdownWithAdd(
                            value: _selectedSource,
                            label: 'source'.tr,
                            hint: 'select_or_add'.tr,
                            icon: Icons.source_outlined,
                            items: _sources,
                            onChanged: (value) {
                              setState(() {
                                _selectedSource = value!;
                              });
                            },
                            onAdd: (newValue) {
                              setState(() {
                                _sources.add(newValue);
                                _selectedSource = newValue;
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

                      // Boutons d'action
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                side: BorderSide(color: Colors.grey.shade400),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
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

  Widget _buildInteretsListSection() {
    final List<String> availableSpecialites = _specialites.where((spec) {
      return !_interetsList.any((interet) => interet['specialite'] == spec);
    }).toList();

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
                _buildSpecialiteDropdownForInteret(availableSpecialites),
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

  // Widget _buildSpecialiteDropdownForInteret(List<String> availableSpecialites) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.grey.shade300),
  //     ),
  //     child: DropdownButtonFormField<String>(
  //       value: _selectedSpecialiteForInteret != null && availableSpecialites.contains(_selectedSpecialiteForInteret)
  //           ? _selectedSpecialiteForInteret
  //           : null,
  //       isExpanded: true,
  //       hint: Text('select_specialty'.tr, style: const TextStyle(fontSize: 13)),
  //       decoration: InputDecoration(
  //         labelText: 'specialty_field'.tr,
  //         prefixIcon: const Icon(Icons.school_outlined,
  //             color: Color(0xFF2E7D32), size: 18),
  //         border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(8),
  //             borderSide: BorderSide.none),
  //         contentPadding:
  //             const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //         labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
  //       ),
  //       items: [
  //         DropdownMenuItem<String>(
  //           value: '__add_new__',
  //           child: Row(children: [
  //             const Icon(Icons.add_circle, color: Color(0xFF2E7D32), size: 16),
  //             const SizedBox(width: 8),
  //             Text('add_new_specialty'.tr, style: const TextStyle(fontSize: 13, color: Color(0xFF2E7D32)))
  //           ]),
  //         ),
  //         const DropdownMenuItem<String>(
  //             value: '__separator__', enabled: false, child: Divider()),
  //         ...availableSpecialites.map((specialite) => DropdownMenuItem<String>(
  //             value: specialite,
  //             child: Text(specialite, style: const TextStyle(fontSize: 13)))),
  //       ],
  //       onChanged: (value) {
  //         if (value == '__add_new__') {
  //           _showAddNewSpecialiteDialog();
  //         } else if (value != '__separator__') {
  //           setState(() => _selectedSpecialiteForInteret = value);
  //         }
  //       },
  //     ),
  //   );
  // }
  Widget _buildSpecialiteDropdownForInteret(List<String> availableSpecialites) {
    // Ensure the selected value is valid
    String? validValue;
    if (_selectedSpecialiteForInteret != null &&
        availableSpecialites.contains(_selectedSpecialiteForInteret)) {
      validValue = _selectedSpecialiteForInteret;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonFormField<String>(
        key: ValueKey(validValue ?? 'dropdown_${availableSpecialites.length}'),
        value: validValue,
        isExpanded: true,
        hint: Text('select_specialty'.tr, style: const TextStyle(fontSize: 13)),
        decoration: InputDecoration(
          labelText: 'specialty_field'.tr,
          prefixIcon: const Icon(Icons.school_outlined,
              color: Color(0xFF2E7D32), size: 18),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        items: [
          const DropdownMenuItem<String>(
            value: '__add_new__',
            child: Row(children: [
              Icon(Icons.add_circle, color: Color(0xFF2E7D32), size: 16),
              SizedBox(width: 8),
              Text('add_new_specialty',
                  style: TextStyle(fontSize: 13, color: Color(0xFF2E7D32)))
            ]),
          ),
          const DropdownMenuItem<String>(
            value: '__separator__',
            enabled: false,
            child: Divider(),
          ),
          ...availableSpecialites.map((specialite) => DropdownMenuItem<String>(
                value: specialite,
                child: Text(specialite, style: const TextStyle(fontSize: 13)),
              )),
        ],
        onChanged: (value) {
          if (value == '__add_new__') {
            _showAddNewSpecialiteDialog();
          } else if (value != '__separator__') {
            setState(() {
              _selectedSpecialiteForInteret = value;
            });
          }
        },
      ),
    );
  }

  // void _showAddNewSpecialiteDialog() {
  //   TextEditingController newSpecialiteCtrl = TextEditingController();
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       title: Text('new_specialty'.tr),
  //       content: TextField(
  //         controller: newSpecialiteCtrl,
  //         autofocus: true,
  //         decoration: InputDecoration(
  //             hintText: 'specialty_name'.tr,
  //             border:
  //                 OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
  //       ),
  //       actions: [
  //         TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text('cancel'.tr)),
  //         ElevatedButton(
  //           onPressed: () async {
  //             if (newSpecialiteCtrl.text.isNotEmpty) {
  //               final newSpecialite = Specialite(
  //                 idSpecialite:
  //                     'specialite_${DateTime.now().millisecondsSinceEpoch}',
  //                 libelleSpecialite: newSpecialiteCtrl.text,
  //                 description: null,
  //                 createdAt: DateTime.now(),
  //               );

  //               String resultKey =
  //                   await LocalStorage.instance.saveSpecialite(newSpecialite);

  //               if (resultKey.contains('success')) {
  //                 setState(() {
  //                   _specialites.add(newSpecialiteCtrl.text);
  //                   _selectedSpecialiteForInteret = newSpecialiteCtrl.text;
  //                 });
  //                 _showSnackBar(resultKey.tr, const Color(0xFF2E7D32), 3);
  //               } else {
  //                 setState(() {
  //                   if (!_specialites.contains(newSpecialiteCtrl.text)) {
  //                     _specialites.add(newSpecialiteCtrl.text);
  //                   }
  //                   _selectedSpecialiteForInteret = newSpecialiteCtrl.text;
  //                 });
  //                 _showSnackBar(resultKey.tr, Colors.orange, 3);
  //               }
  //               Navigator.pop(context);
  //             }
  //           },
  //           style: ElevatedButton.styleFrom(
  //               backgroundColor: const Color(0xFF2E7D32)),
  //           child: Text('add'.tr),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showAddNewSpecialiteDialog() {
    TextEditingController newSpecialiteCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('new_specialty'.tr),
        content: TextField(
          controller: newSpecialiteCtrl,
          autofocus: true,
          decoration: InputDecoration(
              hintText: 'specialty_name'.tr,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr)),
          ElevatedButton(
            onPressed: () async {
              if (newSpecialiteCtrl.text.isNotEmpty) {
                final newSpecialite = Specialite(
                    idSpecialite:
                        'specialite_${DateTime.now().millisecondsSinceEpoch}',
                    libelleSpecialite: newSpecialiteCtrl.text,
                    description: null,
                    createdAt: DateTime.now(),
                    syncState: SyncState.pending);

                String resultKey =
                    await LocalStorage.instance.saveSpecialite(newSpecialite);

                // Close dialog first
                Navigator.pop(context);

                // Then update state
                if (resultKey.contains('success')) {
                  setState(() {
                    _specialites.add(newSpecialiteCtrl.text);
                    _selectedSpecialiteForInteret = newSpecialiteCtrl.text;
                  });
                  _showSnackBar(resultKey.tr, const Color(0xFF2E7D32), 3);
                } else {
                  setState(() {
                    if (!_specialites.contains(newSpecialiteCtrl.text)) {
                      _specialites.add(newSpecialiteCtrl.text);
                    }
                    _selectedSpecialiteForInteret = newSpecialiteCtrl.text;
                  });
                  _showSnackBar(resultKey.tr, Colors.orange, 3);
                }
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white),
            child: Text('add'.tr),
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

  Widget _buildSearchableDropdownWithAdd({
    required String? value,
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
    required Function(String) onAdd,
  }) {
    return GestureDetector(
      onTap: () => _showSearchableDialog(items, label, onChanged, onAdd),
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

  void _showSearchableDialog(List<String> items, String title,
      Function(String?) onChanged, Function(String) onAdd) {
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
                const Divider(),
                ListTile(
                  leading:
                      const Icon(Icons.add_circle, color: Color(0xFF2E7D32)),
                  title: Text('add_new'.tr),
                  subtitle: Text('add_custom_option'.tr),
                  onTap: () {
                    Navigator.pop(context);
                    _showAddNewItemDialog(title, onAdd);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  void _showAddNewItemDialog(String title, Function(String) onAdd) {
    TextEditingController newItemController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('${'add_new'.tr} $title'),
        content: TextField(
          controller: newItemController,
          decoration: InputDecoration(
              hintText: 'name_of'.tr.replaceFirst('{item}', title),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr)),
          ElevatedButton(
            onPressed: () {
              if (newItemController.text.isNotEmpty) {
                onAdd(newItemController.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32)),
            child: Text('add'.tr),
          ),
        ],
      ),
    );
  }

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

  // Future<void> _saveProspect() async {
  //   LoadingService().show(context, message: 'saving_prospect'.tr);

  //   if (!_formKey.currentState!.validate()) {
  //     LoadingService().hide();
  //     return;
  //   }

  //   if (_interetsList.isEmpty) {
  //     _showSnackBar('add_specialty_warning'.tr, Colors.orange, 5);
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

  //   // Check if establishment already exists
  //   Etablissement? existingEts = await LocalStorage.instance
  //       .getEtablissementByNom(_selectedEtablissement);
  //   Etablissement ets;

  //   if (existingEts != null) {
  //     ets = existingEts;
  //     print('Using existing establishment: ${ets.nomEtablissement}');
  //   } else {
  //     ets = Etablissement(
  //       idEtablissement: DateTime.now().millisecondsSinceEpoch.toString(),
  //       nomEtablissement: _selectedEtablissement,
  //       createdAt: now,
  //     );
  //     String resultKey = await LocalStorage.instance.saveEtablissement(ets);
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
  //       idClasse: DateTime.now().millisecondsSinceEpoch.toString(),
  //       idEts: ets.idEtablissement,
  //       libelleClasse: _selectedClasse,
  //       createdAt: now,
  //     );
  //     String resultKey = await LocalStorage.instance.saveClasse(clse);
  //     if (!resultKey.contains('success')) {
  //       _showSnackBar(resultKey.tr, Colors.orange, 3);
  //       LoadingService().hide();
  //       return;
  //     }
  //   }

  //   // Check if prospect already exists
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
  //     commentaireGen: _commentaireCtrl.text,
  //     date_relance: _date_relance,
  //     createdAt: now,
  //   );

  //   print("Prospect data form \n: ${prospect.toLocalJson()}");
  //   String prospectResult = await LocalStorage.instance.saveProspect(prospect);

  //   if (!prospectResult.contains('success')) {
  //     _showSnackBar(prospectResult.tr, Colors.orange, 5);
  //     LoadingService().hide();
  //     return;
  //   }

  //   int savedInterets = 0;
  //   for (var item in _interetsList) {
  //     // Check if specialite already exists
  //     Specialite? specialite =
  //         await LocalStorage.instance.getSpecialiteByNom(item['specialite']);
  //     String specialiteResult;

  //     if (specialite == null) {
  //       specialite = Specialite(
  //         idSpecialite:
  //             'specialite_${DateTime.now().millisecondsSinceEpoch}_$savedInterets',
  //         libelleSpecialite: item['specialite'],
  //         description: null,
  //         createdAt: now,
  //       );
  //       specialiteResult =
  //           await LocalStorage.instance.saveSpecialite(specialite);
  //       if (!specialiteResult.contains('success')) {
  //         _showSnackBar(specialiteResult.tr, Colors.orange, 3);
  //         continue;
  //       }
  //     }

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
  //     );

  //     interet.prospect.value = prospect;
  //     interet.specialite.value = specialite;

  //     await LocalStorage.instance.saveInteret(interet);
  //     savedInterets++;
  //   }

  //   _showSnackBar('prospect_saved'.tr.replaceFirst('{count}', '$savedInterets'),
  //       const Color(0xFF2E7D32), 3);

  //   _resetForm();
  //   LoadingService().hide();

  //   // 9.1 Add all data to queue with correct priority
  //   try {
  //     await SyncQueue().addCompleteProspect(
  //       prospect: prospect,
  //       fiche: f,
  //       classe: clse,
  //       etablissement: ets,
  //       source: src,
  //       specialites: savedSpecialites,
  //       interets: savedInterets,
  //     );
  //     print('✅ All items added to sync queue');
  //   } catch (e) {
  //     print('⚠️ Error adding to queue: $e');
  //     // Data is already saved locally, will be picked up on next sync
  //   }
  // }

  Future<void> _saveProspect() async {
    LoadingService().show(context, message: 'saving_prospect'.tr);

    if (!_formKey.currentState!.validate()) {
      LoadingService().hide();
      return;
    }

    if (_interetsList.isEmpty) {
      _showSnackBar('add_specialty_warning'.tr, Colors.orange, 5);
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

    //  List to store saved specialites for queue
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
          idEtablissement: DateTime.now().millisecondsSinceEpoch.toString(),
          nomEtablissement: _selectedEtablissement,
          createdAt: now,
          syncState: SyncState.pending);
      String resultKey = await LocalStorage.instance.saveEtablissement(ets);
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
          idClasse: DateTime.now().millisecondsSinceEpoch.toString(),
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

    // Check if prospect already exists
    final prospect = Prospect(
        idProspect: 'prospect_${DateTime.now().millisecondsSinceEpoch}',
        idfiche: f.idFiche,
        idClass: clse.idClasse,
        nomComplet: _nomCompletCtrl.text,
        telephone: _telephoneCtrl.text,
        email: _emailCtrl.text.isEmpty ? null : _emailCtrl.text,
        niveauEtude: _selectedNiveauEtude,
        adresse: _adresseCtrl.text.isEmpty ? null : _adresseCtrl.text,
        sexe: _selectedSexe,
        typeProspect: _selectedTypeProspect,
        commentaireGen: _commentaireCtrl.text,
        date_relance: _date_relance,
        createdAt: now,
        syncState: SyncState.pending);

    print("Prospect data form \n: ${prospect.toLocalJson()}");
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
            await LocalStorage.instance.saveSpecialite(specialite);
        if (!specialiteResult.contains('success')) {
          _showSnackBar(specialiteResult.tr, Colors.orange, 3);
          continue;
        }
      }

      //  Add to saved list for queue
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
      // await SyncQueue().addCompleteProspect(
      //   prospect: prospect,
      //   fiche: f,
      //   classe: clse,
      //   etablissement: ets,
      //   source: src,
      //   specialites: savedSpecialites,
      //   interets: savedInterets,
      // );

       await SyncQueue().syncNow();
      print('✅ All items added to sync queue');
    } catch (e) {
      print('⚠️ Error adding to queue: $e');
      // Data is already saved locally, will be picked up on next sync
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
