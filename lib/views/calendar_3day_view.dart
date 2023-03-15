import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../extensions/date_time.dart';

import '../calendar_event.dart';
import '../calendar_event_box.dart';
import '../calendar_nav.dart';
import '../calendar_nav_day.dart';
import '../calendar_style.dart';
import 'calendar_view.dart';

class SyncScrollController {
  List<ScrollController> registeredScrollControllers = [];

  ScrollController? _scrollingController;
  bool _scrollingActive = false;

  SyncScrollController({this.registeredScrollControllers = const []});

  void registerScrollController(ScrollController controller) {
    registeredScrollControllers.add(controller);
  }

  void processNotification(
      ScrollNotification notification, ScrollController sender) {
    if (notification is ScrollStartNotification && !_scrollingActive) {
      _scrollingController = sender;
      _scrollingActive = true;
      return;
    }

    if (identical(sender, _scrollingController) && _scrollingActive) {
      if (notification is ScrollEndNotification) {
        _scrollingController = null;
        _scrollingActive = false;
        return;
      }

      if (notification is ScrollUpdateNotification &&
          _scrollingController != null) {
        registeredScrollControllers.forEach((controller) => {
              if (!identical(_scrollingController, controller) &&
                  controller.hasClients)
                controller..jumpTo(_scrollingController!.offset)
            });
        return;
      }
    }
  }
}

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
  late ScrollController timestampController;
  CarouselController carouselController = CarouselController();
  late SyncScrollController syncController;

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
    timestampController = ScrollController(
      initialScrollOffset: scrollOffset,
      debugLabel: "scroll-controller-timestamp",
    );
    syncController = SyncScrollController(
        registeredScrollControllers: [timestampController]);
    super.initState();
  }

  // TODO: When jumpTo is triggered it triggers the ScrollNotification. This creates infinite loop...
  bool onScroll(ScrollNotification scrollNotification,
      ScrollController currentController) {
    scrollOffset = scrollNotification.metrics.pixels;
    syncController.processNotification(scrollNotification, currentController);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: LayoutBuilder(builder: (ctx, constraints) {
        final double height = constraints.maxHeight;

        return Row(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) =>
                  onScroll(scrollNotification, timestampController),
              child: Container(
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
                    debugLabel: "scroll-controller-$index",
                  );
                  syncController.registerScrollController(controller);

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
                                onNotification: (scrollNotification) =>
                                    onScroll(scrollNotification, controller),
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
                                        ...insertEventBox(
                                          event: event,
                                          eventWidth: double.infinity,
                                          viewDays: 1,
                                          viewStart: itemStartDate,
                                          viewEnd: itemEndDate,
                                        )
                                      // CalendarEventBox<T>(
                                      //   event: event,
                                      //   left: -44,
                                      //   right: -4,
                                      // )
                                    ]),
                                  ),
                                ),
                              );
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
