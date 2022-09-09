library infobits_calendar;

import 'package:flutter/material.dart';

import 'buttons.dart';
import 'calendar_event.dart';
import 'calendar_event_modal_options.dart';
import 'calendar_event_provider.dart';
import 'calendar_month_overview.dart';
import 'calendar_style.dart';
import 'calendar_text.dart';
import 'calendar_title.dart';
import 'responsive_layout.dart';
import 'views/calendar_views.dart';

export 'calendar_style.dart';
export 'calendar_event_provider.dart';
export 'views/calendar_views.dart';
export 'calendar_event.dart';
export 'calendar_event_modal_options.dart';
export 'calendar_text.dart';

/// TODO:
/// Add list view
/// Fix sommertime/vintertime.... (calendar overview)
/// Create event

class Calendar<T extends CalendarEvent> extends StatefulWidget {
  final CalendarEventProvider<T> eventProvider;
  final CalendarEventModalOptions<T> eventModalOptions;
  final CalendarViewProvider viewProvider;
  final List<CalendarQuickAction<T>> extraActions;
  final Widget? extraContent;
  final CalendarStyle<T> style;
  final CalendarText text;
  final void Function()? onCreatePressed;

  const Calendar({
    super.key,
    required this.eventProvider,
    this.style = const CalendarStyle(),
    this.text = const CalendarText(),
    this.eventModalOptions = const CalendarEventModalOptions(),
    this.viewProvider = const CalendarViewProvider(),
    this.extraActions = const [],
    this.extraContent,
    this.onCreatePressed,
  });

  @override
  State<Calendar> createState() => _CalendarState<T>();
}

class _CalendarState<T extends CalendarEvent> extends State<Calendar<T>> {
  bool monthDropdownOpen = false;
  bool dropdownShowingOverview = true;
  ScrollController dropdownScrollController = ScrollController();
  late GlobalKey<CalendarViewState<T, CalendarView<T>>> viewKey;
  late GlobalKey<CalendarMonthOverviewState<T>> overviewKey;

  late DateTime startShowingDate;
  late DateTime endShowingDate;

  @override
  void initState() {
    viewKey = GlobalKey(debugLabel: "calendar_view_key");
    overviewKey = GlobalKey(debugLabel: "calendar_overview_key");
    startShowingDate = DateTime.now();
    endShowingDate = DateTime.now();
    super.initState();
  }

  void createEvent() {
    if (widget.onCreatePressed != null) {
      widget.onCreatePressed!();
    } else {
      debugPrint("onCreatePressed is not configured");
    }
  }

  void onShowingDateChange(DateTime startDate, DateTime endDate,
      {bool updateAll = true, bool updateView = true, updateOverview = true}) {
    startShowingDate = startDate;
    endShowingDate = endDate;

    if (updateAll) {
      setState(() {});
    }

    if (updateView) {
      viewKey.currentState?.setShowingDateInterval(startDate, endDate);
    }

    if (updateOverview) {
      overviewKey.currentState?.checkDaySelected(startDate, endDate);
    }
  }

  void onOverviewDayPressed(DateTime dayDate) {
    viewKey.currentState?.updateCurrentShowingDates(dayDate, dayDate);
  }

  CalendarView getView(CalendarViewType viewType) {
    switch (viewType) {
      case CalendarViewType.day:
        return CalendarDayView<T>(
          key: viewKey,
          eventProvider: widget.eventProvider,
          initialStartShowingDate: startShowingDate,
          initialEndShowingDate: endShowingDate,
          onDateIntervalChange: onShowingDateChange,
        );
      case CalendarViewType.threeday:
        return Calendar3DayView<T>(
          key: viewKey,
          eventProvider: widget.eventProvider,
          initialStartShowingDate: startShowingDate,
          initialEndShowingDate: endShowingDate,
          onDateIntervalChange: onShowingDateChange,
        );
      case CalendarViewType.workweek:
        return CalendarWorkweekView<T>(
          key: viewKey,
          eventProvider: widget.eventProvider,
          initialStartShowingDate: startShowingDate,
          initialEndShowingDate: endShowingDate,
          onDateIntervalChange: onShowingDateChange,
        );
      case CalendarViewType.week:
        return CalendarWeekView<T>(
          key: viewKey,
          eventProvider: widget.eventProvider,
          initialStartShowingDate: startShowingDate,
          initialEndShowingDate: endShowingDate,
          onDateIntervalChange: onShowingDateChange,
        );
      default:
        return CalendarWeekView<T>(
          key: viewKey,
          eventProvider: widget.eventProvider,
          initialStartShowingDate: startShowingDate,
          initialEndShowingDate: endShowingDate,
          onDateIntervalChange: onShowingDateChange,
        );
    }
  }

  void toggleMonthOverview() {
    setState(() {
      monthDropdownOpen = !monthDropdownOpen;
    });
  }

  void closeMonthOverview() {
    setState(() {
      monthDropdownOpen = false;
    });
  }

  void onLeftPressed() {
    viewKey.currentState?.prevShowingPeriod();
  }

  Widget _leftButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: GestureDetector(
          onTap: onLeftPressed,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              color: widget.style.primaryBackgroundColor,
              child: widget.style.icons.leftIcon,
            ),
          ),
        ));
  }

  void onRightPressed() {
    viewKey.currentState?.nextShowingPeriod();
  }

  void dropdownSwitchToOffset(double offset) {
    dropdownScrollController.animateTo(offset,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    setState(() {
      dropdownShowingOverview = offset == 0;
    });
  }

  Widget _rightButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: GestureDetector(
          onTap: onRightPressed,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              color: widget.style.primaryBackgroundColor,
              child: widget.style.icons.rightIcon,
            ),
          ),
        ));
  }

  Widget _buildSmallScreen(BuildContext context, CalendarView view) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dy < -10) {
          closeMonthOverview();
        }
      },
      child: Column(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              sizeCurve: Curves.ease,
              firstCurve: Curves.ease,
              secondCurve: Curves.ease,
              firstChild: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(2),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: widget.style.secondaryBackgroundColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                            onTap: () => dropdownSwitchToOffset(0),
                            child: Container(
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                vertical: 7,
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                color: dropdownShowingOverview
                                    ? widget.style.primaryBackgroundColor
                                    : widget.style.secondaryBackgroundColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Center(child: Text(widget.text.overview)),
                            )),
                        GestureDetector(
                            onTap: () =>
                                dropdownSwitchToOffset(constraints.maxWidth),
                            child: Container(
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                vertical: 7,
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                color: dropdownShowingOverview
                                    ? widget.style.secondaryBackgroundColor
                                    : widget.style.primaryBackgroundColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Center(child: Text(widget.text.extra)),
                            ))
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    controller: dropdownScrollController,
                    child: SizedBox(
                      width: constraints.maxWidth * 2,
                      child: Row(
                        children: [
                          SizedBox(
                            width: constraints.maxWidth,
                            child: CalendarMonthOverview<T>(
                              key: overviewKey,
                              onDayPressed: onOverviewDayPressed,
                              startShowingDate: startShowingDate,
                              endShowingDate: endShowingDate,
                            ),
                          ),
                          Container(
                            width: constraints.maxWidth,
                            height: 400,
                            padding: const EdgeInsets.all(10),
                            child: widget.extraContent,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [...widget.extraActions],
                    ),
                  )
                ],
              ),
              secondChild: Container(),
              crossFadeState: monthDropdownOpen
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            );
          }),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            sizeCurve: Curves.ease,
            firstCurve: Curves.ease,
            secondCurve: Curves.ease,
            firstChild: Row(
              children: [
                _leftButton(context),
                Expanded(
                  child: CalendarTitle<T>(
                    onPressed: () => toggleMonthOverview(),
                    startShowingDate: startShowingDate,
                    endShowingDate: endShowingDate,
                  ),
                ),
                _rightButton(context),
              ],
            ),
            secondChild: GestureDetector(
              onTap: closeMonthOverview,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 7,
                  horizontal: 14,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: widget.style.secondaryBackgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(999),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.style.icons.upIcon,
                    Text(widget.text.clickClose),
                    widget.style.icons.upIcon,
                  ],
                ),
              ),
            ),
            crossFadeState: monthDropdownOpen
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
          Expanded(
            child: GestureDetector(
              onTap: closeMonthOverview,
              child: view,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeScreen(BuildContext context, CalendarView view) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryButton<T>(
                          icon: widget.style.icons.createIcon,
                          text: widget.text.createText,
                          onPressed: createEvent,
                        ),
                      ],
                    ),
                  ),
                  ...widget.extraActions
                ],
              ),
            ),
            CalendarMonthOverview<T>(
              key: overviewKey,
              onDayPressed: onOverviewDayPressed,
              startShowingDate: startShowingDate,
              endShowingDate: endShowingDate,
            ),
            if (widget.extraContent != null)
              SingleChildScrollView(
                child: widget.extraContent!,
              )
          ],
        ),
      ),
      Expanded(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                _leftButton(context),
                _rightButton(context),
                Expanded(
                  child: CalendarTitle<T>(
                    startShowingDate: startShowingDate,
                    endShowingDate: endShowingDate,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: view),
        ],
      ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: false,
      child: InheritedCalendarStyle<T>(
        style: widget.style,
        child: InheritedCalendarText(
          text: widget.text,
          child: InheritedCalendarEventModalOptions<T>(
            options: widget.eventModalOptions,
            child: ResponsiveLayout(
              desktop: _buildLargeScreen(
                  context, getView(widget.viewProvider.getType(context))),
              laptop: _buildLargeScreen(
                  context, getView(widget.viewProvider.getType(context))),
              tablet: _buildSmallScreen(
                  context, getView(widget.viewProvider.getType(context))),
              mobile: _buildSmallScreen(
                  context, getView(widget.viewProvider.getType(context))),
            ),
          ),
        ),
      ),
    );
  }
}

class CalendarQuickAction<T extends CalendarEvent> extends StatelessWidget {
  final Widget icon;
  final String title;
  final void Function() onPressed;

  const CalendarQuickAction(
      {super.key,
      required this.icon,
      required this.title,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 7, horizontal: ScreenSizes.isMobile(context) ? 14 : 7),
        decoration: BoxDecoration(
          color: CalendarStyle.of<T>(context).secondaryBackgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(999),
          ),
        ),
        child: Row(
          children: [
            icon,
            if (ScreenSizes.isMobile(context))
              Padding(
                padding: const EdgeInsets.fromLTRB(7, 2, 2, 2),
                child: Text(title),
              ),
          ],
        ),
      ),
    );
  }
}
