import 'package:flutter/material.dart';

import 'calendar_event.dart';

class CalendarStyle<T extends CalendarEvent> {
  final Color primaryColor;
  final Color primaryBackgroundColor;
  final Color primaryTextColor;
  final Color primaryColorContrast;

  final Color secondaryColor;
  final Color secondaryBackgroundColor;
  final Color secondaryTextColor;

  final Color barrierColor;

  final CalendarIconsStyle icons;

  final CalendarEventStyle Function(T event, CalendarStyle<T> style)?
      eventStyleProvider;

  const CalendarStyle({
    this.primaryColor = const Color(0xff2196F3),
    this.primaryBackgroundColor = const Color(0xffffffff),
    this.primaryTextColor = const Color(0xff000000),
    this.primaryColorContrast = const Color(0xffffffff),
    this.secondaryColor = const Color(0xffe2f2ff),
    this.secondaryBackgroundColor = const Color(0xffeeeeee),
    this.secondaryTextColor = const Color(0xffcccccc),
    this.barrierColor = Colors.black54,
    this.eventStyleProvider,
    this.icons = const CalendarIconsStyle(),
  });

  CalendarEventStyle getEventStyle(T event) {
    if (eventStyleProvider != null) {
      return eventStyleProvider!(event, this);
    }
    return CalendarEventStyle(
      color: primaryColorContrast,
      backgroundColor: primaryColor,
    );
  }

  static CalendarStyle of<T extends CalendarEvent>(BuildContext context) {
    final inheritedOptions =
        context.dependOnInheritedWidgetOfExactType<InheritedCalendarStyle<T>>();
    return inheritedOptions?.style ?? const CalendarStyle();
  }
}

class CalendarEventStyle {
  final Color color;
  final Color backgroundColor;

  const CalendarEventStyle({
    required this.color,
    required this.backgroundColor,
  });
}

class CalendarIconsStyle {
  final Widget createIcon;
  final Widget leftIcon;
  final Widget rightIcon;
  final Widget upIcon;

  const CalendarIconsStyle({
    this.createIcon = const Icon(Icons.add),
    this.leftIcon = const Icon(Icons.chevron_left),
    this.rightIcon = const Icon(Icons.chevron_right),
    this.upIcon = const Icon(Icons.arrow_drop_up_rounded),
  });
}

class InheritedCalendarStyle<T extends CalendarEvent> extends InheritedWidget {
  final CalendarStyle<T> style;

  const InheritedCalendarStyle({
    super.key,
    required this.style,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedCalendarStyle<T> oldWidget) {
    return oldWidget.style != style;
  }
}
