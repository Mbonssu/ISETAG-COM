import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isetagcom/models/localStorage/local_storage.dart';
import 'package:isetagcom/models/prospectData.dart';
import '../services/notification_service.dart';
import '../services/translation_service.dart';
import '../utils/status.dart';
import '../utils/themes/app_colors.dart';
import 'prospect_detail_screen.dart';

class RelancesScreen extends StatefulWidget {
  const RelancesScreen({super.key});

  @override
  State<RelancesScreen> createState() => _RelancesScreenState();
}

class _RelancesScreenState extends State<RelancesScreen> {
  List<ProspectDetails> _relancesProspects = [];
  List<ProspectDetails> _filteredProspects = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _filterType = 'all';

  final Map<String, String> _filterOptions = {
    'all': 'all'.tr,
    'today': 'today'.tr,
    'week': 'this_week'.tr,
    'month': 'this_month'.tr,
    'overdue': 'overdue'.tr,
  };

  final List<Map<String, dynamic>> _appNotifications = [];

  @override
  void initState() {
    super.initState();
    _loadRelances();
    _initNotificationService();
  }

  Future<void> _initNotificationService() async {
    await NotificationService().init();
  }

  Future<void> _loadRelances() async {
    setState(() => _isLoading = true);

    final allProspectsRaw = await LocalStorage.instance.getAllProspects();

    final now = DateTime.now();
    final allProspects = <ProspectDetails>[];
    for (final prospect in allProspectsRaw) {
      allProspects
          .add(await LocalStorage.instance.buildProspectDetails(prospect));
    }
    _relancesProspects = allProspects.where((p) {
      return p.prosp.date_relance != null &&
          p.prosp.prospectStatus == ProspectStatus.relancer &&
          p.prosp.date_relance!.isBefore(now.add(const Duration(days: 7)));
    }).toList();

    _applyFilters();
    setState(() => _isLoading = false);

    _checkOverdueNotifications();
  }

  void _applyFilters() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    _filteredProspects = _relancesProspects.where((p) {
      final dateRelance = p.prosp.date_relance!;

      switch (_filterType) {
        case 'today':
          return dateRelance.year == now.year &&
              dateRelance.month == now.month &&
              dateRelance.day == now.day;
        case 'week':
          return dateRelance.isAfter(startOfWeek) &&
              dateRelance.isBefore(endOfWeek);
        case 'month':
          return dateRelance.year == now.year && dateRelance.month == now.month;
        case 'overdue':
          return dateRelance.isBefore(now);
        default:
          return true;
      }
    }).toList();

    if (_searchQuery.isNotEmpty) {
      _filteredProspects = _filteredProspects.where((p) {
        return p.prosp.nomComplet
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            p.etablissement.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    _filteredProspects
        .sort((a, b) => a.prosp.date_relance!.compareTo(b.prosp.date_relance!));
  }

  // Future<void> _checkOverdueNotifications() async {
  //   final now = DateTime.now();
  //   final overdueProspects = _relancesProspects.where((p) {
  //     return p.prosp.date_relance!.isBefore(now) &&
  //         !_appNotifications.any((n) => n['prospectId'] == p.prosp.idProspect);
  //   }).toList();

  //   for (final prospect in overdueProspects) {
  //     setState(() {
  //       _appNotifications.insert(0, {
  //         'id': DateTime.now().millisecondsSinceEpoch,
  //         'prospectId': prospect.prosp.idProspect,
  //         'title': 'reminder_overdue'.tr,
  //         'body': 'reminder_overdue_body'.tr.replaceFirst('{name}', prospect.prosp.nomComplet),
  //         'date': now,
  //         'read': false,
  //       });
  //     });

  //     await NotificationService().showNotification(
  //       id: DateTime.now().millisecondsSinceEpoch,
  //       title: 'reminder_overdue'.tr,
  //       body: 'reminder_overdue_body'.tr.replaceFirst('{name}', prospect.prosp.nomComplet),
  //     );
  //   }
  // }

  // Future<void> _scheduleReminder(
  //     ProspectDetails prospect, DateTime dateTime) async {
  //   await NotificationService().showNotification(
  //     id: DateTime.now().millisecondsSinceEpoch,
  //     title: 'reminder_scheduled_title'.tr,
  //     body: 'reminder_scheduled_body'.tr.replaceFirst('{name}', prospect.prosp.nomComplet),
  //     scheduledTime: dateTime,
  //   );

  //   if (!mounted) return;
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('reminder_scheduled_message'.tr.replaceFirst('{date}', DateFormat('dd/MM/yyyy HH:mm').format(dateTime))),
  //       backgroundColor: AppColors.primaryGreen,
  //     ),
  //   );
  // }
  // Partie modifiée dans _checkOverdueNotifications()
  Future<void> _checkOverdueNotifications() async {
    final now = DateTime.now();
    final overdueProspects = _relancesProspects.where((p) {
      return p.prosp.date_relance != null &&
          p.prosp.date_relance!.isBefore(now) &&
          !_appNotifications.any((n) => n['prospectId'] == p.prosp.idProspect);
    }).toList();

    for (final prospect in overdueProspects) {
      setState(() {
        _appNotifications.insert(0, {
          'id': DateTime.now().millisecondsSinceEpoch,
          'prospectId': prospect.prosp.idProspect,
          'title': 'reminder_overdue'.tr,
          'body': 'reminder_overdue_body'
              .tr
              .replaceFirst('{name}', prospect.prosp.nomComplet),
          'date': now,
          'read': false,
        });
      });

      // Utiliser la nouvelle méthode avec ID généré automatiquement
      await NotificationService().showOverdueNotification(
        prospectName: prospect.prosp.nomComplet,
        prospectId: prospect.prosp.idProspect,
      );
    }
  }

// Partie modifiée dans _scheduleReminder()
  Future<void> _scheduleReminder(
      ProspectDetails prospect, DateTime dateTime) async {
    await NotificationService().showReminderNotification(
      prospectName: prospect.prosp.nomComplet,
      prospectId: prospect.prosp.idProspect,
      scheduledTime: dateTime,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('reminder_scheduled_message'.tr.replaceFirst(
            '{date}', DateFormat('dd/MM/yyyy HH:mm').format(dateTime))),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  Future<void> _markAsDone(ProspectDetails prospect) async {
    setState(() {
      _relancesProspects
          .removeWhere((p) => p.prosp.idProspect == prospect.prosp.idProspect);
      _applyFilters();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('marked_as_done'.tr),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _postponeRelance(ProspectDetails prospect, int days) async {
    final newDate = DateTime.now().add(Duration(days: days));

    prospect.prosp.date_relance = newDate;
    await LocalStorage.instance.saveProspect(prospect.prosp);

    setState(() => _applyFilters());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'postponed_message'.tr.replaceFirst('{days}', days.toString())),
        backgroundColor: Colors.orange,
      ),
    );
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
          _buildNotificationBell(),
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProspects.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _filteredProspects.length,
                        itemBuilder: (context, index) => _buildRelanceCard(
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
              child:
                  const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'to_relaunch'.tr,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_filteredProspects.length}',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationBell() {
    final unreadCount = _appNotifications.where((n) => !n['read']).length;

    return Container(
      margin: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () => _showNotificationsDialog(),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppColors.lightShadow,
          ),
          child: Row(
            children: [
              const Icon(Icons.notifications_outlined,
                  color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'notifications'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (unreadCount > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationsDialog() {
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
              Text(
                'notifications'.tr,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (_appNotifications.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text('no_notifications'.tr),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _appNotifications.length,
                    itemBuilder: (context, index) {
                      final notif = _appNotifications[index];
                      return ListTile(
                        dense: true,
                        leading: Icon(
                          notif['read']
                              ? Icons.notifications_none
                              : Icons.notifications_active,
                          color: notif['read'] ? Colors.grey : Colors.orange,
                          size: 20,
                        ),
                        title: Text(
                          notif['title'],
                          style: const TextStyle(fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          notif['body'],
                          style: const TextStyle(fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          DateFormat('dd/MM/yy').format(notif['date']),
                          style: const TextStyle(fontSize: 10),
                        ),
                        onTap: () {
                          setState(() {
                            notif['read'] = true;
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

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _applyFilters();
          });
        },
        decoration: InputDecoration(
          hintText: 'search_hint'.tr,
          hintStyle: const TextStyle(fontSize: 13),
          prefixIcon:
              const Icon(Icons.search, color: AppColors.textTertiary, size: 20),
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _filterOptions.entries.map((entry) {
          final isSelected = _filterType == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                entry.value,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _filterType = entry.key;
                  _applyFilters();
                });
              },
              selectedColor: AppColors.primaryGreen,
              backgroundColor: Colors.grey.shade100,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRelanceCard(ProspectDetails prospect, bool isSmallScreen) {
    final dateRelance = prospect.prosp.date_relance!;
    final isOverdue = dateRelance.isBefore(DateTime.now());
    final dateFormatted = DateFormat('dd/MM/yyyy').format(dateRelance);
    final timeFormatted = DateFormat('HH:mm').format(dateRelance);

    final double avatarSize = isSmallScreen ? 40 : 50;
    final double fontSize = isSmallScreen ? 14 : 16;
    final double cardPadding = isSmallScreen ? 12 : 16;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.lightShadow,
        border: isOverdue ? Border.all(color: Colors.red, width: 1) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProspectDetailScreen(prospect: prospect)),
          ),
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.access_time,
                        color: isOverdue ? Colors.red : AppColors.primaryGreen,
                        size: avatarSize * 0.55,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prospect.prosp.nomComplet,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            prospect.etablissement,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 12,
                            runSpacing: 4,
                            children: [
                              _buildInfoChip(
                                icon: Icons.calendar_today,
                                text: dateFormatted,
                              ),
                              _buildInfoChip(
                                icon: Icons.access_time,
                                text: timeFormatted,
                              ),
                              if (isOverdue)
                                _buildInfoChip(
                                  text: 'overdue'.tr,
                                  color: Colors.red,
                                  backgroundColor: Colors.red.withOpacity(0.1),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _markAsDone(prospect),
                        icon: const Icon(Icons.check, size: 16),
                        label: Text('done'.tr),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showPostponeDialog(prospect),
                        icon: const Icon(Icons.schedule, size: 16),
                        label: Text('postpone'.tr),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: const BorderSide(color: Colors.orange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showScheduleDialog(prospect),
                        icon: const Icon(Icons.notifications_active, size: 16),
                        label: Text('reminder'.tr),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    IconData? icon,
    required String text,
    Color color = AppColors.textTertiary,
    Color backgroundColor = Colors.transparent,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(fontSize: 11, color: color),
          ),
        ],
      ),
    );
  }

  void _showPostponeDialog(ProspectDetails prospect) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('postpone_followup'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              dense: true,
              title: Text('postpone_1_day'.tr),
              onTap: () {
                Navigator.pop(context);
                _postponeRelance(prospect, 1);
              },
            ),
            ListTile(
              dense: true,
              title: Text('postpone_3_days'.tr),
              onTap: () {
                Navigator.pop(context);
                _postponeRelance(prospect, 3);
              },
            ),
            ListTile(
              dense: true,
              title: Text('postpone_1_week'.tr),
              onTap: () {
                Navigator.pop(context);
                _postponeRelance(prospect, 7);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showScheduleDialog(ProspectDetails prospect) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('schedule_reminder'.tr),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.calendar_today, size: 20),
                  title: Text(
                    'date_label'.tr.replaceFirst('{date}',
                        DateFormat('dd/MM/yyyy').format(selectedDate)),
                    style: const TextStyle(fontSize: 13),
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() => selectedDate = date);
                    }
                  },
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.access_time, size: 20),
                  title: Text(
                    'time_label'
                        .tr
                        .replaceFirst('{time}', selectedTime.format(context)),
                    style: const TextStyle(fontSize: 13),
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (time != null) {
                      setState(() => selectedTime = time);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('cancel'.tr),
              ),
              ElevatedButton(
                onPressed: () {
                  final scheduledDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                  _scheduleReminder(prospect, scheduledDateTime);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                ),
                child: Text('schedule'.tr),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 70, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'no_followups'.tr,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'up_to_date'.tr,
            style: const TextStyle(fontSize: 14, color: AppColors.textTertiary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
