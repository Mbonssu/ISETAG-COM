// ✅ Outing Model
class Outing {
  final String id;
  final String location;
  final String time;
  final String date;
  final String purpose;
  final String status;
  final String assignedBy;
  final String notes;

  Outing({
    required this.id,
    required this.location,
    required this.time,
    required this.date,
    required this.purpose,
    required this.status,
    required this.assignedBy,
    this.notes = '',
  });
}