// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFilter extends StatefulWidget {
  final Function(DateTime? startDate, DateTime? endDate) onFilter;
  final Function() onRefresh;
  
  const DateFilter({
    super.key,
    required this.onFilter,
    required this.onRefresh,
  });

  @override
  State<DateFilter> createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedFilter;
  
  final List<Map<String, dynamic>> _filterOptions = [
    {'label': 'Aujourd\'hui', 'value': 'today'},
    {'label': 'Cette semaine', 'value': 'week'},
    {'label': 'Ce mois', 'value': 'month'},
    {'label': 'Personnalisé', 'value': 'custom'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.filter_alt, color: Color(0xFF2E7D32)),
              const SizedBox(width: 10),
              const Text(
                'Filtrer par date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B5E20),
                ),
              ),
              const Spacer(),
              if (_startDate != null || _endDate != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _startDate = null;
                      _endDate = null;
                      _selectedFilter = null;
                    });
                    widget.onRefresh();
                  },
                  child: const Text('Effacer'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: _filterOptions.map((option) {
              bool isSelected = _selectedFilter == option['value'];
              return FilterChip(
                label: Text(option['label']),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = selected ? option['value'] : null;
                    if (selected) {
                      _applyFilter(option['value']);
                    } else {
                      _startDate = null;
                      _endDate = null;
                      widget.onRefresh();
                    }
                  });
                },
                selectedColor: const Color(0xFF2E7D32).withOpacity(0.2),
                checkmarkColor: const Color(0xFF2E7D32),
                labelStyle: TextStyle(
                  color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade700,
                ),
              );
            }).toList(),
          ),
          if (_selectedFilter == 'custom') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDateButton(
                    label: 'Date de début',
                    date: _startDate,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                        });
                        _applyCustomFilter();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateButton(
                    label: 'Date de fin',
                    date: _endDate,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                        });
                        _applyCustomFilter();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildDateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            date != null ? DateFormat('dd/MM/yyyy').format(date) : 'Sélectionner',
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
  
  void _applyFilter(String filter) {
    final now = DateTime.now();
    switch (filter) {
      case 'today':
        _startDate = DateTime(now.year, now.month, now.day);
        _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'week':
        _startDate = now.subtract(Duration(days: now.weekday - 1));
        _endDate = now;
        break;
      case 'month':
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = now;
        break;
    }
    widget.onFilter(_startDate, _endDate);
  }
  
  void _applyCustomFilter() {
    if (_startDate != null && _endDate != null) {
      widget.onFilter(_startDate, _endDate);
    } else if (_startDate != null) {
      widget.onFilter(_startDate, null);
    } else if (_endDate != null) {
      widget.onFilter(null, _endDate);
    }
  }
}