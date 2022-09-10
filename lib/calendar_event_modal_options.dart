import 'package:flutter/material.dart';

import 'calendar_event.dart';

class CalendarEventModalOptions<T extends CalendarEvent> {
  final List<CalendarModalInfoEntry? Function(T event, bool dialog)>
      infoEntryBuilders;
  final List<Widget? Function(T event, bool dialog)> bottomActionBuilders;
  final Widget? Function(T event, bool dialog)? extraContentBuilder;

  const CalendarEventModalOptions({
    this.infoEntryBuilders = const [],
    this.bottomActionBuilders = const [],
    this.extraContentBuilder,
  });

  static CalendarEventModalOptions<T> of<T extends CalendarEvent>(
      BuildContext context) {
    final inheritedOptions = context.dependOnInheritedWidgetOfExactType<
        InheritedCalendarEventModalOptions<T>>();
    return inheritedOptions?.options ?? CalendarEventModalOptions<T>();
  }
}

class CalendarModalInfoEntry extends StatelessWidget {
  final Widget icon;
  final Widget child;

  const CalendarModalInfoEntry(
      {super.key, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class InheritedCalendarEventModalOptions<T extends CalendarEvent>
    extends InheritedWidget {
  final CalendarEventModalOptions<T> options;

  const InheritedCalendarEventModalOptions({
    super.key,
    required this.options,
    required super.child,
  });

  @override
  bool updateShouldNotify(
      covariant InheritedCalendarEventModalOptions<T> oldWidget) {
    return oldWidget.options != options;
  }
}
