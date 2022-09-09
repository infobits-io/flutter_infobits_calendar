import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../extensions/date_time.dart';

import '../calendar_event.dart';
import '../calendar_event_box.dart';
import '../calendar_nav.dart';
import '../calendar_nav_day.dart';
import 'calendar_view.dart';

class CalendarDayView<T extends CalendarEvent> extends CalendarView<T> {
  const CalendarDayView({
    super.key,
    required super.eventProvider,
    required super.onDateIntervalChange,
    required super.initialStartShowingDate,
    required super.initialEndShowingDate,
  });

  @override
  CalendarViewState<T, CalendarDayView<T>> createState() =>
      _CalendarDayViewState<T>(
        startShowingDate: initialStartShowingDate,
        endShowingDate: initialEndShowingDate,
      );
}

class _CalendarDayViewState<T extends CalendarEvent>
    extends CalendarViewState<T, CalendarDayView<T>> {
  int lastIndex = 10000;
  double scrollOffset = (8 * 60) - 20;
  CarouselController carouselController = CarouselController();

  _CalendarDayViewState(
      {required super.startShowingDate, required super.endShowingDate});

  @override
  void initState() {
    var middleDate = startShowingDate;
    if (!startShowingDate.isSameDate(endShowingDate)) {
      middleDate = startShowingDate.add(Duration(
          days: (endShowingDate.difference(startShowingDate).inDays / 2)
              .floor()));
    }
    startShowingDate =
        DateTime(middleDate.year, middleDate.month, middleDate.day);
    endShowingDate = DateTime(
        middleDate.year, middleDate.month, startShowingDate.day, 23, 59);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateIntervalChange(startShowingDate, endShowingDate,
          updateView: false);
    });
    super.initState();
  }

  @override
  void updateCurrentShowingDates(DateTime startDate, DateTime endDate) {
    var newStartDate = DateTime(startDate.year, startDate.month, startDate.day);
    var newEndDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59);
    super.updateCurrentShowingDates(newStartDate, newEndDate);
  }

  @override
  void selectShowingPeriod(int index) {
    var newStartDate = startShowingDate.add(Duration(days: index));
    var newEndDate = endShowingDate.add(Duration(days: index));
    super.updateCurrentShowingDates(newStartDate, newEndDate);
  }

  @override
  void nextShowingPeriod() {
    carouselController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  void prevShowingPeriod() {
    carouselController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      final double height = constraints.maxHeight;
      //DateTime currentDate = widget.initialStartShowingDate;

      return Column(
        children: [
          CalendarNav(
            offsetTimestamp: true,
            startShowingDate: startShowingDate,
            endShowingDate: endShowingDate,
            days: [
              for (var i = 1; i < 8; i++)
                CalendarNavDay(
                  date: startShowingDate
                      .subtract(Duration(days: startShowingDate.weekday - i)),
                  isSelectedDay: startShowingDate
                      .subtract(Duration(days: startShowingDate.weekday - i))
                      .isSameDate(startShowingDate),
                ),
            ],
          ),
          CarouselSlider.builder(
            itemCount: 20000,
            carouselController: carouselController,
            options: CarouselOptions(
                height: height - 70,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                initialPage: 10000,
                autoPlay: false,
                onPageChanged: (index, reason) {
                  selectShowingPeriod(index - lastIndex);
                  // calendarState.setCurrentCalendarDate(currentDate);
                  lastIndex = index;
                }),
            itemBuilder: (BuildContext ctx, index, _) {
              DateTime itemDate = startShowingDate;
              if (lastIndex > index) {
                itemDate = itemDate.subtract(Duration(days: lastIndex - index));
              } else if (lastIndex < index) {
                itemDate = itemDate.add(Duration(days: index - lastIndex));
              }

              var itemStartDate =
                  DateTime(itemDate.year, itemDate.month, itemDate.day);
              var itemEndDate =
                  DateTime(itemDate.year, itemDate.month, itemDate.day, 23, 59);

              return FutureBuilder<List<CalendarEvent>>(
                  future: widget.eventProvider
                      .fetchEvents(itemStartDate, itemEndDate),
                  initialData: const [],
                  builder: (context, snapshot) {
                    return NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          // calendarState
                          //     .setScrollOffset(scrollNotification.metrics.pixels);
                          scrollOffset = scrollNotification.metrics.pixels;
                          return false;
                        },
                        child: SingleChildScrollView(
                            controller: ScrollController(
                              initialScrollOffset: scrollOffset,
                            ),
                            child: Stack(children: [
                              Column(
                                children: [
                                  for (var i = 1; i < 25; i++)
                                    CalendarTimestamp(
                                      hour: i,
                                    )
                                ],
                              ),
                              for (var event in snapshot.data ?? [])
                                CalendarEventBox<T>(event: event)
                            ])));
                  });
            },
          ),
        ],
      );
    });
  }
}
