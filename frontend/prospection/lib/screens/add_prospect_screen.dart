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
    'academiques': true,
    'interet': true,
    'commentaires': true,
    'relance': true,
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

  // Init the form with data

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

    // Initialiser _selectedSpecialiteForInteret avec la première spécialité
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
                        title: 'Informations personnelles',
                        icon: Icons.person_outline,
                        isExpanded: _sectionsExpanded['personnelles']!,
                        onToggle: () => _toggleSection('personnelles'),
                        children: [
                          _buildTextField(
                            controller: _nomCompletCtrl,
                            label: 'Nom complet',
                            hint: 'Entrez le nom complet',
                            icon: Icons.person_outline,
                            required: true,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _telephoneCtrl,
                            label: 'Téléphone',
                            hint: '6XXXXXXXX',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            required: true,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _emailCtrl,
                            label: 'Email',
                            hint: 'exemple@email.com',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),
                          // Sexe - sur sa propre ligne
                          _buildSearchableDropdown(
                            value: _selectedSexe,
                            label: 'Sexe',
                            hint: 'Sélectionnez',
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
                            label: 'Niveau d\'étude',
                            hint: 'Sélectionnez',
                            icon: Icons.school_outlined,
                            items: _niveauEtudeOptions,
                            onChanged: (value) {
                              setState(() {
                                _selectedNiveauEtude = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          // Type prospect - sur sa propre ligne
                          _buildSearchableDropdown(
                            value: _selectedTypeProspect,
                            label: 'Qui est ce prospect ?',
                            hint: 'Sélectionnez',
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
                            label: 'Adresse',
                            hint: 'Adresse complète',
                            icon: Icons.location_on_outlined,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Section 2: Informations académiques
                      _buildExpandableSection(
                        title: 'Informations académiques',
                        icon: Icons.business_outlined,
                        isExpanded: _sectionsExpanded['academiques']!,
                        onToggle: () => _toggleSection('academiques'),
                        children: [
                          _buildSearchableDropdownWithAdd(
                            value: _selectedEtablissement,
                            label: 'Établissement',
                            hint: 'Sélectionnez ou ajoutez',
                            icon: Icons.school_outlined,
                            items: _etablissements,
                            onChanged: (value) {
                              setState(() {
                                _selectedEtablissement = value!;
                              });
                            },
                            onAdd: (newValue) {
                              setState(() {
                                _etablissements.add(newValue);
                                _selectedEtablissement = newValue;
                              });
                            },
                          ),
                          if (_selectedNiveauEtude == 'Baccalauréat') ...[
                            const SizedBox(height: 12),
                            _buildSearchableDropdownWithAdd(
                              value: _selectedClasse,
                              label: 'Classe',
                              hint: 'Sélectionnez ou ajoutez',
                              icon: Icons.class_outlined,
                              items: _classes,
                              onChanged: (value) {
                                setState(() {
                                  _selectedClasse = value!;
                                });
                              },
                              onAdd: (newValue) {
                                setState(() {
                                  _classes.add(newValue);
                                  _selectedClasse = newValue;
                                });
                              },
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Section 3: Intérêt et provenance
                      _buildExpandableSection(
                        title: 'Intérêt et provenance',
                        icon: Icons.insights_outlined,
                        isExpanded: _sectionsExpanded['interet']!,
                        onToggle: () => _toggleSection('interet'),
                        children: [
                          _buildSearchableDropdownWithAdd(
                            value: _selectedSource,
                            label: 'Source',
                            hint: 'Sélectionnez ou ajoutez',
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
                          // const SizedBox(height: 12),
                          // _buildScoreSlider(),
                          const SizedBox(height: 12),
                          _buildInteretsListSection(),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Section 4: Commentaires
                      _buildExpandableSection(
                          title: 'Commentaires',
                          icon: Icons.comment_outlined,
                          isExpanded: _sectionsExpanded['commentaires']!,
                          onToggle: () => _toggleSection('commentaires'),
                          children: [
                            _buildTextField(
                              controller: _commentaireCtrl,
                              label: 'Commentaire général',
                              hint: 'Ajoutez des observations...',
                              icon: Icons.comment_outlined,
                              maxLines: 3,
                            ),
                          ]),

                      const SizedBox(height: 16),

                      _buildExpandableSection(
                          title: 'Programmé une relance',
                          icon: Icons.schedule_rounded,
                          isExpanded: _sectionsExpanded['relance']!,
                          onToggle: () => _toggleSection('relance'),
                          children: [
                            _buildDateTimeField(
                                controller: _relanceCtrl,
                                label: 'Date de relance',
                                hint: 'Programmé une relance'),
                          ]),
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
                              child: const Text('Annuler',
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _saveProspect();
                                // _navigateBack();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Enregistrer',
                                  style: TextStyle(
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
              offset: const Offset(0, 2))
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
                                color: Color(0xFF1B5E20)))),
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
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Filières sélectionnées :',
                  style: TextStyle(
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
                      'Ordre: ${interet['ordrePreference']} | Niveau: ${interet['niveauInteret']}/10',
                      style: const TextStyle(fontSize: 11)),
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
                const Text('Ajouter une filière d\'intérêt',
                    style: TextStyle(
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
                        label: 'Ordre',
                        hint: '1, 2, 3...',
                        icon: Icons.format_list_numbered,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSmallTextField(
                        controller: _newNiveauInteretCtrl,
                        label: 'Niveau (1-10)',
                        hint: '1 à 10',
                        icon: Icons.star_outline,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSmallTextField(
                  controller: _newCommentaireInteretCtrl,
                  label: 'Commentaire',
                  hint: 'Précisez l\'intérêt...',
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
                        label: const Text('Effacer'),
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
                        label: const Text('Ajouter'),
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

  Widget _buildSpecialiteDropdownForInteret(List<String> availableSpecialites) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedSpecialiteForInteret,
        isExpanded: true,
        hint: const Text('Sélectionnez une filière',
            style: TextStyle(fontSize: 13)),
        decoration: InputDecoration(
          labelText: 'Filière / Spécialité',
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
              Text('Ajouter une nouvelle filière',
                  style: TextStyle(fontSize: 13, color: Color(0xFF2E7D32)))
            ]),
          ),
          const DropdownMenuItem<String>(
              value: '__separator__', enabled: false, child: Divider()),
          ...availableSpecialites.map((specialite) => DropdownMenuItem<String>(
              value: specialite,
              child: Text(specialite, style: const TextStyle(fontSize: 13)))),
        ],
        onChanged: (value) {
          if (value == '__add_new__') {
            _showAddNewSpecialiteDialog();
          } else if (value != '__separator__') {
            setState(() => _selectedSpecialiteForInteret = value);
          }
        },
      ),
    );
  }

  void _showAddNewSpecialiteDialog() {
    TextEditingController newSpecialiteCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Nouvelle filière'),
        content: TextField(
          controller: newSpecialiteCtrl,
          autofocus: true,
          decoration: InputDecoration(
              hintText: 'Nom de la filière',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              if (newSpecialiteCtrl.text.isNotEmpty) {
                setState(() {
                  _specialites.add(newSpecialiteCtrl.text);
                  _selectedSpecialiteForInteret = newSpecialiteCtrl.text;
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32)),
            child: const Text('Ajouter'),
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
      _showSnackBar('Veuillez sélectionner une filière', Colors.orange);
      return;
    }
    if (ordrePreference == null || ordrePreference < 1) {
      _showSnackBar('Ordre de préférence invalide', Colors.orange);
      return;
    }
    if (niveauInteret == null || niveauInteret < 1 || niveauInteret > 10) {
      _showSnackBar('Niveau d\'intérêt invalide (1-10)', Colors.orange);
      return;
    }
    if (_interetsList.any((i) => i['ordrePreference'] == ordrePreference)) {
      _showSnackBar('Cet ordre de préférence existe déjà', Colors.orange);
      return;
    }
    if (_interetsList.any((i) => i['specialite'] == specialite)) {
      _showSnackBar('Cette filière a déjà été ajoutée', Colors.orange);
      return;
    }

    setState(() {
      _interetsList.add({
        'specialite': specialite,
        'ordrePreference': ordrePreference,
        'niveauInteret': niveauInteret,
        'commentaire': _newCommentaireInteretCtrl.text.trim(),
      });
      // this commeted lines of code enable to order interests by ordrePreference (usefull)
      // _interetsList
      //     .sort((a, b) => a['ordrePreference'].compareTo(b['ordrePreference']));
      // for (int i = 0; i < _interetsList.length; i++) {
      //   _interetsList[i]['ordrePreference'] = i + 1;
      // }
      _clearInteretForm();
    });
    _showSnackBar('Filière ajoutée avec succès', const Color(0xFF2E7D32));
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
        title: Text('Modifier - ${interet['specialite']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallTextField(
                controller: ordreCtrl,
                label: 'Ordre',
                hint: '1, 2, 3...',
                icon: Icons.format_list_numbered),
            const SizedBox(height: 12),
            _buildSmallTextField(
                controller: niveauCtrl,
                label: 'Niveau',
                hint: '1 à 10',
                icon: Icons.star_outline),
            const SizedBox(height: 12),
            _buildSmallTextField(
                controller: commentaireCtrl,
                label: 'Commentaire',
                hint: 'Précisez...',
                icon: Icons.comment_outlined,
                maxLines: 2),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
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
                _showSnackBar('Modifié avec succès', const Color(0xFF2E7D32));
              } else {
                _showSnackBar('Valeurs invalides', Colors.orange);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32)),
            child: const Text(
              'Enregistrer',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: const Duration(seconds: 2)),
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
            const Expanded(
              child: Text(
                'Nouveau prospect',
                style: TextStyle(
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

  // Champ de texte avec bordure verte
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
          // hintStyle: const TextStyle(color: Colors.black),
          prefixIcon: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelStyle: const TextStyle(color: Colors.grey),
        ),
        validator: required
            ? (value) =>
                value == null || value.isEmpty ? 'Ce champ est requis' : null
            : null,
      ),
    );
  }

  // Dropdown avec bordure verte
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

  // Dropdown simple avec bordure verte
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
                Text('Sélectionner $title',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Rechercher...',
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
                      ? const Center(
                          child: Padding(
                              padding: EdgeInsets.all(32),
                              child: Text('Aucun résultat trouvé')))
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
                  title: const Text('Ajouter nouveau'),
                  subtitle: const Text('Ajouter une option personnalisée'),
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
                Text('Sélectionner $title',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Rechercher...',
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
                      ? const Center(
                          child: Padding(
                              padding: EdgeInsets.all(32),
                              child: Text('Aucun résultat trouvé')))
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
        title: Text('Ajouter $title'),
        content: TextField(
          controller: newItemController,
          decoration: InputDecoration(
              hintText: 'Nom du $title',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              if (newItemController.text.isNotEmpty) {
                onAdd(newItemController.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32)),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  // Widget _buildScoreSlider() {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.5)),
  //       boxShadow: [
  //         BoxShadow(
  //             color: Colors.black.withOpacity(0.03),
  //             blurRadius: 8,
  //             offset: const Offset(0, 2))
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             const Icon(Icons.star_outline,
  //                 color: Color(0xFFF57F17), size: 20),
  //             const SizedBox(width: 8),
  //             const Text('Score d\'intérêt',
  //                 style: TextStyle(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.black87)),
  //             const Spacer(),
  //             Container(
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //               decoration: BoxDecoration(
  //                   color: const Color(0xFFF57F17).withOpacity(0.1),
  //                   borderRadius: BorderRadius.circular(20)),
  //               child: Text('$_scoreInteret / 10',
  //                   style: const TextStyle(
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w700,
  //                       color: Color(0xFFF57F17))),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 12),
  //         Row(
  //           children: [
  //             const Text('0',
  //                 style: TextStyle(fontSize: 12, color: Colors.grey)),
  //             Expanded(
  //               child: Slider(
  //                 value: _scoreInteret.toDouble(),
  //                 min: 0,
  //                 max: 10,
  //                 divisions: 10,
  //                 activeColor: const Color(0xFFF57F17),
  //                 inactiveColor: Colors.grey.shade300,
  //                 onChanged: (value) =>
  //                     setState(() => _scoreInteret = value.round()),
  //               ),
  //             ),
  //             const Text('10',
  //                 style: TextStyle(fontSize: 12, color: Colors.grey)),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  // DateTime Picker

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
              suffixIcon:
                  const Icon(Icons.access_time, color: green, size: 16),
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

  Future<void> _saveProspect() async {
    if (_formKey.currentState!.validate()) {
      if (_interetsList.isEmpty) {
        _showSnackBar(
            'Veuillez ajouter au moins une filière d\'intérêt', Colors.orange);
        return;
      }

      // Get Last Source and fiche Recorded

      Source? src = await LocalStorage.instance.getLastRecSource();
      Fiche? f = await LocalStorage.instance.getLastRecFiche();
      // f!.idSrc = src!.idSource; //Just for secure mesure (Maybe)

      print(
          "Last Src: ${src?.toLocalJson()}, and Last fiche: ${f?.toLocalJson()}");
      // 2. Sauvegarder l'Établissement (si nécessaire)
      final ets = Etablissement(
        idEtablissement: DateTime.now().millisecondsSinceEpoch.toString(),
        nomEtablissement: _selectedEtablissement,
        createdAt: now,
      );
      await LocalStorage.instance.saveEtablissement(ets);

      // 3. Sauvegarder la Classe (si nécessaire)
      final clse = Classe(
        idClasse: DateTime.now().millisecondsSinceEpoch.toString(),
        idEts: ets.idEtablissement,
        libelleClasse: _selectedClasse,
        createdAt: now,
      );
      await LocalStorage.instance.saveClasse(clse);

      // 5. Créer et sauvegarder le Prospect
      final prospect = Prospect(
        idProspect: 'prospect_${DateTime.now().millisecondsSinceEpoch}',
        idfiche: f!.idFiche,
        idClass: clse.idClasse,
        // idEtablissement: ets.idEtablissement,
        // idSource: src.idSource,
        nomComplet: _nomCompletCtrl.text,
        telephone: _telephoneCtrl.text,
        email: _emailCtrl.text.isEmpty ? null : _emailCtrl.text,
        niveauEtude: _selectedNiveauEtude,
        adresse: _adresseCtrl.text.isEmpty ? null : _adresseCtrl.text,
        sexe: _selectedSexe,
        typeProspect: _selectedTypeProspect,
        commentaireGen: _commentaireCtrl.text,
        date_relance: _date_relance!,
        createdAt: now,
      );
      print("Prospect data form \n: ${prospect.toLocalJson()}");
      await LocalStorage.instance
          .saveProspect(prospect); // ← Sauvegarde immédiate

      // 6. Créer et sauvegarder les Intérêts avec leurs spécialités
      for (var item in _interetsList) {
        // Vérifier si la spécialité existe déjà
        Specialite? specialite =
            await LocalStorage.instance.getSpecialiteByNom(item['specialite']);

        if (specialite == null) {
          // Créer une nouvelle spécialité
          specialite = Specialite(
            idSpecialite:
                'specialite_${DateTime.now().millisecondsSinceEpoch}', //_${item['ordrePreference']}
            libelleSpecialite: item['specialite'],
            description: null,
            createdAt: now,
          );
          await LocalStorage.instance.saveSpecialite(specialite);
        }

        // Créer l'intérêt
        final interet = InteretFiliere(
          idInteret:
              'interet_${DateTime.now().millisecondsSinceEpoch}_${item['ordrePreference']}',
          idProspect: prospect.idProspect, // ← Maintenant disponible
          idSpecialite: specialite.idSpecialite, // ← Maintenant disponible
          ordrePreference: item['ordrePreference'],
          niveauInteret: item['niveauInteret'],
          commentaire: item['commentaire'],
          createdAt: now,
        );

        // Établir les relations APRÈS que les objets sont sauvegardés
        interet.prospect.value = prospect;
        interet.specialite.value = specialite;

        // Sauvegarder l'intérêt
        await LocalStorage.instance.saveInteret(interet);
      }

      // 7. Vérifier que tout est bien sauvegardé (sans utiliser getAllProspectsWithInterests)
      // final allProspects = await LocalStorage.instance.getAllProspects();

      // print('=== PROSPECTS SAUVEGARDÉS ===');
      // print('Nombre total de prospects: ${allProspects.length}');
      // // print('Nombre total de prospects: ${allProspects}');

      // for (var p in allProspects) {
      //   print('Prospect: ${p.nomComplet}');

      //   // Récupérer les intérêts manuellement
      //   final interets =
      //       await LocalStorage.instance.getInteretsByProspect(p.idProspect);
      //   print('  - Nombre d\'intérêts: ${interets.length}');
      //   for (var interet in interets) {
      //     final specialite = await LocalStorage.instance
      //         .getSpecialiteById(interet.specialite.value!.idSpecialite);
      //     // p.AllSpec.add(specialite!);
      //     print(
      //         '    * ${specialite?.libelleSpecialite} (Ordre: ${interet.ordrePreference}, Niveau: ${interet.niveauInteret}/10)');
      //   }
      //   // p.interets.;
      //   // print('   - Prospect Data: ${await LocalStorage.instance.getProspectInterestsWithDetails(p.idProspect)}');
      //   print(
      //       '   - Prospect Data: ${await LocalStorage.instance.getAllProspectsWithInterests()}');
      //   print('');
      // }

      // print('Prospect Data: ${await LocalStorage.instance.getAllProspectsWithInterests()}');

      _showSnackBar(
          'Prospect enregistré avec ${_interetsList.length} filière(s)',
          const Color(0xFF2E7D32));

      // Réinitialiser le formulaire
      _resetForm();
    }
  }

  void _resetForm() {
    // Réinitialiser les controllers
    _nomCompletCtrl.clear();
    _telephoneCtrl.clear();
    _emailCtrl.clear();
    _adresseCtrl.clear();
    _commentaireCtrl.clear();
    _concerneCtrl.clear();

    // Réinitialiser les sélections
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
            const Text('Fiche enregistrée avec succès !',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32))),
            const SizedBox(height: 8),
            const Text('Souhaitez-vous exporter la fiche ?',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            const Divider(height: 24),
            ListTile(
              leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.picture_as_pdf,
                      color: Colors.red.shade700, size: 24)),
              title: const Text('Aperçu PDF'),
              subtitle: const Text('Visualiser avant d\'exporter'),
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
              title: const Text('Exporter en PDF'),
              subtitle: const Text('Télécharger ou partager la fiche'),
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
              title: const Text('Aperçu Excel'),
              subtitle: const Text('Visualiser avant d\'exporter'),
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
              title: const Text('Exporter en Excel'),
              subtitle: const Text('Télécharger ou partager la fiche'),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () async {
                Navigator.pop(context);
                await _exportAndShareExcel(fiche);
              },
            ),
            const SizedBox(height: 8),
            TextButton(
                onPressed: () => _navigateBack(),
                child: const Text('Plus tard', style: TextStyle(fontSize: 14))),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _exportAndSharePDF(Fiche fiche) async {
    _showLoadingDialog('Génération du PDF...');
    final file = await ExportService.exportFicheToPDF(fiche);
    if (mounted) Navigator.pop(context);
    if (file != null && mounted) {
      await ExportService.shareFile(file, file.path.split('/').last);
      _showSnackBar('PDF exporté avec succès !', const Color(0xFF2E7D32));
      _navigateBack();
    } else {
      _showSnackBar('Erreur lors de l\'export PDF', Colors.red);
    }
  }

  Future<void> _exportAndShareExcel(Fiche fiche) async {
    _showLoadingDialog('Génération du fichier Excel...');
    final file = await ExportService.exportFicheToExcel(fiche);
    if (mounted) Navigator.pop(context);
    if (file != null && mounted) {
      await ExportService.shareFile(file, file.path.split('/').last);
      _showSnackBar('Excel exporté avec succès !', const Color(0xFF2E7D32));
      _navigateBack();
    } else {
      _showSnackBar('Erreur lors de l\'export Excel', Colors.red);
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
