class CalendarEvent {
  final String title;
  final String? subtitle;
  final DateTime startDate;
  final DateTime? endDate; // TODO: end date should be able to be null

  const CalendarEvent({
    required this.title,
    this.subtitle,
    required this.startDate,
    required this.endDate,
  });
}
