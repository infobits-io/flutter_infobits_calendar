import 'package:flutter/material.dart';

import '../calendar_event.dart';
import 'calendar_view.dart';

class CalendarMonthView<T extends CalendarEvent> extends CalendarView<T> {
  const CalendarMonthView({
    super.key,
    required super.eventProvider,
    required super.onDateIntervalChange,
    required super.initialStartShowingDate,
    required super.initialEndShowingDate,
  });

  @override
  CalendarViewState<T, CalendarMonthView<T>> createState() =>
      _CalendarMonthViewState<T>(
        startShowingDate: initialStartShowingDate,
        endShowingDate: initialEndShowingDate,
      );
}

class _CalendarMonthViewState<T extends CalendarEvent>
    extends CalendarViewState<T, CalendarMonthView<T>> {
  _CalendarMonthViewState(
      {required super.startShowingDate, required super.endShowingDate});

  @override
  void selectShowingPeriod(int index) {}

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
