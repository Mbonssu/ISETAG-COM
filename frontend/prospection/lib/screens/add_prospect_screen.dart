// // ignore_for_file: unused_local_variable, prefer_final_fields, avoid_print, use_build_context_synchronously, deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:isetagcom/models/classe.dart';
// import 'package:isetagcom/models/pros.dart';
// import '../models/etablissement.dart';
// import '../models/fiche.dart';
// import '../models/interet_filiere.dart';
// import '../models/localStorage/local_storage.dart';
// import '../models/prospectData.dart';
// import '../models/source.dart';
// import '../models/specialite.dart';
// import '../services/api_service.dart';
// import '../services/loading_service.dart';
// import '../services/translation_service.dart';
// import '../services/notification_service.dart';
// import '../utils/idGenerator.dart';
// import '../utils/status.dart';
// import '../utils/themes/glass_theme.dart';

// class AddProspectScreen extends StatefulWidget {
//   final Prospect? prospectToEdit;
//   final ProspectDetails? prospectDetails;

//   const AddProspectScreen({
//     super.key,
//     this.prospectToEdit,
//     this.prospectDetails,
//   });

//   @override
//   State<AddProspectScreen> createState() => _AddProspectScreenState();
// }

// class _AddProspectScreenState extends State<AddProspectScreen> {
//   bool _isEditing = false;
//   bool _isSaving = false;

//   static const String _defaultClassPrefix = 'default_';

//   final ApiService _apiService = ApiService();

//   bool _hasChanged<T>(T? oldValue, T? newValue) {
//     if (oldValue == null && newValue == null) return false;
//     if (oldValue == null || newValue == null) return true;
//     return oldValue != newValue;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _isEditing = widget.prospectToEdit != null;
//     _initForm();
//     _loadFromDb();
//     if (_isEditing) {
//       _loadProspectData();
//     }
//   }

//   Future<void> _loadFromDb() async {
//     await LocalStorage.instance.seedClassesIfEmpty();
//     await LocalStorage.instance.seedSpecialtiesIfEmpty();

//     final ets = await LocalStorage.instance.getAllEtablissements();
//     final cls = await LocalStorage.instance.getAllClasses();
//     final specs = await LocalStorage.instance.getAllSpecialites();

//     setState(() {
//       _allEtablissements = ets;

//       _etablissementNames.clear();
//       for (final e in ets) {
//         if (!_etablissementNames.contains(e.nomEtablissement)) {
//           _etablissementNames.add(e.nomEtablissement);
//         }
//       }

//       _classes.clear();
//       _classKeys.clear();
//       for (final c in cls) {
//         if (c.libelleClasse.startsWith(_defaultClassPrefix)) continue;
//         _classKeys.add(c.libelleClasse);
//         final translatedName = c.libelleClasse.tr;
//         if (!_classes.contains(translatedName)) {
//           _classes.add(translatedName);
//         }
//       }

//       _specialites.clear();
//       _specialityKeys.clear();
//       for (final s in specs) {
//         _specialityKeys.add(s.libelleSpecialite);
//         final translatedName = s.libelleSpecialite.tr;
//         if (!_specialites.contains(translatedName)) {
//           _specialites.add(translatedName);
//         }
//       }

//       _filteredEtablissementNames = _getFilteredEtablissementNames();
//     });
//   }

//   Future<void> _loadProspectData() async {
//     final prospect = widget.prospectToEdit;
//     if (prospect == null) return;

//     await prospect.classe.load();
//     await prospect.fiche.load();
//     await prospect.interets.load();
//     for (final interet in prospect.interets) {
//       await interet.specialite.load();
//     }

//     _nomCompletCtrl.text = prospect.nomComplet;
//     _telephoneCtrl.text = prospect.telephone;
//     _nomParentCtrl.text = prospect.nomParent;
//     _telephoneParentCtrl.text = prospect.telephoneParent;
//     _emailCtrl.text = prospect.email ?? '';
//     _adresseCtrl.text = prospect.adresse ?? '';
//     _commentaireCtrl.text = prospect.commentaireGen ?? '';

//     _selectedSexe = prospect.sexe;
//     _selectedTypeProspect = prospect.typeProspect;
//     _selectedNiveauEtude = prospect.niveauEtude;

//     if (prospect.classe.value != null) {
//       final classe = prospect.classe.value!;
//       await classe.ets.load();
//       if (classe.ets.value != null) {
//         _selectedEtablissement = classe.ets.value!.nomEtablissement;
//       }
//       if (!classe.libelleClasse.startsWith(_defaultClassPrefix)) {
//         final translatedClasse = classe.libelleClasse.tr;
//         if (_classes.contains(translatedClasse)) {
//           _selectedClasse = translatedClasse;
//         }
//       }
//     }

//     _selectedSource = prospect.source_infos;

//     if (prospect.date_relance != null) {
//       _date_relance = prospect.date_relance;
//       _relanceCtrl.text = _formatDate(_date_relance!);
//     }

//     _interetsList.clear();
//     for (final interet in prospect.interets) {
//       final specialite = interet.specialite.value;
//       if (specialite != null) {
//         final translatedName = specialite.libelleSpecialite.tr;
//         _interetsList.add({
//           'specialite': translatedName,
//           'specialiteKey': specialite.libelleSpecialite,
//           'ordrePreference': interet.ordrePreference,
//           'niveauInteret': interet.niveauInteret,
//           'commentaire': interet.commentaire ?? '',
//           'idInteret': interet.idInteret,
//           'idSpecialite': specialite.idSpecialite,
//           'syncState': interet.syncState,
//         });
//       }
//     }
//     _interetsList
//         .sort((a, b) => a['ordrePreference'].compareTo(b['ordrePreference']));

//     _filteredEtablissementNames = _getFilteredEtablissementNames();

//     setState(() {});
//   }

//   final _formKey = GlobalKey<FormState>();

//   final _nomCompletCtrl = TextEditingController();
//   final _telephoneCtrl = TextEditingController();
//   final _nomParentCtrl = TextEditingController();
//   final _telephoneParentCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _concerneCtrl = TextEditingController();
//   final _adresseCtrl = TextEditingController();
//   final _relanceCtrl = TextEditingController();
//   final _commentaireCtrl = TextEditingController();

//   final List<Map<String, dynamic>> _interetsList = [];

//   final TextEditingController _newOrdrePreferenceCtrl = TextEditingController();
//   final TextEditingController _newNiveauInteretCtrl = TextEditingController();
//   final TextEditingController _newCommentaireInteretCtrl =
//       TextEditingController();

//   String? _selectedSpecialiteForInteret;
//   String _selectedSexe = '';
//   String _selectedTypeProspect = '';
//   String? _selectedEtablissement;
//   String? _selectedClasse;
//   String _selectedSource = '';
//   String _selectedNiveauEtude = '';
//   int _scoreInteret = 5;

//   DateTime now = DateTime.now();
//   DateTime? _date_relance;

//   final Map<String, bool> _sectionsExpanded = {
//     'personnelles': true,
//     'academiques': false,
//     'interet': false,
//     'commentaires': false,
//     'relance': false,
//   };

//   List<Etablissement> _allEtablissements = [];
//   final List<String> _etablissementNames = [];
//   List<String> _filteredEtablissementNames = [];

//   final List<String> _classes = [];
//   List<String> _classKeys = [];

//   final List<String> _specialites = [];
//   List<String> _specialityKeys = [];

//   List<String> _sourcesInfos = [
//     'Réseaux sociaux',
//     'Recommandation',
//     'Site web',
//     'Événement',
//     'Prospection terrain',
//     'Partenariat',
//   ];

//   final List<String> _sexeOptions = ['Masculin', 'Féminin'];
//   final List<String> _typeProspectOptions = ['Étudiant', 'Éleve', 'Parent'];
//   final List<String> _niveauEtudeOptions = [
//     'Baccalauréat',
//     'BTS 1',
//     'BTS 2',
//     'Licence',
//     'Master 1',
//   ];

//   // ─── Helpers ──────────────────────────────────────────────────────────────

//   bool _shouldShowClassField() {
//     return _selectedNiveauEtude == 'Baccalauréat' &&
//         (_selectedTypeProspect == 'Éleve' || _selectedTypeProspect == 'Parent');
//   }

//   List<String> _getFilteredEtablissementNames() {
//     if (_selectedTypeProspect == 'Parent') {
//       return _allEtablissements.map((e) => e.nomEtablissement).toList();
//     }

//     final targetType =
//         _selectedNiveauEtude == 'Baccalauréat' ? 'secondaire' : 'supérieur';

//     return _allEtablissements
//         .where((e) => e.typeEtablissement == targetType)
//         .map((e) => e.nomEtablissement)
//         .toList();
//   }

//   List<String> _getAvailableNiveauEtudeOptions() {
//     if (_selectedTypeProspect == 'Parent') {
//       return _niveauEtudeOptions;
//     }

//     if (_selectedTypeProspect == 'Éleve') {
//       return ['Baccalauréat'];
//     }

//     if (_selectedTypeProspect == 'Étudiant') {
//       return _niveauEtudeOptions
//           .where((level) => level != 'Baccalauréat')
//           .toList();
//     }

//     return _niveauEtudeOptions;
//   }

//   List<String> _getAvailableTypeProspectOptions() {
//     if (_selectedNiveauEtude == 'Baccalauréat') {
//       return ['Éleve', 'Parent'];
//     }

//     return ['Étudiant', 'Parent'];
//   }

//   void _initForm() {
//     if (_isEditing) return;

//     _nomCompletCtrl.text = '';
//     _telephoneCtrl.text = '';
//     _nomParentCtrl.text = '';
//     _telephoneParentCtrl.text = '';
//     _emailCtrl.text = '';
//     _concerneCtrl.text = '';
//     _adresseCtrl.text = '';
//     _commentaireCtrl.text = '';

//     _selectedEtablissement =
//         _etablissementNames.isNotEmpty ? _etablissementNames[0] : null;
//     _selectedClasse = _classes.isNotEmpty ? _classes[0] : null;
//     _selectedSexe = _sexeOptions[0];
//     _selectedTypeProspect = 'Parent';
//     _selectedNiveauEtude = _niveauEtudeOptions[0];
//     _selectedSource = _sourcesInfos[0];
//     _date_relance = null;
//     _relanceCtrl.text = '';

//     _newOrdrePreferenceCtrl.text = '1';
//     _newNiveauInteretCtrl.text = '1';
//     _newCommentaireInteretCtrl.text = 'no_comment'.tr;

//     if (_specialites.isNotEmpty) {
//       _selectedSpecialiteForInteret = _specialites[0];
//     }

//     _filteredEtablissementNames = _getFilteredEtablissementNames();
//   }

//   // ─── BUILD ────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageBackground(
//         child: Column(
//           children: [
//             _buildHeader(),
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 physics: const BouncingScrollPhysics(),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Section 1: Informations Personnelles
//                       _buildExpandableSection(
//                         title: 'personal_info'.tr,
//                         icon: Icons.person_outline,
//                         isExpanded: _sectionsExpanded['personnelles']!,
//                         onToggle: () => _toggleSection('personnelles'),
//                         children: [
//                           _buildTextField(
//                               controller: _nomCompletCtrl,
//                               label: 'full_name'.tr,
//                               hint: 'enter_full_name'.tr,
//                               icon: Icons.person_outline,
//                               required: true),
//                           const SizedBox(height: 12),
//                           _buildPhoneField(
//                               controller: _telephoneCtrl,
//                               label: 'phone'.tr,
//                               hint: 'enter_phone'.tr,
//                               icon: Icons.phone_outlined,
//                               required: true),
//                           const SizedBox(height: 12),
//                           _buildTextField(
//                               controller: _nomParentCtrl,
//                               label: 'name_par'.tr,
//                               hint: 'enter_full_name'.tr,
//                               icon: Icons.person_outline,
//                               required: false),
//                           const SizedBox(height: 12),
//                           _buildPhoneField(
//                               controller: _telephoneParentCtrl,
//                               label: 'phone_par'.tr,
//                               hint: 'enter_phone'.tr,
//                               icon: Icons.phone_outlined,
//                               required: false),
//                           const SizedBox(height: 12),
//                           _buildTextField(
//                               controller: _emailCtrl,
//                               label: 'email'.tr,
//                               hint: 'enter_email'.tr,
//                               icon: Icons.email_outlined,
//                               keyboardType: TextInputType.emailAddress),
//                           const SizedBox(height: 12),
//                           _buildDropdownField(
//                             value: _selectedSexe,
//                             label: 'gender'.tr,
//                             hint: 'select'.tr,
//                             icon: Icons.man_2,
//                             items: _sexeOptions,
//                             onChanged: (v) =>
//                                 setState(() => _selectedSexe = v!),
//                           ),
//                           const SizedBox(height: 12),
//                           _buildDropdownField(
//                             value: _selectedNiveauEtude,
//                             label: 'education_level'.tr,
//                             hint: 'select'.tr,
//                             icon: Icons.school_outlined,
//                             items: _getAvailableNiveauEtudeOptions(),
//                             onChanged: (v) {
//                               setState(() {
//                                 _selectedNiveauEtude = v!;
//                                 if (_selectedNiveauEtude == 'Baccalauréat' &&
//                                     _selectedTypeProspect == 'Étudiant') {
//                                   _selectedTypeProspect = 'Éleve';
//                                   _showSnackBar(
//                                     '📌 Un prospect "Baccalauréat" doit être de type "Éleve"',
//                                     Colors.orange,
//                                     3,
//                                   );
//                                 }
//                                 _filteredEtablissementNames =
//                                     _getFilteredEtablissementNames();
//                                 if (_selectedEtablissement != null &&
//                                     !_filteredEtablissementNames
//                                         .contains(_selectedEtablissement)) {
//                                   _selectedEtablissement = null;
//                                 }
//                                 if (!_shouldShowClassField()) {
//                                   _selectedClasse = null;
//                                 }
//                               });
//                             },
//                           ),
//                           const SizedBox(height: 12),
//                           _buildDropdownField(
//                             value: _selectedTypeProspect,
//                             label: 'who_is_prospect'.tr,
//                             hint: 'select'.tr,
//                             icon: Icons.category_outlined,
//                             items: _getAvailableTypeProspectOptions(),
//                             onChanged: (v) {
//                               setState(() {
//                                 _selectedTypeProspect = v!;
//                                 if (_selectedTypeProspect == 'Étudiant' &&
//                                     _selectedNiveauEtude == 'Baccalauréat') {
//                                   _selectedNiveauEtude = '';
//                                   _showSnackBar(
//                                     '📌 Un étudiant ne peut pas être en "Baccalauréat"',
//                                     Colors.orange,
//                                     3,
//                                   );
//                                 }
//                                 if (!_shouldShowClassField()) {
//                                   _selectedClasse = null;
//                                 }
//                               });
//                             },
//                           ),
//                           const SizedBox(height: 12),
//                           _buildTextField(
//                               controller: _adresseCtrl,
//                               label: 'address'.tr,
//                               hint: 'full_address'.tr,
//                               icon: Icons.location_on_outlined),
//                         ],
//                       ),
//                       const SizedBox(height: 16),

//                       // Section 2: Informations académiques
//                       _buildExpandableSection(
//                         title: 'academic_info'.tr,
//                         icon: Icons.business_outlined,
//                         isExpanded: _sectionsExpanded['academiques']!,
//                         onToggle: () => _toggleSection('academiques'),
//                         children: [
//                           _buildEntityPickerField(
//                             value: _selectedEtablissement,
//                             label: 'establishment'.tr,
//                             hint: 'select_or_add'.tr,
//                             icon: Icons.school_outlined,
//                             entityType: 'etablissement',
//                             items: _filteredEtablissementNames,
//                             onChanged: (value) =>
//                                 setState(() => _selectedEtablissement = value),
//                           ),
//                           if (_shouldShowClassField()) ...[
//                             const SizedBox(height: 12),
//                             _buildEntityPickerField(
//                               value: _selectedClasse,
//                               label: 'class'.tr,
//                               hint: 'select_or_add'.tr,
//                               icon: Icons.class_outlined,
//                               entityType: 'classe',
//                               items: _classes,
//                               onChanged: (value) =>
//                                   setState(() => _selectedClasse = value),
//                             ),
//                           ],
//                         ],
//                       ),
//                       const SizedBox(height: 16),

//                       // Section 3: Intérêt et provenance
//                       _buildExpandableSection(
//                         title: 'interest_source'.tr,
//                         icon: Icons.insights_outlined,
//                         isExpanded: _sectionsExpanded['interet']!,
//                         onToggle: () => _toggleSection('interet'),
//                         children: [
//                           _buildDropdownField(
//                             value: _selectedSource,
//                             label: 'source'.tr,
//                             hint: 'select_or_add'.tr,
//                             icon: Icons.sensors_rounded,
//                             items: _sourcesInfos,
//                             onChanged: (value) =>
//                                 setState(() => _selectedSource = value!),
//                             onAdd: (newValue) {
//                               setState(() {
//                                 _sourcesInfos.add(newValue);
//                                 _selectedSource = newValue;
//                               });
//                             },
//                           ),
//                           const SizedBox(height: 12),
//                           _buildInteretsListSection(),
//                         ],
//                       ),
//                       const SizedBox(height: 16),

//                       // Section 4: Commentaires
//                       _buildExpandableSection(
//                         title: 'comments'.tr,
//                         icon: Icons.comment_outlined,
//                         isExpanded: _sectionsExpanded['commentaires']!,
//                         onToggle: () => _toggleSection('commentaires'),
//                         children: [
//                           _buildTextField(
//                             controller: _commentaireCtrl,
//                             label: 'general_comment'.tr,
//                             hint: 'add_observations'.tr,
//                             icon: Icons.comment_outlined,
//                             maxLines: 3,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),

//                       // Section 5: Relance
//                       _buildExpandableSection(
//                         title: 'schedule_followup'.tr,
//                         icon: Icons.schedule_rounded,
//                         isExpanded: _sectionsExpanded['relance']!,
//                         onToggle: () => _toggleSection('relance'),
//                         children: [
//                           _buildDateTimeField(
//                             controller: _relanceCtrl,
//                             label: 'followup_date'.tr,
//                             hint: 'schedule_followup'.tr,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 32),

//                       // Action buttons
//                       Row(
//                         children: [
//                           Expanded(
//                             child: OutlinedButton(
//                               onPressed: () => Navigator.pop(context),
//                               style: OutlinedButton.styleFrom(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 14),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12)),
//                                 side: BorderSide(color: Colors.grey.shade400),
//                               ),
//                               child: Text('cancel'.tr,
//                                   style: const TextStyle(fontSize: 16)),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: _isSaving ? null : _saveProspect,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF2E7D32),
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 14),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12)),
//                               ),
//                               child: Text(
//                                 _isEditing ? 'update'.tr : 'save'.tr,
//                                 style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 32),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ─── Phone Field with African Regex ──────────────────────────────────────

//   Widget _buildPhoneField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     bool required = false,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.5)),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(0.03),
//               blurRadius: 8,
//               offset: const Offset(0, 2))
//         ],
//       ),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: TextInputType.phone,
//         style: const TextStyle(fontSize: 14),
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hint,
//           prefixIcon: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
//           border: InputBorder.none,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           labelStyle: const TextStyle(color: Colors.grey),
//         ),
//         validator: (value) {
//           if (required && (value == null || value.isEmpty)) {
//             return 'required_field'.tr;
//           }
//           if (value != null && value.isNotEmpty) {
//             final africanPhoneRegex = RegExp(r'^(6|2|5|7|9|0)[0-9]{8}$');
//             if (!africanPhoneRegex.hasMatch(value)) {
//               return 'Numéro de téléphone invalide (ex: 6XXXXXXXX)'.tr;
//             }
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   // ─── Section toggle ───────────────────────────────────────────────────────

//   void _toggleSection(String section) =>
//       setState(() => _sectionsExpanded[section] = !_sectionsExpanded[section]!);

//   // ─── Expandable section wrapper ───────────────────────────────────────────

//   Widget _buildExpandableSection({
//     required String title,
//     required IconData icon,
//     required bool isExpanded,
//     required VoidCallback onToggle,
//     required List<Widget> children,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(0.03),
//               blurRadius: 8,
//               offset: const Offset(0, 2))
//         ],
//       ),
//       child: Column(
//         children: [
//           Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: onToggle,
//               borderRadius: BorderRadius.circular(12),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                 child: Row(
//                   children: [
//                     Icon(icon, size: 22, color: const Color(0xFF2E7D32)),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(title,
//                           style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                               color: Color(0xFF1B5E20))),
//                     ),
//                     Icon(isExpanded ? Icons.expand_less : Icons.expand_more,
//                         color: Colors.grey.shade600, size: 24),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           if (isExpanded)
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: children),
//             ),
//         ],
//       ),
//     );
//   }

//   // ─── Intérêts section ─────────────────────────────────────────────────────

//   Widget _buildInteretsListSection() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (_interetsList.isNotEmpty) ...[
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Text('selected_specialties'.tr,
//                   style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1B5E20))),
//             ),
//             ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: _interetsList.length,
//               separatorBuilder: (_, __) => const Divider(height: 1),
//               itemBuilder: (context, index) {
//                 final interet = _interetsList[index];
//                 return ListTile(
//                   dense: true,
//                   leading: CircleAvatar(
//                     radius: 14,
//                     backgroundColor: const Color(0xFF2E7D32).withOpacity(0.1),
//                     child: Text('${index + 1}',
//                         style: const TextStyle(
//                             color: Color(0xFF2E7D32),
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12)),
//                   ),
//                   title: Text(interet['specialite'],
//                       style: const TextStyle(
//                           fontWeight: FontWeight.w600, fontSize: 13)),
//                   subtitle: Text(
//                     'order_preference'
//                         .tr
//                         .replaceFirst(
//                             '{order}', '${interet['ordrePreference']}')
//                         .replaceFirst('{level}', '${interet['niveauInteret']}'),
//                     style: const TextStyle(fontSize: 11),
//                   ),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete_outline,
//                         color: Colors.red, size: 18),
//                     onPressed: () => setState(() {
//                       _interetsList.removeAt(index);
//                       for (int i = 0; i < _interetsList.length; i++) {
//                         _interetsList[i]['ordrePreference'] = i + 1;
//                       }
//                     }),
//                   ),
//                   onTap: () => _showEditInteretDialog(index),
//                 );
//               },
//             ),
//             const Divider(),
//           ],
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('add_specialty'.tr,
//                     style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87)),
//                 const SizedBox(height: 12),
//                 _buildEntityPickerField(
//                   value: _selectedSpecialiteForInteret,
//                   label: 'specialty_field'.tr,
//                   hint: 'select_specialty'.tr,
//                   icon: Icons.school_outlined,
//                   entityType: 'specialite',
//                   items: _specialites
//                       .where((spec) =>
//                           !_interetsList.any((i) => i['specialite'] == spec))
//                       .toList(),
//                   onChanged: (value) =>
//                       setState(() => _selectedSpecialiteForInteret = value),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                         child: _buildSmallTextField(
//                       controller: _newNiveauInteretCtrl,
//                       label: 'level'.tr,
//                       hint: 'level_hint'.tr,
//                       icon: Icons.star_outline,
//                       keyboardType: TextInputType.number,
//                     )),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 _buildSmallTextField(
//                   controller: _newCommentaireInteretCtrl,
//                   label: 'comment'.tr,
//                   hint: 'specify_interest'.tr,
//                   icon: Icons.comment_outlined,
//                   maxLines: 2,
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton.icon(
//                         onPressed: _clearInteretForm,
//                         icon: const Icon(Icons.clear, size: 16),
//                         label: Text('clear'.tr),
//                         style: OutlinedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8)),
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         onPressed: _addInteret,
//                         icon: const Icon(Icons.add, size: 16),
//                         label: Text('add'.tr),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF2E7D32),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8)),
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _addInteret() {
//     final specialite = _selectedSpecialiteForInteret;
//     final ordrePreference = _interetsList.length + 1;
//     final niveauInteret = int.tryParse(_newNiveauInteretCtrl.text.trim());

//     if (specialite == null || specialite.isEmpty) {
//       _showSnackBar('select_specialty_warning'.tr, Colors.orange, 5);
//       return;
//     }
//     if (niveauInteret == null || niveauInteret < 1 || niveauInteret > 5) {
//       _showSnackBar('invalid_level'.tr, Colors.orange, 5);
//       return;
//     }
//     if (_interetsList.any((i) => i['ordrePreference'] == ordrePreference)) {
//       _showSnackBar('order_exists'.tr, Colors.orange, 5);
//       return;
//     }
//     if (_interetsList.any((i) => i['specialite'] == specialite)) {
//       _showSnackBar('specialty_exists'.tr, Colors.orange, 5);
//       return;
//     }

//     String? key;
//     for (final specKey in _specialityKeys) {
//       if (specKey.tr == specialite) {
//         key = specKey;
//         break;
//       }
//     }
//     final specialiteKey = key ?? specialite;

//     setState(() {
//       _interetsList.add({
//         'specialite': specialite,
//         'specialiteKey': specialiteKey,
//         'ordrePreference': ordrePreference,
//         'niveauInteret': niveauInteret,
//         'commentaire':
//             _newCommentaireInteretCtrl.text.trim() ?? 'no_comment'.tr,
//       });
//       _clearInteretForm();
//     });
//     _showSnackBar('specialty_added_success'.tr, const Color(0xFF2E7D32), 3);
//   }

//   void _clearInteretForm() {
//     setState(() {
//       _selectedSpecialiteForInteret = null;
//       _newOrdrePreferenceCtrl.clear();
//       _newNiveauInteretCtrl.clear();
//       _newCommentaireInteretCtrl.clear();
//     });
//   }

//   void _showEditInteretDialog(int index) {
//     final interet = _interetsList[index];
//     final niveauCtrl =
//         TextEditingController(text: interet['niveauInteret'].toString());
//     final commentCtrl = TextEditingController(text: interet['commentaire']);

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('modify_specialty'
//             .tr
//             .replaceFirst('{specialty}', interet['specialite'])),
//         content: Column(mainAxisSize: MainAxisSize.min, children: [
//           _buildSmallTextField(
//               controller: niveauCtrl,
//               label: 'level'.tr,
//               hint: 'level_hint'.tr,
//               icon: Icons.star_outline),
//           const SizedBox(height: 12),
//           _buildSmallTextField(
//               controller: commentCtrl,
//               label: 'comment'.tr,
//               hint: 'specify_interest'.tr,
//               icon: Icons.comment_outlined,
//               maxLines: 2),
//         ]),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('cancel'.tr)),
//           ElevatedButton(
//             onPressed: () {
//               final ordre = interet['ordrePreference'];
//               final niveau = int.tryParse(niveauCtrl.text);
//               if (ordre != null &&
//                   ordre >= 1 &&
//                   niveau != null &&
//                   niveau >= 1 &&
//                   niveau <= 10) {
//                 setState(() {
//                   _interetsList[index]['ordrePreference'] = ordre;
//                   _interetsList[index]['niveauInteret'] = niveau;
//                   _interetsList[index]['commentaire'] = commentCtrl.text;
//                   _interetsList.sort((a, b) =>
//                       a['ordrePreference'].compareTo(b['ordrePreference']));
//                   for (int i = 0; i < _interetsList.length; i++) {
//                     _interetsList[i]['ordrePreference'] = i + 1;
//                   }
//                 });
//                 Navigator.pop(context);
//                 _showSnackBar('modify_success'.tr, const Color(0xFF2E7D32), 3);
//               } else {
//                 _showSnackBar('invalid_values'.tr, Colors.orange, 3);
//               }
//             },
//             style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF2E7D32)),
//             child: Text('save'.tr, style: const TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   // ─── Snack bar ────────────────────────────────────────────────────────────

//   void _showSnackBar(String message, Color color, int dur) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//           content: Text(message),
//           backgroundColor: color,
//           duration: Duration(seconds: dur)),
//     );
//   }

//   // ─── UI Helpers ───────────────────────────────────────────────────────────

//   Widget _buildSmallTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.5)),
//       ),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLines: maxLines,
//         style: const TextStyle(fontSize: 13),
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hint,
//           prefixIcon: Icon(icon, color: const Color(0xFF2E7D32), size: 16),
//           border: InputBorder.none,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//           labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
//       decoration: const BoxDecoration(
//         color: Color(0xFF2E7D32),
//         borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Row(
//           children: [
//             GestureDetector(
//               onTap: () => Navigator.pop(context),
//               child:
//                   const Icon(Icons.arrow_back, color: Colors.white, size: 24),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 _isEditing ? 'edit_prospect'.tr : 'new_prospect'.tr,
//                 style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                   color: Colors.white24,
//                   borderRadius: BorderRadius.circular(12)),
//               child:
//                   const Icon(Icons.person_add, color: Colors.white, size: 22),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//     bool required = false,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.5)),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(0.03),
//               blurRadius: 8,
//               offset: const Offset(0, 2))
//         ],
//       ),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLines: maxLines,
//         style: const TextStyle(fontSize: 14),
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hint,
//           prefixIcon: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
//           border: InputBorder.none,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           labelStyle: const TextStyle(color: Colors.grey),
//         ),
//         validator: required
//             ? (value) =>
//                 value == null || value.isEmpty ? 'required_field'.tr : null
//             : null,
//       ),
//     );
//   }

//   // ─── Champ avec sélecteur en bottom sheet avec filtre ───────────────────

//   Widget _buildEntityPickerField({
//     required String? value,
//     required String label,
//     required String hint,
//     required IconData icon,
//     required String entityType,
//     required List<String> items,
//     required Function(String?) onChanged,
//   }) {
//     return GestureDetector(
//       onTap: () => _showEntityPickerBottomSheet(
//         entityType: entityType,
//         currentValue: value,
//         items: items,
//         onSelect: onChanged,
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.5)),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withOpacity(0.03),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2))
//           ],
//         ),
//         child: InputDecorator(
//           decoration: InputDecoration(
//             labelText: label,
//             prefixIcon: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
//             border: InputBorder.none,
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             labelStyle: const TextStyle(color: Colors.grey),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   value ?? hint,
//                   style: TextStyle(
//                       color: value != null ? Colors.black87 : Colors.grey,
//                       fontSize: 14),
//                 ),
//               ),
//               const Icon(Icons.arrow_drop_down, color: Color(0xFF2E7D32)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ─── Dropdown simple avec filtre ─────────────────────────────────────────

//   Widget _buildDropdownField({
//     required String? value,
//     required String label,
//     required String hint,
//     required IconData icon,
//     required List<String> items,
//     required Function(String?) onChanged,
//     Function(String)? onAdd,
//   }) {
//     return GestureDetector(
//       onTap: () {
//         if (onAdd != null) {
//           _showEntityPickerBottomSheet(
//             entityType: 'source',
//             currentValue: value,
//             items: items,
//             onSelect: onChanged,
//             onAdd: onAdd,
//           );
//         } else {
//           _showSimpleSearchableDialog(items, label, onChanged);
//         }
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.5)),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withOpacity(0.03),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2))
//           ],
//         ),
//         child: InputDecorator(
//           decoration: InputDecoration(
//             labelText: label,
//             prefixIcon: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
//             border: InputBorder.none,
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             labelStyle: const TextStyle(color: Colors.grey),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   value ?? hint,
//                   style: TextStyle(
//                       color: value != null ? Colors.black87 : Colors.grey,
//                       fontSize: 14),
//                 ),
//               ),
//               const Icon(Icons.arrow_drop_down, color: Color(0xFF2E7D32)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ─── Bottom sheet de sélection avec filtre ──────────────────────────────

//   void _showEntityPickerBottomSheet({
//     required String entityType,
//     required String? currentValue,
//     required List<String> items,
//     required Function(String?) onSelect,
//     Function(String)? onAdd,
//   }) {
//     String title;
//     IconData icon;
//     Color iconColor = const Color(0xFF2E7D32);

//     switch (entityType) {
//       case 'etablissement':
//         title = 'Établissement';
//         icon = Icons.school_outlined;
//         break;
//       case 'classe':
//         title = 'Classe';
//         icon = Icons.class_outlined;
//         break;
//       case 'specialite':
//         title = 'Filières';
//         icon = Icons.school_outlined;
//         break;
//       case 'source':
//         title = 'Sources';
//         icon = Icons.sensors_rounded;
//         break;
//       default:
//         title = entityType;
//         icon = Icons.list;
//     }

//     // ✅ Build itemMap BEFORE showModalBottomSheet
//     final List<Map<String, String>> itemMap = items.map((key) {
//       return {
//         'key': key,
//         'translated': key.tr,
//       };
//     }).toList();

//     itemMap.sort((a, b) => a['translated']!.compareTo(b['translated']!));

//     // ✅ State variables at the showModalBottomSheet level
//     String searchQuery = '';
//     List<Map<String, String>> filteredItems = List.from(itemMap);

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       backgroundColor: Colors.white,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setBottomState) {
//             return DraggableScrollableSheet(
//               expand: false,
//               initialChildSize: 0.6,
//               maxChildSize: 0.9,
//               minChildSize: 0.3,
//               builder: (_, scrollController) {
//                 return Container(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: Container(
//                           width: 40,
//                           height: 4,
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade300,
//                             borderRadius: BorderRadius.circular(2),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           Icon(icon, color: iconColor, size: 24),
//                           const SizedBox(width: 12),
//                           Text(
//                             '${'select'.tr} $title',
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       TextField(
//                         autofocus: false,
//                         decoration: InputDecoration(
//                           hintText: 'search'.tr,
//                           prefixIcon: const Icon(Icons.search),
//                           suffixIcon: searchQuery.isNotEmpty
//                               ? IconButton(
//                                   icon: Icon(Icons.clear,
//                                       color: Colors.grey.shade400),
//                                   onPressed: () {
//                                     // ✅ Use setBottomState to update the persisted variables
//                                     setBottomState(() {
//                                       searchQuery = '';
//                                       filteredItems = List.from(itemMap);
//                                     });
//                                   },
//                                 )
//                               : null,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                         ),
//                         onChanged: (query) {
//                           // ✅ Use setBottomState to update the persisted variables
//                           setBottomState(() {
//                             searchQuery = query.trim();

//                             if (searchQuery.isEmpty) {
//                               filteredItems = List.from(itemMap);
//                             } else {
//                               final lowerQuery = searchQuery.toLowerCase();
//                               filteredItems = itemMap.where((item) {
//                                 final translated =
//                                     item['translated']!.toLowerCase();
//                                 return translated.contains(lowerQuery);
//                               }).toList();

//                               filteredItems.sort((a, b) {
//                                 final aTranslated =
//                                     a['translated']!.toLowerCase();
//                                 final bTranslated =
//                                     b['translated']!.toLowerCase();
//                                 final aStartsWith =
//                                     aTranslated.startsWith(lowerQuery);
//                                 final bStartsWith =
//                                     bTranslated.startsWith(lowerQuery);
//                                 if (aStartsWith && !bStartsWith) return -1;
//                                 if (!aStartsWith && bStartsWith) return 1;
//                                 return aTranslated.compareTo(bTranslated);
//                               });
//                             }
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 12),
//                       if (filteredItems.isNotEmpty)
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 8),
//                           child: Text(
//                             '${filteredItems.length} résultat${filteredItems.length > 1 ? 's' : ''}',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                         ),
//                       Expanded(
//                         child: filteredItems.isEmpty
//                             ? Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(32),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.search_off,
//                                         size: 48,
//                                         color: Colors.grey.shade400,
//                                       ),
//                                       const SizedBox(height: 16),
//                                       Text(
//                                         'no_result'.tr,
//                                         style: TextStyle(
//                                           color: Colors.grey.shade600,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             : ListView.builder(
//                                 controller: scrollController,
//                                 itemCount: filteredItems.length,
//                                 itemBuilder: (_, index) {
//                                   final item = filteredItems[index];
//                                   final key = item['key']!;
//                                   final translated = item['translated']!;
//                                   final isSelected = key == currentValue;

//                                   return ListTile(
//                                     leading: Icon(
//                                       isSelected
//                                           ? Icons.radio_button_checked
//                                           : Icons.radio_button_unchecked,
//                                       color: isSelected
//                                           ? const Color(0xFF2E7D32)
//                                           : Colors.grey,
//                                     ),
//                                     title: Text(
//                                       translated,
//                                       style: TextStyle(
//                                         fontWeight: isSelected
//                                             ? FontWeight.bold
//                                             : FontWeight.normal,
//                                         color: isSelected
//                                             ? const Color(0xFF2E7D32)
//                                             : Colors.black87,
//                                       ),
//                                     ),
//                                     onTap: () {
//                                       onSelect(key);
//                                       Navigator.pop(context);
//                                     },
//                                   );
//                                 },
//                               ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8, bottom: 16),
//                         child: SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton.icon(
//                             onPressed: () {
//                               _showAddEntityDialog(
//                                 entityType,
//                                 onAdded: (newItem) {
//                                   onSelect(newItem);
//                                   Navigator.pop(context);
//                                 },
//                               );
//                             },
//                             icon: const Icon(Icons.add, size: 20),
//                             label: Text(
//                               'add'.tr + ' $title'.replaceFirst('s', ''),
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF2E7D32),
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     ).whenComplete(() {
//       // ✅ Clean up when bottom sheet is closed
//       // Reset state variables to prevent memory leaks
//       searchQuery = '';
//       filteredItems = List.from(itemMap);
//     });
//   }
//   // ─── Dialogue de sélection simple avec filtre ────────────────────────────

//   void _showSimpleSearchableDialog(
//       List<String> items, String title, Function(String?) onChanged) {
//     final searchCtrl = TextEditingController();
//     List<String> filtered = List.from(items);

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, ss) => Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.9,
//             constraints: BoxConstraints(
//                 maxHeight: MediaQuery.of(context).size.height * 0.8),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text('${'select'.tr} $title',
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.w700)),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: searchCtrl,
//                   autofocus: true,
//                   decoration: InputDecoration(
//                     hintText: 'search'.tr,
//                     prefixIcon: const Icon(Icons.search),
//                     suffixIcon: searchCtrl.text.isNotEmpty
//                         ? IconButton(
//                             icon: const Icon(Icons.clear),
//                             onPressed: () {
//                               searchCtrl.clear();
//                               ss(() => filtered = List.from(items));
//                             })
//                         : null,
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                   onChanged: (v) => ss(() {
//                     filtered = v.isEmpty
//                         ? List.from(items)
//                         : items
//                             .where((i) =>
//                                 i.toLowerCase().contains(v.toLowerCase()))
//                             .toList();
//                   }),
//                 ),
//                 const SizedBox(height: 12),
//                 Flexible(
//                   child: filtered.isEmpty
//                       ? Center(
//                           child: Padding(
//                           padding: const EdgeInsets.all(32),
//                           child: Text('no_result'.tr),
//                         ))
//                       : ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: filtered.length,
//                           itemBuilder: (_, i) => ListTile(
//                             leading: const Icon(Icons.check_circle_outline,
//                                 color: Color(0xFF2E7D32)),
//                             title: Text(filtered[i]),
//                             onTap: () {
//                               onChanged(filtered[i]);
//                               Navigator.pop(context);
//                             },
//                           ),
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showAddEntityDialog(String entityType,
//       {required Function(String) onAdded}) {
//     final nameCtrl = TextEditingController();
//     String? selectedType;
//     final addressCtrl = TextEditingController();
//     final phoneCtrl = TextEditingController();
//     final cityCtrl = TextEditingController();
//     final regionCtrl = TextEditingController();
//     final classCtrl = TextEditingController();
//     final specialityCtrl = TextEditingController();

//     String dialogTitle;
//     switch (entityType) {
//       case 'etablissement':
//         dialogTitle = 'Ajouter un établissement';
//         break;
//       case 'classe':
//         dialogTitle = 'Ajouter une classe';
//         break;
//       case 'specialite':
//         dialogTitle = 'Ajouter une filière';
//         break;
//       case 'source':
//         dialogTitle = 'Ajouter une source';
//         break;
//       default:
//         dialogTitle = 'Ajouter';
//     }

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Text(dialogTitle),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               if (entityType == 'etablissement') ...[
//                 TextField(
//                   controller: nameCtrl,
//                   autofocus: true,
//                   decoration: InputDecoration(
//                     hintText: 'Nom de l\'établissement *',
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 DropdownButtonFormField<String>(
//                   value: selectedType,
//                   hint: const Text('Type d\'établissement *'),
//                   items: const [
//                     DropdownMenuItem(
//                         value: 'secondaire',
//                         child: Text('Secondaire (Lycée/collège)')),
//                     DropdownMenuItem(
//                         value: 'supérieur',
//                         child: Text('Supérieur (Université)')),
//                   ],
//                   onChanged: (value) => selectedType = value,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               ] else if (entityType == 'classe') ...[
//                 if (_selectedEtablissement == null) ...[
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.red.shade50,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.red.shade200),
//                     ),
//                     child: Text(
//                       'school_first'.tr,
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   ),
//                 ] else ...[
//                   TextField(
//                     controller: classCtrl,
//                     autofocus: true,
//                     decoration: InputDecoration(
//                       hintText: 'Nom de la classe *',
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       children: [
//                         const Icon(Icons.school, size: 16, color: Colors.grey),
//                         const SizedBox(width: 8),
//                         Text(
//                           'Établissement: $_selectedEtablissement',
//                           style:
//                               const TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ] else if (entityType == 'specialite') ...[
//                 TextField(
//                   controller: specialityCtrl,
//                   autofocus: true,
//                   decoration: InputDecoration(
//                     hintText: 'Nom de la filière *',
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               ] else if (entityType == 'source') ...[
//                 TextField(
//                   controller: nameCtrl,
//                   autofocus: true,
//                   decoration: InputDecoration(
//                     hintText: 'Nom de la source *',
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('cancel'.tr),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final now = DateTime.now();
//               String resultKey = 'error';
//               String newItemName = '';

//               if (entityType == 'etablissement') {
//                 final name = nameCtrl.text.trim();
//                 if (name.isEmpty || selectedType == null) {
//                   _showSnackBar('Veuillez remplir tous les champs obligatoires',
//                       Colors.orange, 3);
//                   return;
//                 }

//                 final existingEts =
//                     await LocalStorage.instance.getEtablissementByNom(name);
//                 if (existingEts != null) {
//                   _showSnackBar(
//                       'Cet établissement existe déjà'.tr, Colors.orange, 3);
//                   return;
//                 }

//                 final newEts = Etablissement(
//                   idEtablissement: Generator.generateShortId('ets_'),
//                   nomEtablissement: name.trim(),
//                   typeEtablissement: selectedType,
//                   adresse: addressCtrl.text.trim().isEmpty
//                       ? null
//                       : addressCtrl.text.trim(),
//                   telephone: phoneCtrl.text.trim().isEmpty
//                       ? null
//                       : phoneCtrl.text.trim(),
//                   ville: cityCtrl.text.trim().isEmpty
//                       ? null
//                       : cityCtrl.text.trim(),
//                   region: regionCtrl.text.trim().isEmpty
//                       ? null
//                       : regionCtrl.text.trim(),
//                   createdAt: now,
//                   syncState: SyncState.pending,
//                 );
//                 resultKey =
//                     await LocalStorage.instance.saveEtablissement(newEts);
//                 newItemName = name;
//                 setState(() {
//                   if (!_etablissementNames.contains(name)) {
//                     _etablissementNames.add(name);
//                   }
//                   _allEtablissements.add(newEts);
//                   _filteredEtablissementNames =
//                       _getFilteredEtablissementNames();
//                 });
//               } else if (entityType == 'classe') {
//                 final name = classCtrl.text.trim();
//                 if (name.isEmpty || _selectedEtablissement == null) {
//                   _showSnackBar('Veuillez remplir tous les champs obligatoires',
//                       Colors.orange, 3);
//                   return;
//                 }

//                 final key =
//                     'class_${name.toLowerCase().replaceAll(' ', '_').replaceAll('é', 'e').replaceAll('è', 'e').replaceAll('ê', 'e').replaceAll('à', 'a').replaceAll('â', 'a').replaceAll('ô', 'o').replaceAll('û', 'u').replaceAll('ç', 'c').replaceAll("'", '_').replaceAll('-', '_').replaceAll(':', '').replaceAll('/', '_').replaceAll('(', '').replaceAll(')', '')}';

//                 Etablissement? existingEts = await LocalStorage.instance
//                     .getEtablissementByNom(_selectedEtablissement!);
//                 String etsId;
//                 if (existingEts != null) {
//                   etsId = existingEts.idEtablissement;
//                 } else {
//                   final type = _selectedNiveauEtude == 'Baccalauréat'
//                       ? 'secondaire'
//                       : 'supérieur';
//                   final newEts = Etablissement(
//                     idEtablissement: Generator.generateShortId('ets_'),
//                     nomEtablissement: _selectedEtablissement!,
//                     typeEtablissement: type,
//                     createdAt: now,
//                     syncState: SyncState.pending,
//                   );
//                   await LocalStorage.instance.saveEtablissement(newEts);
//                   etsId = newEts.idEtablissement;
//                   setState(() {
//                     if (!_etablissementNames
//                         .contains(_selectedEtablissement!)) {
//                       _etablissementNames.add(_selectedEtablissement!);
//                     }
//                     _allEtablissements.add(newEts);
//                     _filteredEtablissementNames =
//                         _getFilteredEtablissementNames();
//                   });
//                 }

//                 final existingClasse = await LocalStorage.instance
//                     .getClasseByLibelleAndEts(key, etsId);
//                 if (existingClasse != null) {
//                   _showSnackBar(
//                       'Cette classe existe déjà dans cet établissement'.tr,
//                       Colors.orange,
//                       3);
//                   return;
//                 }

//                 final newClasse = Classe(
//                   idClasse: Generator.generateShortId('cls_'),
//                   idEts: etsId,
//                   libelleClasse: key,
//                   createdAt: now,
//                   syncState: SyncState.pending,
//                 );
//                 resultKey = await LocalStorage.instance.saveClasse(newClasse);
//                 newItemName = name;
//                 setState(() {
//                   if (!_classKeys.contains(key)) {
//                     _classKeys.add(key);
//                   }
//                   final translatedName = key.tr;
//                   if (!_classes.contains(translatedName)) {
//                     _classes.add(translatedName);
//                   }
//                 });
//               } else if (entityType == 'specialite') {
//                 final name = specialityCtrl.text.trim();
//                 if (name.isEmpty) {
//                   _showSnackBar('Veuillez remplir tous les champs obligatoires',
//                       Colors.orange, 3);
//                   return;
//                 }

//                 final key = name
//                     .toLowerCase()
//                     .replaceAll(' ', '_')
//                     .replaceAll('é', 'e')
//                     .replaceAll('è', 'e')
//                     .replaceAll('ê', 'e')
//                     .replaceAll('à', 'a')
//                     .replaceAll('â', 'a')
//                     .replaceAll('ô', 'o')
//                     .replaceAll('û', 'u')
//                     .replaceAll('ç', 'c')
//                     .replaceAll("'", '_')
//                     .replaceAll('-', '_');

//                 final existingSpec =
//                     await LocalStorage.instance.getSpecialiteByNom(key);
//                 if (existingSpec != null) {
//                   _showSnackBar(
//                       'Cette filière existe déjà'.tr, Colors.orange, 3);
//                   return;
//                 }

//                 final newSpec = Specialite(
//                   idSpecialite: Generator.generateShortId('spc_'),
//                   libelleSpecialite: key,
//                   description: null,
//                   createdAt: now,
//                   syncState: SyncState.pending,
//                 );
//                 resultKey = await LocalStorage.instance.saveSpecialite(newSpec);
//                 newItemName = key.tr;
//                 setState(() {
//                   if (!_specialityKeys.contains(key)) {
//                     _specialityKeys.add(key);
//                   }
//                   final translatedName = key.tr;
//                   if (!_specialites.contains(translatedName)) {
//                     _specialites.add(translatedName);
//                   }
//                 });
//               } else if (entityType == 'source') {
//                 final name = nameCtrl.text.trim();
//                 if (name.isEmpty) {
//                   _showSnackBar('Veuillez remplir tous les champs obligatoires',
//                       Colors.orange, 3);
//                   return;
//                 }

//                 if (_sourcesInfos.contains(name)) {
//                   _showSnackBar(
//                       'Cette source existe déjà'.tr, Colors.orange, 3);
//                   return;
//                 }

//                 newItemName = name;
//                 setState(() {
//                   if (!_sourcesInfos.contains(name)) _sourcesInfos.add(name);
//                 });
//                 resultKey = 'success';
//               }

//               if (resultKey.contains('success')) {
//                 _showSnackBar(
//                   resultKey.tr,
//                   const Color(0xFF2E7D32),
//                   3,
//                 );
//                 Navigator.pop(context);
//                 onAdded(newItemName);
//               } else {
//                 _showSnackBar(resultKey.tr, Colors.orange, 3);
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF2E7D32),
//               foregroundColor: Colors.white,
//             ),
//             child: Text('add'.tr),
//           ),
//         ],
//       ),
//     );
//   }

//   // ─── Date / heure ────────────────────────────────────────────────────────

//   Widget _buildDateTimeField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//   }) {
//     const Color green = Color(0xFF2E7D32);

//     Future<void> pick(BuildContext ctx) async {
//       final date = await showDatePicker(
//         context: ctx,
//         initialDate: DateTime.now(),
//         firstDate: DateTime.now(),
//         lastDate: DateTime(2100),
//         builder: (c, child) => Theme(
//           data: Theme.of(c)
//               .copyWith(colorScheme: const ColorScheme.light(primary: green)),
//           child: child!,
//         ),
//       );
//       if (date == null || !mounted) return;
//       final time = await showTimePicker(
//         context: ctx,
//         initialTime: TimeOfDay.now(),
//         builder: (c, child) => Theme(
//           data: Theme.of(c)
//               .copyWith(colorScheme: const ColorScheme.light(primary: green)),
//           child: child!,
//         ),
//       );
//       if (time == null) return;
//       _date_relance =
//           DateTime(date.year, date.month, date.day, time.hour, time.minute);
//       controller.text = _formatDate(_date_relance!);
//     }

//     return GestureDetector(
//       onTap: () => pick(context),
//       child: AbsorbPointer(
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: green.withOpacity(0.5)),
//           ),
//           child: TextFormField(
//             controller: controller,
//             style: const TextStyle(fontSize: 13),
//             decoration: InputDecoration(
//               labelText: label,
//               hintText: hint,
//               prefixIcon:
//                   const Icon(Icons.calendar_today, color: green, size: 16),
//               suffixIcon: const Icon(Icons.access_time, color: green, size: 16),
//               border: InputBorder.none,
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//               labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ─── SAVE PROSPECT ────────────────────────────────────────────────────────

//   Future<void> _saveProspect() async {
//     if (_isSaving) return;
//     setState(() => _isSaving = true);

//     try {
//       if (!mounted) return;

//       LoadingService().show(context, message: 'saving_prospect'.tr);

//       if (!_formKey.currentState!.validate()) {
//         if (mounted) LoadingService().hide();
//         setState(() => _isSaving = false);
//         return;
//       }

//       if (_interetsList.isEmpty) {
//         if (mounted) LoadingService().hide();
//         _showSnackBar('add_specialty_warning'.tr, Colors.orange, 5);
//         _toggleSection('interet');
//         setState(() => _isSaving = false);
//         return;
//       }

//       if (_selectedEtablissement == null || _selectedEtablissement!.isEmpty) {
//         if (mounted) LoadingService().hide();
//         _showSnackBar('select_establishment_first'.tr, Colors.orange, 5);
//         _toggleSection('academiques');
//         setState(() => _isSaving = false);
//         return;
//       }

//       final Source? src = await LocalStorage.instance.getLastRecSource();
//       final Fiche? f = await LocalStorage.instance.getLastRecFiche();

//       if (src == null || f == null) {
//         if (mounted) LoadingService().hide();
//         _showSnackBar('missing_source_or_fiche'.tr, Colors.red, 5);
//         setState(() => _isSaving = false);
//         return;
//       }

//       final now = DateTime.now();

//       // ── ETABLISSEMENT ──
//       Etablissement? existingEts = await LocalStorage.instance
//           .getEtablissementByNom(_selectedEtablissement!);

//       Etablissement ets;

//       if (existingEts != null) {
//         ets = existingEts;
//       } else {
//         final isBac = _selectedNiveauEtude == 'Baccalauréat';
//         final type = isBac ? 'secondaire' : 'supérieur';

//         ets = Etablissement(
//           idEtablissement: Generator.generateShortId('ets_'),
//           nomEtablissement: _selectedEtablissement!.trim(),
//           typeEtablissement: type,
//           createdAt: now,
//           syncState: SyncState.pending,
//         );

//         final r = await LocalStorage.instance.saveEtablissement(ets);

//         if (!r.contains('success')) {
//           if (mounted) LoadingService().hide();
//           _showSnackBar(r.tr, Colors.orange, 3);
//           setState(() => _isSaving = false);
//           return;
//         }
//       }

//       // ── CLASSE ──
//       Classe classe;

//       String classKeyToUse;
//       if (_shouldShowClassField() &&
//           _selectedClasse != null &&
//           _selectedClasse!.isNotEmpty) {
//         String? classKey;
//         for (final key in _classKeys) {
//           if (key.tr == _selectedClasse) {
//             classKey = key;
//             break;
//           }
//         }
//         classKeyToUse = classKey ?? _selectedClasse!;
//       } else {
//         classKeyToUse =
//             '$_defaultClassPrefix${_selectedNiveauEtude.toLowerCase().replaceAll(' ', '_')}';
//       }

//       Classe? existingClasse =
//           await LocalStorage.instance.getClasseByLibelleAndEts(
//         classKeyToUse,
//         ets.idEtablissement,
//       );

//       if (existingClasse != null) {
//         classe = existingClasse;
//       } else {
//         final newClasse = Classe(
//           idClasse: Generator.generateShortId('cls_'),
//           idEts: ets.idEtablissement,
//           libelleClasse: classKeyToUse.trim(),
//           createdAt: now,
//           syncState: SyncState.pending,
//         );
//         newClasse.ets.value = ets;
//         final r = await LocalStorage.instance.saveClasse(newClasse);
//         if (!r.contains('success')) {
//           if (mounted) LoadingService().hide();
//           _showSnackBar(r.tr, Colors.orange, 3);
//           setState(() => _isSaving = false);
//           return;
//         }

//         classe = newClasse;
//       }

//       // ── PROSPECT ──
//       Prospect? existingProspect;
//       if (_isEditing && widget.prospectToEdit != null) {
//         existingProspect = await LocalStorage.instance
//             .getProspectById(widget.prospectToEdit!.idProspect);
//       }

//       final prospect = existingProspect ??
//           Prospect(
//             idProspect: Generator.generateShortId('prs_'),
//             idfiche: f.idFiche,
//             idClass: classe.idClasse,
//             nomComplet: _nomCompletCtrl.text.trim(),
//             telephone: _telephoneCtrl.text,
//             nomParent: _nomParentCtrl.text.trim(),
//             telephoneParent: _telephoneParentCtrl.text,
//             email: _emailCtrl.text.isEmpty ? null : _emailCtrl.text.trim(),
//             niveauEtude: _selectedNiveauEtude.trim(),
//             adresse:
//                 _adresseCtrl.text.isEmpty ? null : _adresseCtrl.text.trim(),
//             sexe: _selectedSexe,
//             typeProspect: _selectedTypeProspect,
//             commentaireGen: _commentaireCtrl.text.trim(),
//             date_relance: _date_relance,
//             createdAt: _isEditing ? widget.prospectToEdit!.createdAt : now,
//             source_infos: _selectedSource.trim(),
//             syncState: SyncState.pending,
//           );

//       bool hasProspectChanges = false;

//       if (_isEditing) {
//         hasProspectChanges = _hasChanged(
//                 prospect.nomComplet, _nomCompletCtrl.text.trim()) ||
//             _hasChanged(prospect.telephone, _telephoneCtrl.text) ||
//             _hasChanged(prospect.nomParent, _nomParentCtrl.text.trim()) ||
//             _hasChanged(prospect.telephoneParent, _telephoneParentCtrl.text) ||
//             _hasChanged(prospect.email,
//                 _emailCtrl.text.isEmpty ? null : _emailCtrl.text.trim()) ||
//             _hasChanged(prospect.niveauEtude, _selectedNiveauEtude.trim()) ||
//             _hasChanged(prospect.adresse,
//                 _adresseCtrl.text.isEmpty ? null : _adresseCtrl.text.trim()) ||
//             _hasChanged(prospect.sexe, _selectedSexe) ||
//             _hasChanged(prospect.typeProspect, _selectedTypeProspect) ||
//             _hasChanged(
//                 prospect.commentaireGen, _commentaireCtrl.text.trim()) ||
//             _hasChanged(prospect.date_relance, _date_relance) ||
//             _hasChanged(prospect.source_infos, _selectedSource.trim()) ||
//             _hasChanged(prospect.idClass, classe.idClasse);
//         print('🔍 Has prospect changes: $hasProspectChanges');

//         prospect.nomComplet = _nomCompletCtrl.text.trim();
//         prospect.telephone = _telephoneCtrl.text;
//         prospect.nomParent = _nomParentCtrl.text.trim();
//         prospect.telephoneParent = _telephoneParentCtrl.text;
//         prospect.email =
//             _emailCtrl.text.isEmpty ? null : _emailCtrl.text.trim();
//         prospect.niveauEtude = _selectedNiveauEtude.trim();
//         prospect.adresse =
//             _adresseCtrl.text.isEmpty ? null : _adresseCtrl.text.trim();
//         prospect.sexe = _selectedSexe;
//         prospect.typeProspect = _selectedTypeProspect;
//         prospect.commentaireGen = _commentaireCtrl.text.trim();
//         prospect.date_relance = _date_relance;
//         prospect.source_infos = _selectedSource.trim();
//         prospect.idClass = classe.idClasse;

//         if (hasProspectChanges) {
//           prospect.syncState = SyncState.toUpdate;
//           print('🔄 Prospect modifié, syncState = toUpdate');
//         }
//       }

//       prospect.classe.value = classe;
//       prospect.idClass = classe.idClasse;
//       prospect.fiche.value = f;
//       prospect.idfiche = f.idFiche;

//       String saveResult;

//       if (_isEditing) {
//         saveResult = await LocalStorage.instance.updateProspect(prospect);
//       } else {
//         saveResult = await LocalStorage.instance.saveProspect(prospect);
//       }

//       print('🔍 Prospect ID: ${prospect.idProspect}');
//       print('🔍 Prospect Name: ${prospect.nomComplet}');
//       print('🔍 SyncState: ${prospect.syncState}');
//       print('🔍 SyncState name: ${prospect.syncState.name}');

//       if (!saveResult.contains('success')) {
//         if (mounted) LoadingService().hide();
//         _showSnackBar(saveResult.tr, Colors.orange, 5);
//         setState(() => _isSaving = false);
//         return;
//       }

//       await LocalStorage.instance.isar.writeTxn(() async {
//         await prospect.classe.save();
//         await prospect.fiche.save();
//       });

//       bool hasInteretChanges = false;

//       if (_isEditing && existingProspect != null) {
//         await prospect.interets.load();

//         final existingInteretsMap = {
//           for (final interet in prospect.interets) interet.idInteret: interet
//         };

//         final Set<String> keptInteretIds = {};

//         for (var item in _interetsList) {
//           final specialiteKey = item['specialiteKey'] ?? item['specialite'];

//           Specialite? specialite =
//               await LocalStorage.instance.getSpecialiteByNom(specialiteKey);

//           if (specialite == null) {
//             specialite = Specialite(
//               idSpecialite: Generator.generateShortId('spc_'),
//               libelleSpecialite: specialiteKey.trim(),
//               description: null,
//               createdAt: now,
//               syncState: SyncState.pending,
//             );
//             await LocalStorage.instance.saveSpecialite(specialite);
//           }

//           final String? existingId = item['idInteret'];
//           InteretFiliere? interet;

//           if (existingId != null &&
//               existingInteretsMap.containsKey(existingId)) {
//             interet = existingInteretsMap[existingId]!;

//             final bool orderChanged =
//                 interet.ordrePreference != (item['ordrePreference'] ?? 0);
//             final bool levelChanged =
//                 interet.niveauInteret != (item['niveauInteret'] ?? 0);
//             final bool commentChanged =
//                 interet.commentaire != (item['commentaire'] ?? '');
//             final bool specChanged =
//                 interet.idSpecialite != specialite.idSpecialite;

//             if (orderChanged || levelChanged || commentChanged || specChanged) {
//               hasInteretChanges = true;
//               interet.syncState = SyncState.toUpdate;
//             }

//             interet.ordrePreference = item['ordrePreference'] ?? 0;
//             interet.niveauInteret = item['niveauInteret'] ?? 0;
//             interet.commentaire = item['commentaire'] ?? '';
//             interet.idSpecialite = specialite.idSpecialite;
//             interet.updatedAt = now;
//           } else {
//             hasInteretChanges = true;
//             interet = InteretFiliere(
//               idInteret: Generator.generateShortId('int_'),
//               idProspect: prospect.idProspect,
//               idSpecialite: specialite.idSpecialite,
//               ordrePreference: item['ordrePreference'] ?? 0,
//               niveauInteret: item['niveauInteret'] ?? 0,
//               commentaire: item['commentaire'] ?? '',
//               createdAt: now,
//               syncState: SyncState.pending,
//             );
//           }

//           interet.prospect.value = prospect;
//           interet.specialite.value = specialite;

//           await LocalStorage.instance.saveInteret(interet);

//           if (!prospect.interets.contains(interet)) {
//             prospect.interets.add(interet);
//           }

//           keptInteretIds.add(interet.idInteret);
//         }

//         for (final interet in prospect.interets) {
//           if (!keptInteretIds.contains(interet.idInteret)) {
//             hasInteretChanges = true;
//             await LocalStorage.instance.isar.writeTxn(() async {
//               await LocalStorage.instance.isar.interetFilieres
//                   .delete(interet.isarId);
//             });
//           }
//         }

//         await prospect.interets.load();

//         if (hasInteretChanges && !hasProspectChanges) {
//           prospect.syncState = SyncState.toUpdate;
//           await LocalStorage.instance.isar.writeTxn(() async {
//             await LocalStorage.instance.isar.prospects.put(prospect);
//           });
//           print('🔄 Intérêts modifiés, syncState = toUpdate');
//         }
//       } else {
//         int savedInterets = 0;

//         for (var item in _interetsList) {
//           final specialiteKey = item['specialiteKey'] ?? item['specialite'];

//           Specialite? specialite =
//               await LocalStorage.instance.getSpecialiteByNom(specialiteKey);

//           if (specialite == null) {
//             specialite = Specialite(
//               idSpecialite: Generator.generateShortId('spc_'),
//               libelleSpecialite: specialiteKey.trim(),
//               description: null,
//               createdAt: now,
//               syncState: SyncState.pending,
//             );
//             await LocalStorage.instance.saveSpecialite(specialite);
//           }

//           final interet = InteretFiliere(
//             idInteret: Generator.generateShortId('int_'),
//             idProspect: prospect.idProspect,
//             idSpecialite: specialite.idSpecialite,
//             ordrePreference: item['ordrePreference'] ?? 0,
//             niveauInteret: item['niveauInteret'] ?? 0,
//             commentaire: item['commentaire'] ?? '',
//             createdAt: now,
//             syncState: SyncState.pending,
//           );

//           interet.prospect.value = prospect;
//           interet.specialite.value = specialite;

//           await LocalStorage.instance.saveInteret(interet);
//           prospect.interets.add(interet);
//           savedInterets++;
//         }

//         if (prospect.interets.isNotEmpty) {
//           await LocalStorage.instance.isar.writeTxn(() async {
//             await prospect.interets.save();
//           });
//         }
//       }

//       // ── NOTIFICATION DE RELANCE AVEC GESTION DE LA DATE ──
//       if (_date_relance != null) {
//         final nowDateTime = DateTime.now();
//         final minFuture = nowDateTime.add(const Duration(minutes: 1));

//         if (_date_relance!.isAfter(minFuture)) {
//           try {
//             await NotificationService.instance.scheduleReminder(
//               prospectId: prospect.idProspect,
//               prospectName: prospect.nomComplet,
//               date: _date_relance!,
//               comment: _commentaireCtrl.text.trim().isNotEmpty
//                   ? _commentaireCtrl.text.trim()
//                   : 'Relance programmée',
//             );

//             _showSnackBar(
//               '💬 Notification programmée pour le ${_formatDate(_date_relance!)}',
//               const Color(0xFF2E7D32),
//               3,
//             );
//           } catch (e) {
//             print('❌ Erreur notification: $e');
//             _showSnackBar(
//               '⚠️ La notification n\'a pas pu être programmée',
//               Colors.orange,
//               3,
//             );
//           }
//         } else if (_date_relance!.isAfter(nowDateTime)) {
//           final adjustedDate = _date_relance!.add(const Duration(minutes: 1));
//           try {
//             await NotificationService.instance.scheduleReminder(
//               prospectId: prospect.idProspect,
//               prospectName: prospect.nomComplet,
//               date: adjustedDate,
//               comment: _commentaireCtrl.text.trim().isNotEmpty
//                   ? _commentaireCtrl.text.trim()
//                   : 'Relance programmée (décalée)',
//             );

//             _showSnackBar(
//               '💬 Notification programmée pour le ${_formatDate(adjustedDate)} (décalée)',
//               const Color(0xFF2E7D32),
//               3,
//             );
//           } catch (e) {
//             print('❌ Erreur notification: $e');
//             _showSnackBar(
//               '⚠️ La notification n\'a pas pu être programmée',
//               Colors.orange,
//               3,
//             );
//           }
//         } else {
//           _showSnackBar(
//             '⚠️ La date de relance est déjà passée',
//             Colors.orange,
//             3,
//           );
//         }
//       }

//       if (mounted) {
//         LoadingService().hide();
//         _showSnackBar(
//           _isEditing
//               ? 'prospect_updated'
//                   .tr
//                   .replaceFirst('{count}', '${_interetsList.length}')
//               : 'prospect_saved'
//                   .tr
//                   .replaceFirst('{count}', '${_interetsList.length}'),
//           const Color(0xFF2E7D32),
//           3,
//         );
//       }

//       _resetForm();
//     } catch (e, stackTrace) {
//       if (mounted) {
//         LoadingService().hide();
//         _showSnackBar('Erreur: $e', Colors.red, 5);
//       }
//       print('❌ Erreur dans _saveProspect: $e');
//       print('📚 Stack trace: $stackTrace');
//     } finally {
//       if (mounted) {
//         setState(() => _isSaving = false);
//       }
//     }
//   }

//   // ✅ Helper pour formater la date
//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year} à ${date.hour}h${date.minute.toString().padLeft(2, '0')}';
//   }

//   // ─── Reset ────────────────────────────────────────────────────────────────

//   void _resetForm() {
//     _nomCompletCtrl.clear();
//     _telephoneCtrl.clear();
//     _emailCtrl.clear();
//     _adresseCtrl.clear();
//     _commentaireCtrl.clear();
//     _concerneCtrl.clear();
//     setState(() {
//       _selectedSexe = '';
//       _selectedTypeProspect = '';
//       _selectedEtablissement = null;
//       _selectedClasse = null;
//       _selectedSource = '';
//       _selectedNiveauEtude = '';
//       _scoreInteret = 5;
//       _interetsList.clear();
//       _filteredEtablissementNames = _getFilteredEtablissementNames();
//     });
//     // _navigateBack();
//   }

//   // ─── Navigation ──────────────────────────────────────────────────────────

//   void _navigateBack() => Navigator.pop(context);

//   void _showLoadingDialog(String message) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         content: Column(mainAxisSize: MainAxisSize.min, children: [
//           const CircularProgressIndicator(),
//           const SizedBox(height: 16),
//           Text(message),
//         ]),
//       ),
//     );
//   }
// }














// ignore_for_file: unused_local_variable, prefer_final_fields, avoid_print, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:isetagcom/models/classe.dart';
import 'package:isetagcom/models/pros.dart';
import '../models/etablissement.dart';
import '../models/fiche.dart';
import '../models/interet_filiere.dart';
import '../models/localStorage/local_storage.dart';
import '../models/prospectData.dart';
import '../models/source.dart';
import '../models/specialite.dart';
import '../services/api_service.dart';
import '../services/loading_service.dart';
import '../services/translation_service.dart';
import '../services/notification_service.dart';
import '../utils/idGenerator.dart';
import '../utils/status.dart';
import '../utils/themes/glass_theme.dart';

class AddProspectScreen extends StatefulWidget {
  final Prospect? prospectToEdit;
  final ProspectDetails? prospectDetails;

  const AddProspectScreen({
    super.key,
    this.prospectToEdit,
    this.prospectDetails,
  });

  @override
  State<AddProspectScreen> createState() => _AddProspectScreenState();
}

class _AddProspectScreenState extends State<AddProspectScreen> {
  bool _isEditing = false;
  bool _isSaving = false;

  static const String _defaultClassPrefix = 'default_';

  final ApiService _apiService = ApiService();

  bool _hasChanged<T>(T? oldValue, T? newValue) {
    if (oldValue == null && newValue == null) return false;
    if (oldValue == null || newValue == null) return true;
    return oldValue != newValue;
  }

  @override
  void initState() {
    super.initState();
    _isEditing = widget.prospectToEdit != null;
    _initForm();
    _loadFromDb();
    if (_isEditing) {
      _loadProspectData();
    }
  }

  Future<void> _loadFromDb() async {
    await LocalStorage.instance.seedClassesIfEmpty();
    await LocalStorage.instance.seedSpecialtiesIfEmpty();

    final ets = await LocalStorage.instance.getAllEtablissements();
    final cls = await LocalStorage.instance.getAllClasses();
    final specs = await LocalStorage.instance.getAllSpecialites();

    setState(() {
      _allEtablissements = ets;

      _etablissementNames.clear();
      for (final e in ets) {
        if (!_etablissementNames.contains(e.nomEtablissement)) {
          _etablissementNames.add(e.nomEtablissement);
        }
      }

      _classes.clear();
      _classKeys.clear();
      for (final c in cls) {
        if (c.libelleClasse.startsWith(_defaultClassPrefix)) continue;
        _classKeys.add(c.libelleClasse);
        final translatedName = c.libelleClasse.tr;
        if (!_classes.contains(translatedName)) {
          _classes.add(translatedName);
        }
      }

      _specialites.clear();
      _specialityKeys.clear();
      for (final s in specs) {
        _specialityKeys.add(s.libelleSpecialite);
        final translatedName = s.libelleSpecialite.tr;
        if (!_specialites.contains(translatedName)) {
          _specialites.add(translatedName);
        }
      }

      _filteredEtablissementNames = _getFilteredEtablissementNames();
    });
  }

  Future<void> _loadProspectData() async {
    final prospect = widget.prospectToEdit;
    if (prospect == null) return;

    await prospect.classe.load();
    await prospect.fiche.load();
    await prospect.interets.load();
    for (final interet in prospect.interets) {
      await interet.specialite.load();
    }

    _nomCompletCtrl.text = prospect.nomComplet;
    _telephoneCtrl.text = prospect.telephone;
    _nomParentCtrl.text = prospect.nomParent;
    _telephoneParentCtrl.text = prospect.telephoneParent;
    _emailCtrl.text = prospect.email ?? '';
    _adresseCtrl.text = prospect.adresse ?? '';
    _commentaireCtrl.text = prospect.commentaireGen ?? '';

    _selectedSexe = prospect.sexe;
    _selectedTypeProspect = prospect.typeProspect;
    _selectedNiveauEtude = prospect.niveauEtude;

    if (prospect.classe.value != null) {
      final classe = prospect.classe.value!;
      await classe.ets.load();
      if (classe.ets.value != null) {
        _selectedEtablissement = classe.ets.value!.nomEtablissement;
      }
      if (!classe.libelleClasse.startsWith(_defaultClassPrefix)) {
        final translatedClasse = classe.libelleClasse.tr;
        if (_classes.contains(translatedClasse)) {
          _selectedClasse = translatedClasse;
        }
      }
    }

    _selectedSource = prospect.source_infos;

    if (prospect.date_relance != null) {
      _date_relance = prospect.date_relance;
      _relanceCtrl.text = _formatDate(_date_relance!);
    }

    _interetsList.clear();
    for (final interet in prospect.interets) {
      final specialite = interet.specialite.value;
      if (specialite != null) {
        final translatedName = specialite.libelleSpecialite.tr;
        _interetsList.add({
          'specialite': translatedName,
          'specialiteKey': specialite.libelleSpecialite,
          'ordrePreference': interet.ordrePreference,
          'niveauInteret': interet.niveauInteret,
          'commentaire': interet.commentaire ?? '',
          'idInteret': interet.idInteret,
          'idSpecialite': specialite.idSpecialite,
          'syncState': interet.syncState,
        });
      }
    }
    _interetsList
        .sort((a, b) => a['ordrePreference'].compareTo(b['ordrePreference']));

    _filteredEtablissementNames = _getFilteredEtablissementNames();

    setState(() {});
  }

  final _formKey = GlobalKey<FormState>();

  final _nomCompletCtrl = TextEditingController();
  final _telephoneCtrl = TextEditingController();
  final _nomParentCtrl = TextEditingController();
  final _telephoneParentCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _concerneCtrl = TextEditingController();
  final _adresseCtrl = TextEditingController();
  final _relanceCtrl = TextEditingController();
  final _commentaireCtrl = TextEditingController();

  final List<Map<String, dynamic>> _interetsList = [];

  final TextEditingController _newOrdrePreferenceCtrl = TextEditingController();
  final TextEditingController _newNiveauInteretCtrl = TextEditingController();
  final TextEditingController _newCommentaireInteretCtrl =
      TextEditingController();

  String? _selectedSpecialiteForInteret;
  String _selectedSexe = '';
  String _selectedTypeProspect = '';
  String? _selectedEtablissement;
  String? _selectedClasse;
  String _selectedSource = '';
  String _selectedNiveauEtude = '';
  int _scoreInteret = 5;

  DateTime now = DateTime.now();
  DateTime? _date_relance;

  int _currentStep = 0;
  final Map<String, bool> _sectionsExpanded = {
    'personnelles': true,
    'academiques': false,
    'interet': false,
    'commentaires': false,
    'relance': false,
  };

  List<Etablissement> _allEtablissements = [];
  final List<String> _etablissementNames = [];
  List<String> _filteredEtablissementNames = [];

  final List<String> _classes = [];
  List<String> _classKeys = [];

  final List<String> _specialites = [];
  List<String> _specialityKeys = [];

  List<String> _sourcesInfos = [
    'Réseaux sociaux',
    'Recommandation',
    'Site web',
    'Événement',
    'Prospection terrain',
    'Partenariat',
  ];

  final List<String> _sexeOptions = ['Masculin', 'Féminin'];
  final List<String> _typeProspectOptions = ['Étudiant', 'Éleve', 'Parent'];
  final List<String> _niveauEtudeOptions = [
    'Baccalauréat',
    'BTS 1',
    'BTS 2',
    'Licence',
    'Master 1',
  ];

  // ─── Helpers ──────────────────────────────────────────────────────────────

  bool _shouldShowClassField() {
    return _selectedNiveauEtude == 'Baccalauréat' &&
        (_selectedTypeProspect == 'Éleve' || _selectedTypeProspect == 'Parent');
  }

  List<String> _getFilteredEtablissementNames() {
    if (_selectedTypeProspect == 'Parent') {
      return _allEtablissements.map((e) => e.nomEtablissement).toList();
    }

    final targetType =
        _selectedNiveauEtude == 'Baccalauréat' ? 'secondaire' : 'supérieur';

    return _allEtablissements
        .where((e) => e.typeEtablissement == targetType)
        .map((e) => e.nomEtablissement)
        .toList();
  }

  List<String> _getAvailableNiveauEtudeOptions() {
    if (_selectedTypeProspect == 'Parent') {
      return _niveauEtudeOptions;
    }

    if (_selectedTypeProspect == 'Éleve') {
      return ['Baccalauréat'];
    }

    if (_selectedTypeProspect == 'Étudiant') {
      return _niveauEtudeOptions
          .where((level) => level != 'Baccalauréat')
          .toList();
    }

    return _niveauEtudeOptions;
  }

  List<String> _getAvailableTypeProspectOptions() {
    if (_selectedNiveauEtude == 'Baccalauréat') {
      return ['Éleve', 'Parent'];
    }

    return ['Étudiant', 'Parent'];
  }

  void _initForm() {
    if (_isEditing) return;

    _nomCompletCtrl.text = '';
    _telephoneCtrl.text = '';
    _nomParentCtrl.text = '';
    _telephoneParentCtrl.text = '';
    _emailCtrl.text = '';
    _concerneCtrl.text = '';
    _adresseCtrl.text = '';
    _commentaireCtrl.text = '';

    _selectedEtablissement =
        _etablissementNames.isNotEmpty ? _etablissementNames[0] : null;
    _selectedClasse = _classes.isNotEmpty ? _classes[0] : null;
    _selectedSexe = _sexeOptions[0];
    _selectedTypeProspect = 'Parent';
    _selectedNiveauEtude = _niveauEtudeOptions[0];
    _selectedSource = _sourcesInfos[0];
    _date_relance = null;
    _relanceCtrl.text = '';

    _newOrdrePreferenceCtrl.text = '1';
    _newNiveauInteretCtrl.text = '1';
    _newCommentaireInteretCtrl.text = 'no_comment'.tr;

    if (_specialites.isNotEmpty) {
      _selectedSpecialiteForInteret = _specialites[0];
    }

    _filteredEtablissementNames = _getFilteredEtablissementNames();
  }

  // ─── BUILD ────────────────────────────────────────────────────────────────

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
                  child: Stepper(
                    type: StepperType.vertical,
                    currentStep: _currentStep,
                    physics: const NeverScrollableScrollPhysics(),
                    onStepTapped: (step) => setState(() => _currentStep = step),
                    onStepContinue: () {
                      if (_currentStep < 4) {
                        setState(() => _currentStep += 1);
                      } else {
                        _saveProspect();
                      }
                    },
                    onStepCancel: () {
                      if (_currentStep > 0) {
                        setState(() => _currentStep -= 1);
                      }
                    },
                    controlsBuilder: (context, details) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            if (_currentStep == 4)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isSaving ? null : details.onStepContinue,
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
                                  child: Text(_isEditing ? 'update'.tr : 'save'.tr, style: const TextStyle(color: Colors.white)),
                                ),
                              )
                            else
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
                                  child: Text('next'.tr, style: const TextStyle(color: Colors.white)),
                                ),
                              ),
                            const SizedBox(width: 12),
                            if (_currentStep > 0)
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: details.onStepCancel,
                                  child: Text('previous'.tr),
                                ),
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextButton(
                                onPressed: _resetForm,
                                child: Text('clear'.tr, style: const TextStyle(color: Colors.red)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    steps: [
                      Step(
                        title: Text('personal_info'.tr),
                        isActive: _currentStep >= 0,
                        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                        content: Column(
                          children: [
                            _buildTextField(
                                controller: _nomCompletCtrl,
                                label: 'full_name'.tr,
                                hint: 'enter_full_name'.tr,
                                icon: Icons.person_outline,
                                required: true),
                            const SizedBox(height: 12),
                            _buildPhoneField(
                                controller: _telephoneCtrl,
                                label: 'phone'.tr,
                                hint: 'enter_phone'.tr,
                                icon: Icons.phone_outlined,
                                required: true),
                            const SizedBox(height: 12),
                            _buildTextField(
                                controller: _nomParentCtrl,
                                label: 'name_par'.tr,
                                hint: 'enter_full_name'.tr,
                                icon: Icons.person_outline),
                            const SizedBox(height: 12),
                            _buildPhoneField(
                                controller: _telephoneParentCtrl,
                                label: 'phone_par'.tr,
                                hint: 'enter_phone'.tr,
                                icon: Icons.phone_outlined),
                            const SizedBox(height: 12),
                            _buildTextField(
                                controller: _emailCtrl,
                                label: 'email'.tr,
                                hint: 'enter_email'.tr,
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress),
                            const SizedBox(height: 12),
                            _buildDropdownField(
                              value: _selectedSexe,
                              label: 'gender'.tr,
                              hint: 'select'.tr,
                              icon: Icons.man_2,
                              items: _sexeOptions,
                              onChanged: (v) => setState(() => _selectedSexe = v!),
                            ),
                            const SizedBox(height: 12),
                            _buildDropdownField(
                              value: _selectedNiveauEtude,
                              label: 'education_level'.tr,
                              hint: 'select'.tr,
                              icon: Icons.school_outlined,
                              items: _getAvailableNiveauEtudeOptions(),
                              onChanged: (v) {
                                setState(() {
                                  _selectedNiveauEtude = v!;
                                  if (_selectedNiveauEtude == 'Baccalauréat' && _selectedTypeProspect == 'Étudiant') {
                                    _selectedTypeProspect = 'Éleve';
                                  }
                                  _filteredEtablissementNames = _getFilteredEtablissementNames();
                                  if (_selectedEtablissement != null && !_filteredEtablissementNames.contains(_selectedEtablissement)) {
                                    _selectedEtablissement = null;
                                  }
                                  if (!_shouldShowClassField()) _selectedClasse = null;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildDropdownField(
                              value: _selectedTypeProspect,
                              label: 'who_is_prospect'.tr,
                              hint: 'select'.tr,
                              icon: Icons.category_outlined,
                              items: _getAvailableTypeProspectOptions(),
                              onChanged: (v) {
                                setState(() {
                                  _selectedTypeProspect = v!;
                                  if (_selectedTypeProspect == 'Étudiant' && _selectedNiveauEtude == 'Baccalauréat') {
                                    _selectedNiveauEtude = '';
                                  }
                                  if (!_shouldShowClassField()) _selectedClasse = null;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                                controller: _adresseCtrl,
                                label: 'address'.tr,
                                hint: 'full_address'.tr,
                                icon: Icons.location_on_outlined),
                          ],
                        ),
                      ),
                      Step(
                        title: Text('academic_info'.tr),
                        isActive: _currentStep >= 1,
                        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                        content: Column(
                          children: [
                            _buildEntityPickerField(
                              value: _selectedEtablissement,
                              label: 'establishment'.tr,
                              hint: 'select_or_add'.tr,
                              icon: Icons.school_outlined,
                              entityType: 'etablissement',
                              items: _filteredEtablissementNames,
                              onChanged: (value) => setState(() => _selectedEtablissement = value),
                            ),
                            if (_shouldShowClassField()) ...[
                              const SizedBox(height: 12),
                              _buildEntityPickerField(
                                value: _selectedClasse,
                                label: 'class'.tr,
                                hint: 'select_or_add'.tr,
                                icon: Icons.class_outlined,
                                entityType: 'classe',
                                items: _classes,
                                onChanged: (value) => setState(() => _selectedClasse = value),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Step(
                        title: Text('interest_source'.tr),
                        isActive: _currentStep >= 2,
                        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                        content: Column(
                          children: [
                            _buildDropdownField(
                              value: _selectedSource,
                              label: 'source'.tr,
                              hint: 'select_or_add'.tr,
                              icon: Icons.sensors_rounded,
                              items: _sourcesInfos,
                              onChanged: (value) => setState(() => _selectedSource = value!),
                              onAdd: (newValue) {
                                setState(() {
                                  _sourcesInfos.add(newValue);
                                  _selectedSource = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildInteretsListSection(),
                          ],
                        ),
                      ),
                      Step(
                        title: Text('comments'.tr),
                        isActive: _currentStep >= 3,
                        state: _currentStep > 3 ? StepState.complete : StepState.indexed,
                        content: _buildTextField(
                          controller: _commentaireCtrl,
                          label: 'general_comment'.tr,
                          hint: 'add_observations'.tr,
                          icon: Icons.comment_outlined,
                          maxLines: 3,
                        ),
                      ),
                      Step(
                        title: Text('schedule_followup'.tr),
                        isActive: _currentStep >= 4,
                        state: _currentStep > 4 ? StepState.complete : StepState.indexed,
                        content: _buildDateTimeField(
                          controller: _relanceCtrl,
                          label: 'followup_date'.tr,
                          hint: 'schedule_followup'.tr,
                        ),
                      ),
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

  // ─── Phone Field with African Regex ──────────────────────────────────────

  Widget _buildPhoneField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
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
        keyboardType: TextInputType.phone,
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
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'required_field'.tr;
          }
          if (required && value != null && value.isNotEmpty) {
            final africanPhoneRegex = RegExp(r'^(6|2|5|7|9|0)[0-9]{8}$');
            if (!africanPhoneRegex.hasMatch(value)) {
              return 'Numéro de téléphone invalide (ex: 6XXXXXXXX)'.tr;
            }
          }
          return null;
        },
      ),
    );
  }

  // ─── Section toggle ───────────────────────────────────────────────────────

  void _toggleSection(String section) =>
      setState(() => _sectionsExpanded[section] = !_sectionsExpanded[section]!);

  // ─── Expandable section wrapper ───────────────────────────────────────────

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

  // ─── Intérêts section ─────────────────────────────────────────────────────

  Widget _buildInteretsListSection() {
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
              separatorBuilder: (_, __) => const Divider(height: 1),
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
                    onPressed: () => setState(() {
                      _interetsList.removeAt(index);
                      for (int i = 0; i < _interetsList.length; i++) {
                        _interetsList[i]['ordrePreference'] = i + 1;
                      }
                    }),
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
                _buildEntityPickerField(
                  value: _selectedSpecialiteForInteret,
                  label: 'specialty_field'.tr,
                  hint: 'select_specialty'.tr,
                  icon: Icons.school_outlined,
                  entityType: 'specialite',
                  items: _specialites
                      .where((spec) =>
                          !_interetsList.any((i) => i['specialite'] == spec))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedSpecialiteForInteret = value),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _buildSmallTextField(
                      controller: _newNiveauInteretCtrl,
                      label: 'level'.tr,
                      hint: 'level_hint'.tr,
                      icon: Icons.star_outline,
                      keyboardType: TextInputType.number,
                    )),
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

  void _addInteret() {
    final specialite = _selectedSpecialiteForInteret;
    final ordrePreference = _interetsList.length + 1;
    final niveauInteret = int.tryParse(_newNiveauInteretCtrl.text.trim());

    if (specialite == null || specialite.isEmpty) {
      _showSnackBar('select_specialty_warning'.tr, Colors.orange, 5);
      return;
    }
    if (niveauInteret == null || niveauInteret < 1 || niveauInteret > 5) {
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

    String? key;
    for (final specKey in _specialityKeys) {
      if (specKey.tr == specialite) {
        key = specKey;
        break;
      }
    }
    final specialiteKey = key ?? specialite;

    setState(() {
      _interetsList.add({
        'specialite': specialite,
        'specialiteKey': specialiteKey,
        'ordrePreference': ordrePreference,
        'niveauInteret': niveauInteret,
        'commentaire':
            _newCommentaireInteretCtrl.text.trim() ?? 'no_comment'.tr,
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
    final niveauCtrl =
        TextEditingController(text: interet['niveauInteret'].toString());
    final commentCtrl = TextEditingController(text: interet['commentaire']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('modify_specialty'
            .tr
            .replaceFirst('{specialty}', interet['specialite'])),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          _buildSmallTextField(
              controller: niveauCtrl,
              label: 'level'.tr,
              hint: 'level_hint'.tr,
              icon: Icons.star_outline),
          const SizedBox(height: 12),
          _buildSmallTextField(
              controller: commentCtrl,
              label: 'comment'.tr,
              hint: 'specify_interest'.tr,
              icon: Icons.comment_outlined,
              maxLines: 2),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr)),
          ElevatedButton(
            onPressed: () {
              final ordre = interet['ordrePreference'];
              final niveau = int.tryParse(niveauCtrl.text);
              if (ordre != null &&
                  ordre >= 1 &&
                  niveau != null &&
                  niveau >= 1 &&
                  niveau <= 10) {
                setState(() {
                  _interetsList[index]['ordrePreference'] = ordre;
                  _interetsList[index]['niveauInteret'] = niveau;
                  _interetsList[index]['commentaire'] = commentCtrl.text;
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

  // ─── Snack bar ────────────────────────────────────────────────────────────

  void _showSnackBar(String message, Color color, int dur) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: Duration(seconds: dur)),
    );
  }

  // ─── UI Helpers ───────────────────────────────────────────────────────────

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
              onTap: () => _resetForm(),
              child:
                  const Icon(Icons.close, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _isEditing ? 'edit_prospect'.tr : 'new_prospect'.tr,
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

  // ─── Champ avec sélecteur en bottom sheet avec filtre ───────────────────

  Widget _buildEntityPickerField({
    required String? value,
    required String label,
    required String hint,
    required IconData icon,
    required String entityType,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return GestureDetector(
      onTap: () => _showEntityPickerBottomSheet(
        entityType: entityType,
        currentValue: value,
        items: items,
        onSelect: onChanged,
      ),
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
                child: Text(
                  value ?? hint,
                  style: TextStyle(
                      color: value != null ? Colors.black87 : Colors.grey,
                      fontSize: 14),
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Color(0xFF2E7D32)),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Dropdown simple avec filtre ─────────────────────────────────────────

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
    Function(String)? onAdd,
  }) {
    return GestureDetector(
      onTap: () {
        if (onAdd != null) {
          _showEntityPickerBottomSheet(
            entityType: 'source',
            currentValue: value,
            items: items,
            onSelect: onChanged,
            onAdd: onAdd,
          );
        } else {
          _showSimpleSearchableDialog(items, label, onChanged);
        }
      },
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
                child: Text(
                  value ?? hint,
                  style: TextStyle(
                      color: value != null ? Colors.black87 : Colors.grey,
                      fontSize: 14),
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Color(0xFF2E7D32)),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Bottom sheet de sélection avec filtre ──────────────────────────────

  void _showEntityPickerBottomSheet({
    required String entityType,
    required String? currentValue,
    required List<String> items,
    required Function(String?) onSelect,
    Function(String)? onAdd,
  }) {
    String title;
    IconData icon;
    Color iconColor = const Color(0xFF2E7D32);

    switch (entityType) {
      case 'etablissement':
        title = 'Établissement';
        icon = Icons.school_outlined;
        break;
      case 'classe':
        title = 'Classe';
        icon = Icons.class_outlined;
        break;
      case 'specialite':
        title = 'Filières';
        icon = Icons.school_outlined;
        break;
      case 'source':
        title = 'Sources';
        icon = Icons.sensors_rounded;
        break;
      default:
        title = entityType;
        icon = Icons.list;
    }

    // ✅ Build itemMap BEFORE showModalBottomSheet
    final List<Map<String, String>> itemMap = items.map((key) {
      return {
        'key': key,
        'translated': key.tr,
      };
    }).toList();

    itemMap.sort((a, b) => a['translated']!.compareTo(b['translated']!));

    // ✅ State variables at the showModalBottomSheet level
    String searchQuery = '';
    List<Map<String, String>> filteredItems = List.from(itemMap);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setBottomState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              maxChildSize: 0.9,
              minChildSize: 0.3,
              builder: (_, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(icon, color: iconColor, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            '${'select'.tr} $title',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'search'.tr,
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear,
                                      color: Colors.grey.shade400),
                                  onPressed: () {
                                    // ✅ Use setBottomState to update the persisted variables
                                    setBottomState(() {
                                      searchQuery = '';
                                      filteredItems = List.from(itemMap);
                                    });
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (query) {
                          // ✅ Use setBottomState to update the persisted variables
                          setBottomState(() {
                            searchQuery = query.trim();

                            if (searchQuery.isEmpty) {
                              filteredItems = List.from(itemMap);
                            } else {
                              final lowerQuery = searchQuery.toLowerCase();
                              filteredItems = itemMap.where((item) {
                                final translated =
                                    item['translated']!.toLowerCase();
                                return translated.contains(lowerQuery);
                              }).toList();

                              filteredItems.sort((a, b) {
                                final aTranslated =
                                    a['translated']!.toLowerCase();
                                final bTranslated =
                                    b['translated']!.toLowerCase();
                                final aStartsWith =
                                    aTranslated.startsWith(lowerQuery);
                                final bStartsWith =
                                    bTranslated.startsWith(lowerQuery);
                                if (aStartsWith && !bStartsWith) return -1;
                                if (!aStartsWith && bStartsWith) return 1;
                                return aTranslated.compareTo(bTranslated);
                              });
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      if (filteredItems.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '${filteredItems.length} résultat${filteredItems.length > 1 ? 's' : ''}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      Expanded(
                        child: filteredItems.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 48,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'no_result'.tr,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: filteredItems.length,
                                itemBuilder: (_, index) {
                                  final item = filteredItems[index];
                                  final key = item['key']!;
                                  final translated = item['translated']!;
                                  final isSelected = key == currentValue;

                                  return ListTile(
                                    leading: Icon(
                                      isSelected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      color: isSelected
                                          ? const Color(0xFF2E7D32)
                                          : Colors.grey,
                                    ),
                                    title: Text(
                                      translated,
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? const Color(0xFF2E7D32)
                                            : Colors.black87,
                                      ),
                                    ),
                                    onTap: () {
                                      onSelect(key);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showAddEntityDialog(
                                entityType,
                                onAdded: (newItem) {
                                  onSelect(newItem);
                                  Navigator.pop(context);
                                },
                              );
                            },
                            icon: const Icon(Icons.add, size: 20),
                            label: Text(
                              'add'.tr + ' $title'.replaceFirst('s', ''),
                              style: const TextStyle(fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
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
      },
    ).whenComplete(() {
      // ✅ Clean up when bottom sheet is closed
      // Reset state variables to prevent memory leaks
      searchQuery = '';
      filteredItems = List.from(itemMap);
    });
  }
  // ─── Dialogue de sélection simple avec filtre ────────────────────────────

  void _showSimpleSearchableDialog(
      List<String> items, String title, Function(String?) onChanged) {
    final searchCtrl = TextEditingController();
    List<String> filtered = List.from(items);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, ss) => Dialog(
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
                  controller: searchCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'search'.tr,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchCtrl.clear();
                              ss(() => filtered = List.from(items));
                            })
                        : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (v) => ss(() {
                    filtered = v.isEmpty
                        ? List.from(items)
                        : items
                            .where((i) =>
                                i.toLowerCase().contains(v.toLowerCase()))
                            .toList();
                  }),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: filtered.isEmpty
                      ? Center(
                          child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text('no_result'.tr),
                        ))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: filtered.length,
                          itemBuilder: (_, i) => ListTile(
                            leading: const Icon(Icons.check_circle_outline,
                                color: Color(0xFF2E7D32)),
                            title: Text(filtered[i]),
                            onTap: () {
                              onChanged(filtered[i]);
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

  void _showAddEntityDialog(String entityType,
      {required Function(String) onAdded}) {
    final nameCtrl = TextEditingController();
    String? selectedType;
    final addressCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    final regionCtrl = TextEditingController();
    final classCtrl = TextEditingController();
    final specialityCtrl = TextEditingController();

    String dialogTitle;
    switch (entityType) {
      case 'etablissement':
        dialogTitle = 'Ajouter un établissement';
        break;
      case 'classe':
        dialogTitle = 'Ajouter une classe';
        break;
      case 'specialite':
        dialogTitle = 'Ajouter une filière';
        break;
      case 'source':
        dialogTitle = 'Ajouter une source';
        break;
      default:
        dialogTitle = 'Ajouter';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(dialogTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (entityType == 'etablissement') ...[
                TextField(
                  controller: nameCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Nom de l\'établissement *',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  hint: const Text('Type d\'établissement *'),
                  items: const [
                    DropdownMenuItem(
                        value: 'secondaire',
                        child: Text('Secondaire (Lycée/collège)')),
                    DropdownMenuItem(
                        value: 'supérieur',
                        child: Text('Supérieur (Université)')),
                  ],
                  onChanged: (value) => selectedType = value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ] else if (entityType == 'classe') ...[
                if (_selectedEtablissement == null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      'school_first'.tr,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ] else ...[
                  TextField(
                    controller: classCtrl,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Nom de la classe *',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.school, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Établissement: $_selectedEtablissement',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ] else if (entityType == 'specialite') ...[
                TextField(
                  controller: specialityCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Nom de la filière *',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ] else if (entityType == 'source') ...[
                TextField(
                  controller: nameCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Nom de la source *',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
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
              final now = DateTime.now();
              String resultKey = 'error';
              String newItemName = '';

              if (entityType == 'etablissement') {
                final name = nameCtrl.text.trim();
                if (name.isEmpty || selectedType == null) {
                  _showSnackBar('Veuillez remplir tous les champs obligatoires',
                      Colors.orange, 3);
                  return;
                }

                final existingEts =
                    await LocalStorage.instance.getEtablissementByNom(name);
                if (existingEts != null) {
                  _showSnackBar(
                      'Cet établissement existe déjà'.tr, Colors.orange, 3);
                  return;
                }

                final newEts = Etablissement(
                  idEtablissement: Generator.generateShortId('ets_'),
                  nomEtablissement: name.trim(),
                  typeEtablissement: selectedType,
                  adresse: addressCtrl.text.trim().isEmpty
                      ? null
                      : addressCtrl.text.trim(),
                  telephone: phoneCtrl.text.trim().isEmpty
                      ? null
                      : phoneCtrl.text.trim(),
                  ville: cityCtrl.text.trim().isEmpty
                      ? null
                      : cityCtrl.text.trim(),
                  region: regionCtrl.text.trim().isEmpty
                      ? null
                      : regionCtrl.text.trim(),
                  createdAt: now,
                  syncState: SyncState.pending,
                );
                resultKey =
                    await LocalStorage.instance.saveEtablissement(newEts);
                newItemName = name;
                setState(() {
                  if (!_etablissementNames.contains(name)) {
                    _etablissementNames.add(name);
                  }
                  _allEtablissements.add(newEts);
                  _filteredEtablissementNames =
                      _getFilteredEtablissementNames();
                });
              } else if (entityType == 'classe') {
                final name = classCtrl.text.trim();
                if (name.isEmpty || _selectedEtablissement == null) {
                  _showSnackBar('Veuillez remplir tous les champs obligatoires',
                      Colors.orange, 3);
                  return;
                }

                final key =
                    'class_${name.toLowerCase().replaceAll(' ', '_').replaceAll('é', 'e').replaceAll('è', 'e').replaceAll('ê', 'e').replaceAll('à', 'a').replaceAll('â', 'a').replaceAll('ô', 'o').replaceAll('û', 'u').replaceAll('ç', 'c').replaceAll("'", '_').replaceAll('-', '_').replaceAll(':', '').replaceAll('/', '_').replaceAll('(', '').replaceAll(')', '')}';

                Etablissement? existingEts = await LocalStorage.instance
                    .getEtablissementByNom(_selectedEtablissement!);
                String etsId;
                if (existingEts != null) {
                  etsId = existingEts.idEtablissement;
                } else {
                  final type = _selectedNiveauEtude == 'Baccalauréat'
                      ? 'secondaire'
                      : 'supérieur';
                  final newEts = Etablissement(
                    idEtablissement: Generator.generateShortId('ets_'),
                    nomEtablissement: _selectedEtablissement!,
                    typeEtablissement: type,
                    createdAt: now,
                    syncState: SyncState.pending,
                  );
                  await LocalStorage.instance.saveEtablissement(newEts);
                  etsId = newEts.idEtablissement;
                  setState(() {
                    if (!_etablissementNames
                        .contains(_selectedEtablissement!)) {
                      _etablissementNames.add(_selectedEtablissement!);
                    }
                    _allEtablissements.add(newEts);
                    _filteredEtablissementNames =
                        _getFilteredEtablissementNames();
                  });
                }

                final existingClasse = await LocalStorage.instance
                    .getClasseByLibelleAndEts(key, etsId);
                if (existingClasse != null) {
                  _showSnackBar(
                      'Cette classe existe déjà dans cet établissement'.tr,
                      Colors.orange,
                      3);
                  return;
                }

                final newClasse = Classe(
                  idClasse: Generator.generateShortId('cls_'),
                  idEts: etsId,
                  libelleClasse: key,
                  createdAt: now,
                  syncState: SyncState.pending,
                );
                resultKey = await LocalStorage.instance.saveClasse(newClasse);
                newItemName = name;
                setState(() {
                  if (!_classKeys.contains(key)) {
                    _classKeys.add(key);
                  }
                  final translatedName = key.tr;
                  if (!_classes.contains(translatedName)) {
                    _classes.add(translatedName);
                  }
                });
              } else if (entityType == 'specialite') {
                final name = specialityCtrl.text.trim();
                if (name.isEmpty) {
                  _showSnackBar('Veuillez remplir tous les champs obligatoires',
                      Colors.orange, 3);
                  return;
                }

                final key = name
                    .toLowerCase()
                    .replaceAll(' ', '_')
                    .replaceAll('é', 'e')
                    .replaceAll('è', 'e')
                    .replaceAll('ê', 'e')
                    .replaceAll('à', 'a')
                    .replaceAll('â', 'a')
                    .replaceAll('ô', 'o')
                    .replaceAll('û', 'u')
                    .replaceAll('ç', 'c')
                    .replaceAll("'", '_')
                    .replaceAll('-', '_');

                final existingSpec =
                    await LocalStorage.instance.getSpecialiteByNom(key);
                if (existingSpec != null) {
                  _showSnackBar(
                      'Cette filière existe déjà'.tr, Colors.orange, 3);
                  return;
                }

                final newSpec = Specialite(
                  idSpecialite: Generator.generateShortId('spc_'),
                  libelleSpecialite: key,
                  description: null,
                  createdAt: now,
                  syncState: SyncState.pending,
                );
                resultKey = await LocalStorage.instance.saveSpecialite(newSpec);
                newItemName = key.tr;
                setState(() {
                  if (!_specialityKeys.contains(key)) {
                    _specialityKeys.add(key);
                  }
                  final translatedName = key.tr;
                  if (!_specialites.contains(translatedName)) {
                    _specialites.add(translatedName);
                  }
                });
              } else if (entityType == 'source') {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) {
                  _showSnackBar('Veuillez remplir tous les champs obligatoires',
                      Colors.orange, 3);
                  return;
                }

                if (_sourcesInfos.contains(name)) {
                  _showSnackBar(
                      'Cette source existe déjà'.tr, Colors.orange, 3);
                  return;
                }

                newItemName = name;
                setState(() {
                  if (!_sourcesInfos.contains(name)) _sourcesInfos.add(name);
                });
                resultKey = 'success';
              }

              if (resultKey.contains('success')) {
                _showSnackBar(
                  resultKey.tr,
                  const Color(0xFF2E7D32),
                  3,
                );
                Navigator.pop(context);
                onAdded(newItemName);
              } else {
                _showSnackBar(resultKey.tr, Colors.orange, 3);
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

  // ─── Date / heure ────────────────────────────────────────────────────────

  Widget _buildDateTimeField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    const Color green = Color(0xFF2E7D32);

    Future<void> pick(BuildContext ctx) async {
      final date = await showDatePicker(
        context: ctx,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        builder: (c, child) => Theme(
          data: Theme.of(c)
              .copyWith(colorScheme: const ColorScheme.light(primary: green)),
          child: child!,
        ),
      );
      if (date == null || !mounted) return;
      final time = await showTimePicker(
        context: ctx,
        initialTime: TimeOfDay.now(),
        builder: (c, child) => Theme(
          data: Theme.of(c)
              .copyWith(colorScheme: const ColorScheme.light(primary: green)),
          child: child!,
        ),
      );
      if (time == null) return;
      _date_relance =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      controller.text = _formatDate(_date_relance!);
    }

    return GestureDetector(
      onTap: () => pick(context),
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

  // ─── SAVE PROSPECT ────────────────────────────────────────────────────────

  Future<void> _saveProspect() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      if (!mounted) return;

      LoadingService().show(context, message: 'saving_prospect'.tr);

      if (!_formKey.currentState!.validate()) {
        if (mounted) LoadingService().hide();
        setState(() => _isSaving = false);
        return;
      }

      if (_interetsList.isEmpty) {
        if (mounted) LoadingService().hide();
        _showSnackBar('add_specialty_warning'.tr, Colors.orange, 5);
        _toggleSection('interet');
        setState(() => _isSaving = false);
        return;
      }

      // Restrictions removed for establishment based on user feedback

      final Source? src = await LocalStorage.instance.getLastRecSource();
      final Fiche? f = await LocalStorage.instance.getLastRecFiche();

      if (src == null || f == null) {
        if (mounted) LoadingService().hide();
        _showSnackBar('missing_source_or_fiche'.tr, Colors.red, 5);
        setState(() => _isSaving = false);
        return;
      }

      final now = DateTime.now();

      // ── ETABLISSEMENT ──
      Etablissement? existingEts = await LocalStorage.instance
          .getEtablissementByNom(_selectedEtablissement!);

      Etablissement ets;

      if (existingEts != null) {
        ets = existingEts;
      } else {
        final isBac = _selectedNiveauEtude == 'Baccalauréat';
        final type = isBac ? 'secondaire' : 'supérieur';

        ets = Etablissement(
          idEtablissement: Generator.generateShortId('ets_'),
          nomEtablissement: _selectedEtablissement!.trim(),
          typeEtablissement: type,
          createdAt: now,
          syncState: SyncState.pending,
        );

        final r = await LocalStorage.instance.saveEtablissement(ets);

        if (!r.contains('success')) {
          if (mounted) LoadingService().hide();
          _showSnackBar(r.tr, Colors.orange, 3);
          setState(() => _isSaving = false);
          return;
        }
      }

      // ── CLASSE ──
      Classe classe;

      String classKeyToUse;
      if (_shouldShowClassField() &&
          _selectedClasse != null &&
          _selectedClasse!.isNotEmpty) {
        String? classKey;
        for (final key in _classKeys) {
          if (key.tr == _selectedClasse) {
            classKey = key;
            break;
          }
        }
        classKeyToUse = classKey ?? _selectedClasse!;
      } else {
        classKeyToUse =
            '$_defaultClassPrefix${_selectedNiveauEtude.toLowerCase().replaceAll(' ', '_')}';
      }

      Classe? existingClasse =
          await LocalStorage.instance.getClasseByLibelleAndEts(
        classKeyToUse,
        ets.idEtablissement,
      );

      if (existingClasse != null) {
        classe = existingClasse;
      } else {
        final newClasse = Classe(
          idClasse: Generator.generateShortId('cls_'),
          idEts: ets.idEtablissement,
          libelleClasse: classKeyToUse.trim(),
          createdAt: now,
          syncState: SyncState.pending,
        );
        newClasse.ets.value = ets;
        final r = await LocalStorage.instance.saveClasse(newClasse);
        if (!r.contains('success')) {
          if (mounted) LoadingService().hide();
          _showSnackBar(r.tr, Colors.orange, 3);
          setState(() => _isSaving = false);
          return;
        }

        classe = newClasse;
      }

      // ── PROSPECT ──
      Prospect? existingProspect;
      if (_isEditing && widget.prospectToEdit != null) {
        existingProspect = await LocalStorage.instance
            .getProspectById(widget.prospectToEdit!.idProspect);
      }

      final prospect = existingProspect ??
          Prospect(
            idProspect: Generator.generateShortId('prs_'),
            idfiche: f.idFiche,
            idClass: classe.idClasse,
            nomComplet: _nomCompletCtrl.text.trim(),
            telephone: _telephoneCtrl.text,
            nomParent: _nomParentCtrl.text.trim(),
            telephoneParent: _telephoneParentCtrl.text,
            email: _emailCtrl.text.isEmpty ? null : _emailCtrl.text.trim(),
            niveauEtude: _selectedNiveauEtude.trim(),
            adresse:
                _adresseCtrl.text.isEmpty ? null : _adresseCtrl.text.trim(),
            sexe: _selectedSexe,
            typeProspect: _selectedTypeProspect,
            commentaireGen: _commentaireCtrl.text.trim(),
            date_relance: _date_relance,
            createdAt: _isEditing ? widget.prospectToEdit!.createdAt : now,
            source_infos: _selectedSource.trim(),
            syncState: SyncState.pending,
          );

      bool hasProspectChanges = false;

      if (_isEditing) {
        hasProspectChanges = _hasChanged(
                prospect.nomComplet, _nomCompletCtrl.text.trim()) ||
            _hasChanged(prospect.telephone, _telephoneCtrl.text) ||
            _hasChanged(prospect.nomParent, _nomParentCtrl.text.trim()) ||
            _hasChanged(prospect.telephoneParent, _telephoneParentCtrl.text) ||
            _hasChanged(prospect.email,
                _emailCtrl.text.isEmpty ? null : _emailCtrl.text.trim()) ||
            _hasChanged(prospect.niveauEtude, _selectedNiveauEtude.trim()) ||
            _hasChanged(prospect.adresse,
                _adresseCtrl.text.isEmpty ? null : _adresseCtrl.text.trim()) ||
            _hasChanged(prospect.sexe, _selectedSexe) ||
            _hasChanged(prospect.typeProspect, _selectedTypeProspect) ||
            _hasChanged(
                prospect.commentaireGen, _commentaireCtrl.text.trim()) ||
            _hasChanged(prospect.date_relance, _date_relance) ||
            _hasChanged(prospect.source_infos, _selectedSource.trim()) ||
            _hasChanged(prospect.idClass, classe.idClasse);
        print('🔍 Has prospect changes: $hasProspectChanges');

        prospect.nomComplet = _nomCompletCtrl.text.trim();
        prospect.telephone = _telephoneCtrl.text;
        prospect.nomParent = _nomParentCtrl.text.trim();
        prospect.telephoneParent = _telephoneParentCtrl.text;
        prospect.email =
            _emailCtrl.text.isEmpty ? null : _emailCtrl.text.trim();
        prospect.niveauEtude = _selectedNiveauEtude.trim();
        prospect.adresse =
            _adresseCtrl.text.isEmpty ? null : _adresseCtrl.text.trim();
        prospect.sexe = _selectedSexe;
        prospect.typeProspect = _selectedTypeProspect;
        prospect.commentaireGen = _commentaireCtrl.text.trim();
        prospect.date_relance = _date_relance;
        prospect.source_infos = _selectedSource.trim();
        prospect.idClass = classe.idClasse;

        if (hasProspectChanges) {
          prospect.syncState = SyncState.toUpdate;
          print('🔄 Prospect modifié, syncState = toUpdate');
        }
      }

      prospect.classe.value = classe;
      prospect.idClass = classe.idClasse;
      prospect.fiche.value = f;
      prospect.idfiche = f.idFiche;

      String saveResult;

      if (_isEditing) {
        saveResult = await LocalStorage.instance.updateProspect(prospect);
      } else {
        saveResult = await LocalStorage.instance.saveProspect(prospect);
      }

      print('🔍 Prospect ID: ${prospect.idProspect}');
      print('🔍 Prospect Name: ${prospect.nomComplet}');
      print('🔍 SyncState: ${prospect.syncState}');
      print('🔍 SyncState name: ${prospect.syncState.name}');

      if (!saveResult.contains('success')) {
        if (mounted) LoadingService().hide();
        _showSnackBar(saveResult.tr, Colors.orange, 5);
        setState(() => _isSaving = false);
        return;
      }

      await LocalStorage.instance.isar.writeTxn(() async {
        await prospect.classe.save();
        await prospect.fiche.save();
      });

      bool hasInteretChanges = false;

      if (_isEditing && existingProspect != null) {
        await prospect.interets.load();

        final existingInteretsMap = {
          for (final interet in prospect.interets) interet.idInteret: interet
        };

        final Set<String> keptInteretIds = {};

        for (var item in _interetsList) {
          final specialiteKey = item['specialiteKey'] ?? item['specialite'];

          Specialite? specialite =
              await LocalStorage.instance.getSpecialiteByNom(specialiteKey);

          if (specialite == null) {
            specialite = Specialite(
              idSpecialite: Generator.generateShortId('spc_'),
              libelleSpecialite: specialiteKey.trim(),
              description: null,
              createdAt: now,
              syncState: SyncState.pending,
            );
            await LocalStorage.instance.saveSpecialite(specialite);
          }

          final String? existingId = item['idInteret'];
          InteretFiliere? interet;

          if (existingId != null &&
              existingInteretsMap.containsKey(existingId)) {
            interet = existingInteretsMap[existingId]!;

            final bool orderChanged =
                interet.ordrePreference != (item['ordrePreference'] ?? 0);
            final bool levelChanged =
                interet.niveauInteret != (item['niveauInteret'] ?? 0);
            final bool commentChanged =
                interet.commentaire != (item['commentaire'] ?? '');
            final bool specChanged =
                interet.idSpecialite != specialite.idSpecialite;

            if (orderChanged || levelChanged || commentChanged || specChanged) {
              hasInteretChanges = true;
              interet.syncState = SyncState.toUpdate;
            }

            interet.ordrePreference = item['ordrePreference'] ?? 0;
            interet.niveauInteret = item['niveauInteret'] ?? 0;
            interet.commentaire = item['commentaire'] ?? '';
            interet.idSpecialite = specialite.idSpecialite;
            interet.updatedAt = now;
          } else {
            hasInteretChanges = true;
            interet = InteretFiliere(
              idInteret: Generator.generateShortId('int_'),
              idProspect: prospect.idProspect,
              idSpecialite: specialite.idSpecialite,
              ordrePreference: item['ordrePreference'] ?? 0,
              niveauInteret: item['niveauInteret'] ?? 0,
              commentaire: item['commentaire'] ?? '',
              createdAt: now,
              syncState: SyncState.pending,
            );
          }

          interet.prospect.value = prospect;
          interet.specialite.value = specialite;

          await LocalStorage.instance.saveInteret(interet);

          if (!prospect.interets.contains(interet)) {
            prospect.interets.add(interet);
          }

          keptInteretIds.add(interet.idInteret);
        }

        for (final interet in prospect.interets) {
          if (!keptInteretIds.contains(interet.idInteret)) {
            hasInteretChanges = true;
            await LocalStorage.instance.isar.writeTxn(() async {
              await LocalStorage.instance.isar.interetFilieres
                  .delete(interet.isarId);
            });
          }
        }

        await prospect.interets.load();

        if (hasInteretChanges && !hasProspectChanges) {
          prospect.syncState = SyncState.toUpdate;
          await LocalStorage.instance.isar.writeTxn(() async {
            await LocalStorage.instance.isar.prospects.put(prospect);
          });
          print('🔄 Intérêts modifiés, syncState = toUpdate');
        }
      } else {
        int savedInterets = 0;

        for (var item in _interetsList) {
          final specialiteKey = item['specialiteKey'] ?? item['specialite'];

          Specialite? specialite =
              await LocalStorage.instance.getSpecialiteByNom(specialiteKey);

          if (specialite == null) {
            specialite = Specialite(
              idSpecialite: Generator.generateShortId('spc_'),
              libelleSpecialite: specialiteKey.trim(),
              description: null,
              createdAt: now,
              syncState: SyncState.pending,
            );
            await LocalStorage.instance.saveSpecialite(specialite);
          }

          final interet = InteretFiliere(
            idInteret: Generator.generateShortId('int_'),
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
          prospect.interets.add(interet);
          savedInterets++;
        }

        if (prospect.interets.isNotEmpty) {
          await LocalStorage.instance.isar.writeTxn(() async {
            await prospect.interets.save();
          });
        }
      }

      // ── NOTIFICATION DE RELANCE AVEC GESTION DE LA DATE ──
      if (_date_relance != null) {
        final nowDateTime = DateTime.now();
        final minFuture = nowDateTime.add(const Duration(minutes: 1));

        if (_date_relance!.isAfter(minFuture)) {
          try {
            await NotificationService.instance.scheduleReminder(
              prospectId: prospect.idProspect,
              prospectName: prospect.nomComplet,
              date: _date_relance!,
              comment: _commentaireCtrl.text.trim().isNotEmpty
                  ? _commentaireCtrl.text.trim()
                  : 'Relance programmée',
            );

            _showSnackBar(
              '💬 Notification programmée pour le ${_formatDate(_date_relance!)}',
              const Color(0xFF2E7D32),
              3,
            );
          } catch (e) {
            print('❌ Erreur notification: $e');
            _showSnackBar(
              '⚠️ La notification n\'a pas pu être programmée',
              Colors.orange,
              3,
            );
          }
        } else if (_date_relance!.isAfter(nowDateTime)) {
          final adjustedDate = _date_relance!.add(const Duration(minutes: 1));
          try {
            await NotificationService.instance.scheduleReminder(
              prospectId: prospect.idProspect,
              prospectName: prospect.nomComplet,
              date: adjustedDate,
              comment: _commentaireCtrl.text.trim().isNotEmpty
                  ? _commentaireCtrl.text.trim()
                  : 'Relance programmée (décalée)',
            );

            _showSnackBar(
              '💬 Notification programmée pour le ${_formatDate(adjustedDate)} (décalée)',
              const Color(0xFF2E7D32),
              3,
            );
          } catch (e) {
            print('❌ Erreur notification: $e');
            _showSnackBar(
              '⚠️ La notification n\'a pas pu être programmée',
              Colors.orange,
              3,
            );
          }
        } else {
          _showSnackBar(
            '⚠️ La date de relance est déjà passée',
            Colors.orange,
            3,
          );
        }
      }

      if (mounted) {
        LoadingService().hide();
        _showSnackBar(
          _isEditing
              ? 'prospect_updated'
                  .tr
                  .replaceFirst('{count}', '${_interetsList.length}')
              : 'prospect_saved'
                  .tr
                  .replaceFirst('{count}', '${_interetsList.length}'),
          const Color(0xFF2E7D32),
          3,
        );
      }

      _resetForm();
    } catch (e, stackTrace) {
      if (mounted) {
        LoadingService().hide();
        _showSnackBar('Erreur: $e', Colors.red, 5);
      }
      print('❌ Erreur dans _saveProspect: $e');
      print('📚 Stack trace: $stackTrace');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  // ✅ Helper pour formater la date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} à ${date.hour}h${date.minute.toString().padLeft(2, '0')}';
  }

  // ─── Reset ────────────────────────────────────────────────────────────────

  void _resetForm() {
    _nomCompletCtrl.clear();
    _telephoneCtrl.clear();
    _emailCtrl.clear();
    _adresseCtrl.clear();
    _commentaireCtrl.clear();
    _concerneCtrl.clear();
    setState(() {
      _currentStep = 0;
      _selectedSexe = '';
      _selectedTypeProspect = '';
      _selectedEtablissement = null;
      _selectedClasse = null;
      _selectedSource = '';
      _selectedNiveauEtude = '';
      _scoreInteret = 5;
      _interetsList.clear();
      _filteredEtablissementNames = _getFilteredEtablissementNames();
    });
    // _navigateBack();
  }

  // ─── Navigation ──────────────────────────────────────────────────────────

  void _navigateBack() => Navigator.pop(context);

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message),
        ]),
      ),
    );
  }
}
