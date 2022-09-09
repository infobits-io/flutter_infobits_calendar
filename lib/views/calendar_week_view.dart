import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../calendar_event.dart';
import '../calendar_event_box.dart';
import '../calendar_style.dart';
import 'calendar_view.dart';
import '../calendar_nav.dart';

class CalendarWeekView<T extends CalendarEvent> extends CalendarView<T> {
  const CalendarWeekView({
    super.key,
    required super.eventProvider,
    required super.onDateIntervalChange,
    required super.initialStartShowingDate,
    required super.initialEndShowingDate,
  });

  @override
  CalendarViewState<T, CalendarView<T>> createState() =>
      _CalendarWeekViewState<T>(
        startShowingDate: initialStartShowingDate,
        endShowingDate: initialEndShowingDate,
      );
}

class _CalendarWeekViewState<T extends CalendarEvent>
    extends CalendarViewState<T, CalendarWeekView<T>> {
  int lastIndex = 10000;
  double scrollOffset = (8 * 60) - 20;
  CarouselController carouselController = CarouselController();

  _CalendarWeekViewState(
      {required super.startShowingDate, required super.endShowingDate});

  @override
  void selectShowingPeriod(int index) {
    var newStartDate = startShowingDate.add(Duration(days: 7 * index));
    var newEndDate = endShowingDate.add(Duration(days: 7 * index));
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
  void initState() {
    super.initState();
    var newStartDate =
        startShowingDate.subtract(Duration(days: startShowingDate.weekday - 1));
    var newEndDate =
        endShowingDate.subtract(Duration(days: endShowingDate.weekday - 7));
    startShowingDate =
        DateTime(newStartDate.year, newStartDate.month, newStartDate.day);
    endShowingDate =
        DateTime(newEndDate.year, newEndDate.month, newEndDate.day, 23, 59);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateIntervalChange(startShowingDate, endShowingDate,
          updateView: false);
    });
  }

  @override
  void updateCurrentShowingDates(DateTime startDate, DateTime endDate) {
    var newStartDate =
        startDate.subtract(Duration(days: startDate.weekday - 1));
    var newEndDate = endDate.subtract(Duration(days: endDate.weekday - 7));
    super.updateCurrentShowingDates(newStartDate, newEndDate);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext ctx, BoxConstraints constraints) {
      final double height = constraints.maxHeight;

      return CarouselSlider.builder(
        itemCount: 20000,
        carouselController: carouselController,
        options: CarouselOptions(
            height: height,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            initialPage: 10000,
            autoPlay: false,
            onPageChanged: (index, reason) {
              selectShowingPeriod(index - lastIndex);
              lastIndex = index;
            }),
        itemBuilder: (BuildContext ctx, index, _) {
          var itemDate = startShowingDate;
          if (lastIndex > index) {
            itemDate =
                itemDate.subtract(Duration(days: 7 * (lastIndex - index)));
          } else if (lastIndex < index) {
            itemDate = itemDate.add(Duration(days: 7 * (index - lastIndex)));
          }

          var itemStartDate =
              itemDate.subtract(Duration(days: itemDate.weekday - 1));
          var itemEndDate =
              itemStartDate.subtract(Duration(days: itemDate.weekday - 7));

          final double width = constraints.maxWidth - 50;
          final double eventWidth = width / 7;

          return Column(
            children: [
              CalendarNav<T>(
                offsetTimestamp: true,
                startShowingDate: itemStartDate,
                endShowingDate: itemEndDate,
              ),
              SizedBox(
                height: height - 70,
                child: FutureBuilder<List<CalendarEvent>>(
                    future: widget.eventProvider
                        .fetchEvents(context, itemStartDate, itemEndDate),
                    initialData: const [],
                    builder: (context, snapshot) {
                      return NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          scrollOffset = scrollNotification.metrics.pixels;
                          return false;
                        },
                        child: SingleChildScrollView(
                          controller: ScrollController(
                              initialScrollOffset: scrollOffset),
                          child: Stack(children: [
                            Column(
                              children: <Widget>[
                                for (var i = 1; i < 25; i++)
                                  CalendarTimestamp<T>(
                                    hour: i,
                                  )
                              ],
                            ),
                            for (var i = 1; i < 7; i++)
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: (eventWidth * i) + 45,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: CalendarStyle.of<T>(context)
                                            .secondaryBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            for (var event in snapshot.data ?? [])
                              CalendarEventBox<T>(
                                event: event,
                                left:
                                    (event.startDate!.weekday - 1) * eventWidth,
                                right:
                                    (7 - event.startDate!.weekday) * eventWidth,
                              )
                          ]),
                        ),
                      );
                    }),
              ),
            ],
          );
        },
      );
    });
  }
}
