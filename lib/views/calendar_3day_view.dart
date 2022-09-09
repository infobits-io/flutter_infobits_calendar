import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../extensions/date_time.dart';

import '../calendar_event.dart';
import '../calendar_event_box.dart';
import '../calendar_nav.dart';
import '../calendar_nav_day.dart';
import '../calendar_style.dart';
import 'calendar_view.dart';

class Calendar3DayView<T extends CalendarEvent> extends CalendarView<T> {
  const Calendar3DayView({
    super.key,
    required super.eventProvider,
    required super.onDateIntervalChange,
    required super.initialStartShowingDate,
    required super.initialEndShowingDate,
  });

  @override
  CalendarViewState<T, Calendar3DayView<T>> createState() =>
      _Calendar3DayViewState<T>(
        startShowingDate: initialStartShowingDate,
        endShowingDate: initialEndShowingDate,
      );
}

class _Calendar3DayViewState<T extends CalendarEvent>
    extends CalendarViewState<T, Calendar3DayView<T>> {
  int lastIndex = 10000;
  double scrollOffset = (8 * 60) - 20;
  List<ScrollController> controllers = [];
  ScrollController timestampController = ScrollController(
    initialScrollOffset: (8 * 60) - 20,
  );
  CarouselController carouselController = CarouselController();

  _Calendar3DayViewState(
      {required super.startShowingDate, required super.endShowingDate});

  @override
  void updateCurrentShowingDates(DateTime startDate, DateTime endDate) {
    if (startDate.isSameDate(endDate)) {
      var newStartDate =
          DateTime(startDate.year, startDate.month, startDate.day)
              .subtract(const Duration(days: 1));
      var newEndDate = DateTime(
              newStartDate.year, newStartDate.month, newStartDate.day, 23, 59)
          .add(const Duration(days: 2));
      super.updateCurrentShowingDates(newStartDate, newEndDate);
    } else {
      var newStartDate =
          DateTime(startDate.year, startDate.month, startDate.day);
      var newEndDate =
          DateTime(startDate.year, startDate.month, startDate.day, 23, 59)
              .add(const Duration(days: 2));
      super.updateCurrentShowingDates(newStartDate, newEndDate);
    }
  }

  @override
  void selectShowingPeriod(index) {
    var newStartDate = startShowingDate.add(Duration(days: index));
    var newEndDate = newStartDate.add(const Duration(days: 2));
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
    var middleDate = startShowingDate;
    if (!startShowingDate.isSameDate(endShowingDate)) {
      middleDate = startShowingDate.add(Duration(
          days: (endShowingDate.difference(startShowingDate).inDays / 2)
              .floor()));
    }
    startShowingDate =
        DateTime(middleDate.year, middleDate.month, middleDate.day)
            .subtract(const Duration(days: 1));
    endShowingDate = DateTime(
            middleDate.year, middleDate.month, startShowingDate.day, 23, 59)
        .add(const Duration(days: 2));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateIntervalChange(startShowingDate, endShowingDate,
          updateView: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: LayoutBuilder(builder: (ctx, constraints) {
        final double height = constraints.maxHeight;

        return Row(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 70),
              width: 45,
              child: SingleChildScrollView(
                controller: timestampController,
                child: Column(
                  children: [
                    for (var i = 1; i < 25; i++)
                      CalendarTimestamp<T>(
                        hour: i,
                      )
                  ],
                ),
              ),
            ),
            Expanded(
              child: CarouselSlider.builder(
                itemCount: 20000,
                carouselController: carouselController,
                options: CarouselOptions(
                    height: height,
                    viewportFraction: 0.333,
                    enlargeCenterPage: false,
                    initialPage: 10000,
                    autoPlay: false,
                    onPageChanged: (index, reason) {
                      selectShowingPeriod(index - lastIndex);
                      lastIndex = index;
                    }),
                itemBuilder: (BuildContext ctx, index, _) {
                  DateTime itemDate =
                      startShowingDate.add(const Duration(days: 1));
                  if (lastIndex > index) {
                    itemDate =
                        itemDate.subtract(Duration(days: lastIndex - index));
                  } else if (lastIndex < index) {
                    itemDate = itemDate.add(Duration(days: index - lastIndex));
                  }

                  var itemStartDate =
                      DateTime(itemDate.year, itemDate.month, itemDate.day);
                  var itemEndDate = DateTime(
                      itemDate.year, itemDate.month, itemDate.day, 23, 59);

                  var controller = ScrollController(
                    initialScrollOffset: scrollOffset,
                  );
                  controllers.add(controller);

                  return Column(
                    children: [
                      CalendarNav<T>(
                        offsetTimestamp: false,
                        startShowingDate: startShowingDate,
                        endShowingDate: endShowingDate,
                        days: [
                          CalendarNavDay<T>(
                            date: itemStartDate,
                            isSelectedDay: false,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height - 70,
                        child: FutureBuilder<List<CalendarEvent>>(
                            future: widget.eventProvider.fetchEvents(
                                context, itemStartDate, itemEndDate),
                            initialData: const [],
                            builder: (context, snapshot) {
                              return NotificationListener<ScrollNotification>(
                                  onNotification: (scrollNotification) {
                                    // calendarState
                                    //     .setScrollOffset(scrollNotification.metrics.pixels);
                                    scrollOffset =
                                        scrollNotification.metrics.pixels;
                                    timestampController.jumpTo(scrollOffset);
                                    List<ScrollController> controllersToRemove =
                                        [];
                                    for (var _controller in controllers) {
                                      if (_controller != controller &&
                                          _controller.hasClients) {
                                        _controller.jumpTo(scrollOffset);
                                      } else if (!_controller.hasClients) {
                                        controllersToRemove.add(_controller);
                                      }
                                    }
                                    for (var _controller
                                        in controllersToRemove) {
                                      controllers.remove(_controller);
                                    }
                                    return false;
                                  },
                                  child: SingleChildScrollView(
                                      controller: controller,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                          color: CalendarStyle.of<T>(context)
                                              .secondaryBackgroundColor,
                                        ))),
                                        child: Stack(children: [
                                          Column(
                                            children: [
                                              for (var i = 1; i < 25; i++)
                                                CalendarTimestamp<T>(
                                                  hour: i,
                                                  showTime: false,
                                                )
                                            ],
                                          ),
                                          for (var event in snapshot.data ?? [])
                                            CalendarEventBox<T>(
                                              event: event,
                                              left: -44,
                                              right: -4,
                                            )
                                        ]),
                                      )));
                            }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
