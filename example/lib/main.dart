import 'dart:math';

import 'package:flutter/material.dart';
import 'package:infobits_calendar/infobits_calendar.dart';

void main() {
  runApp(const App());
}

class EventModel extends CalendarEvent {
  final String id;

  const EventModel({
    required super.title,
    required super.subtitle,
    required super.startDate,
    required super.endDate,
    required this.id,
  });
}

/// Fake event test provider
class TestEventProvider extends CalendarEventProvider<EventModel> {
  TestEventProvider() {}

  @override
  Future<List<EventModel>> fetchEvents(
      BuildContext context, DateTime start, DateTime end) async {
    return [
      EventModel(
        id: "123",
        title: "Test event",
        subtitle: "Subtitle",
        startDate: DateTime(start.year, start.month, start.day, 10),
        endDate: DateTime(start.year, start.month, start.day, 12),
      ),
      EventModel(
        id: "123",
        title: "Test event 2",
        subtitle: "Subtitle 2",
        startDate: DateTime(start.year, start.month, start.day, 13),
        endDate: DateTime(start.year, start.month, start.day, 15),
      ),
    ];
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xffffffff),
        body: Calendar<EventModel>(
          eventProvider: TestEventProvider(),
          viewProvider: CalendarViewProvider(
            mobileViewType: CalendarViewType.threeday,
            desktopViewType: CalendarViewType.threeday,
          ),
          eventModalOptions: CalendarEventModalOptions(
            infoEntryBuilders: [
              (event, dialog) {
                return CalendarModalInfoEntry(
                  icon: Icon(Icons.calendar_month),
                  child: Text(
                      "Info widget for ${event.title} with id: ${event.id}"),
                );
              }
            ],
            bottomActionBuilders: [
              (event, dialog) {
                return ElevatedButton(
                  onPressed: () => debugPrint("test"),
                  child: Text("Button"),
                );
              }
            ],
            extraContentBuilder: (event, dialog) => Text("Test extra content"),
          ),
          style: CalendarStyle(primaryColor: Colors.red),
          text: CalendarText(
            createText: "Hmmm",
          ),
          extraContent: Text("Extra content"),
          extraActions: [
            CalendarQuickAction(
              icon: Icon(Icons.settings),
              title: "Settings",
              onPressed: () => debugPrint("settings!"),
            )
          ],
        ),
      ),
    );
  }
}
