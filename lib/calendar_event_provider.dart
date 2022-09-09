import 'calendar_event.dart';

/// A data provider interface for the events
abstract class CalendarEventProvider<T extends CalendarEvent> {
  /// Fetch the events for the given date interval
  Future<List<T>> fetchEvents(DateTime start, DateTime end);
}

class EmptyCalendarEventProvider extends CalendarEventProvider<CalendarEvent> {
  @override
  Future<List<CalendarEvent>> fetchEvents(DateTime start, DateTime end) async {
    return [];
  }
}
