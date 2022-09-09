import 'package:flutter/material.dart';

import '../calendar_event.dart';
import 'calendar_view.dart';

class CalendarListView<T extends CalendarEvent> extends CalendarView<T> {
  const CalendarListView({
    super.key,
    required super.eventProvider,
    required super.onDateIntervalChange,
    required super.initialStartShowingDate,
    required super.initialEndShowingDate,
  });

  @override
  CalendarViewState<T, CalendarListView<T>> createState() =>
      _CalendarListViewState<T>(
        startShowingDate: initialStartShowingDate,
        endShowingDate: initialEndShowingDate,
      );
}

class _CalendarListViewState<T extends CalendarEvent>
    extends CalendarViewState<T, CalendarListView<T>> {
  _CalendarListViewState(
      {required super.startShowingDate, required super.endShowingDate});

  @override
  void selectShowingPeriod(int index) {}

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
