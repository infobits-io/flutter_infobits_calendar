import 'package:flutter/material.dart';

import 'calendar_event.dart';

/// A data provider interface for the events
abstract class CalendarEventProvider<T extends CalendarEvent> {
  Future<void> init(BuildContext context) async {
    return;
  }

  /// Fetch the events for the given date interval
  Future<List<T>> fetchEvents(
      BuildContext context, DateTime start, DateTime end);
}

class EmptyCalendarEventProvider extends CalendarEventProvider<CalendarEvent> {
  @override
  Future<List<CalendarEvent>> fetchEvents(
      BuildContext context, DateTime start, DateTime end) async {
    return [];
  }
}
