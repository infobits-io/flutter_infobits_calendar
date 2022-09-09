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
  Future<List<EventModel>> fetchEvents(DateTime start, DateTime end) async {
    // Map<int, int> lastDayHour = {};

    // List<EventModel> events = [];
    // //debugPrint("fetchEvents called $start");
    // var rng = Random();
    // for (var i = 0; i < 20; i++) {
    //   var id = rng.nextInt(100).toString();

    //   var day = start.day +
    //       (rng.nextInt(4) % end.difference(start).inDays == 0
    //           ? 1
    //           : end.difference(start).inDays);

    //   var startHour = (lastDayHour.containsKey(day) ? lastDayHour[day] : 8)! +
    //       rng.nextInt(4);
    //   if (startHour > 22) continue;
    //   var endHour = min<int>(startHour + rng.nextInt(4), 23);
    //   lastDayHour[day] = endHour;

    //   events.add(
    //     EventModel(
    //       id: id,
    //       title: "Test event",
    //       subtitle: "Subtitle",
    //       startDate: DateTime(start.year, start.month, day, startHour),
    //       endDate: DateTime(start.year, start.month, day, endHour),
    //     ),
    //   );
    // }
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
              (event) {
                return CalendarModalInfoEntry(
                  icon: Icon(Icons.calendar_month),
                  child: Text(
                      "Info widget for ${event.title} with id: ${event.id}"),
                );
              }
            ],
            bottomActions: [
              ElevatedButton(
                  onPressed: () => debugPrint("test"), child: Text("Button"))
            ],
            extraContent: Text("Test extra content"),
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
