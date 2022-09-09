import 'package:flutter/material.dart';

import 'calendar_event.dart';

class CalendarEventModalOptions<T extends CalendarEvent> {
  final IconData bottomActionsIcon;
  final List<CalendarModalInfoEntry Function(T event)> infoEntryBuilders;
  final List<Widget> bottomActions;
  final Widget? extraContent;

  const CalendarEventModalOptions({
    this.bottomActionsIcon = Icons.link,
    this.infoEntryBuilders = const [],
    this.bottomActions = const [],
    this.extraContent,
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
