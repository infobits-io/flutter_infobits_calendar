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
        title: "Long event",
        subtitle: "Subtitle",
        startDate: DateTime(start.year, start.month, start.day + 1, 10),
        endDate: DateTime(start.year, start.month, start.day + 2, 12),
      ),
      EventModel(
        id: "123",
        title: "Test event 2",
        subtitle: "Subtitle 2",
        startDate: DateTime(start.year, start.month, start.day, 16, 9, 7),
        endDate: null,
      ),
      EventModel(
        id: "123",
        title: "Test event 2",
        subtitle: "Subtitle 2",
        startDate: DateTime(end.year, end.month, end.day, 13, 9, 7),
        endDate: null,
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
          onCreatePressed: () => debugPrint("Create pressed"),
          viewProvider: CalendarViewProvider(
            mobileViewType: CalendarViewType.threeday,
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
            onEditPressed: (event) async {
              debugPrint("Edit pressed");
              return false;
            },
            onDeletePressed: (event) async {
              debugPrint("Delete pressed");
              return false;
            },
          ),
          style: CalendarStyle(primaryColor: Colors.red),
          text: CalendarText(
            createText: "Hmmm",
          ),
          extraContent: Column(
            children: [
              Container(
                height: 200,
                color: Colors.amber,
                margin: const EdgeInsets.all(10),
              ),
              Container(
                height: 200,
                color: Colors.amber,
                margin: const EdgeInsets.all(10),
              ),
              Container(
                height: 200,
                color: Colors.amber,
                margin: const EdgeInsets.all(10),
              ),
              Container(
                height: 200,
                color: Colors.amber,
                margin: const EdgeInsets.all(10),
              ),
            ],
          ),
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
