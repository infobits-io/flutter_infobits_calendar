import 'package:flutter/material.dart';

import 'calendar_event.dart';
import 'calendar_event_modal.dart';
import 'calendar_event_modal_options.dart';
import 'calendar_style.dart';
import 'on_hover.dart';
import 'responsive_layout.dart';

class CalendarEventBox<T extends CalendarEvent> extends StatelessWidget {
  final T event;
  final double left;
  final double right;

  const CalendarEventBox(
      {Key? key, required this.event, this.left = 0, this.right = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var startHour = event.startDate.toLocal().hour;
    var endHour = event.endDate?.toLocal().hour ?? startHour;
    var startMin = event.startDate.toLocal().minute;
    var endMin = event.endDate?.toLocal().minute ?? (startMin + 30) % 60;
    double topOffset = startHour * 60 + startMin * 1.0 - 10;

    var duration = (endHour + endMin / 60) - (startHour + startMin / 60);
    double height = duration * 60;

    var timePeriodString =
        "${startHour.toString().padLeft(2, "0")}:${startMin.toString().padLeft(2, "0")}${event.endDate != null ? "- ${endHour.toString().padLeft(2, "0")}:${endMin.toString().padLeft(2, "0")}" : ""}";

    var calendarStyle = CalendarStyle.of<T>(context);
    var eventStyle = calendarStyle.getEventStyle(event);

    return Positioned(
        top: topOffset,
        left: left + 45,
        right: right + 5,
        //width: 137,
        child: GestureDetector(
            onTap: () => openModal(context),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: LayoutBuilder(builder: (context, constraints) {
                return OnHover(builder: (hover) {
                  return Container(
                    color: calendarStyle.primaryColor,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                      opacity: hover ? 0.8 : 1,
                      child: Container(
                          height: height,
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 14),
                          decoration: BoxDecoration(
                            color: eventStyle.backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FittedBox(
                            alignment: Alignment.topCenter,
                            clipBehavior: Clip.hardEdge,
                            fit: BoxFit.none,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth - 28,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (event.endDate != null)
                                        Expanded(
                                          child: Text(
                                            timePeriodString,
                                            style: TextStyle(
                                              color: eventStyle.color,
                                              fontSize: 10,
                                            ),
                                            overflow: TextOverflow.fade,
                                            softWrap: true,
                                          ),
                                        ),
                                      if (event.endDate == null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3),
                                          child: Text(
                                            timePeriodString,
                                            style: TextStyle(
                                              color: eventStyle.color,
                                              fontSize: 10,
                                            ),
                                            overflow: TextOverflow.fade,
                                            softWrap: true,
                                          ),
                                        ),
                                      if (event.endDate == null)
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              event.title,
                                              style: TextStyle(
                                                color: eventStyle.color,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.fade,
                                              softWrap: true,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (event.endDate != null)
                                  SizedBox(
                                    width: constraints.maxWidth - 28,
                                    child: Text(
                                      event.title,
                                      style: TextStyle(
                                        color: eventStyle.color,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.fade,
                                      softWrap: true,
                                    ),
                                  ),
                                (event.subtitle != null && event.endDate != null
                                    ? SizedBox(
                                        width: constraints.maxWidth - 28,
                                        child: Text(
                                          event.subtitle!,
                                          style: TextStyle(
                                            color: eventStyle.color,
                                            fontSize: 13,
                                          ),
                                          overflow: TextOverflow.fade,
                                          softWrap: true,
                                        ),
                                      )
                                    : Container())
                              ],
                            ),
                          )),
                    ),
                  );
                });
              }),
            )));
  }

  void openModal(BuildContext context) {
    var calendarStyle = CalendarStyle.of<T>(context);
    var eventStyle = calendarStyle.getEventStyle(event);

    var modalOptions = CalendarEventModalOptions.of<T>(context);

    debugPrint(modalOptions.infoEntryBuilders.length.toString());

    if (ScreenSizes.isMobile(context)) {
      showModalBottomSheet<void>(
          context: context,
          backgroundColor: calendarStyle.primaryBackgroundColor,
          barrierColor: calendarStyle.barrierColor,
          isScrollControlled: true,
          constraints: BoxConstraints(
              maxHeight: (MediaQuery.of(context).size.height) - 50,
              maxWidth: (MediaQuery.of(context).size.width) - 40),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          builder: (BuildContext context) {
            return CalendarEventModal<T>(
              event: event,
              style: calendarStyle,
              eventStyle: eventStyle,
              options: modalOptions,
            );
          });
    } else {
      showDialog(
        context: context,
        barrierColor: calendarStyle.barrierColor,
        builder: (context) => Center(
            child: SizedBox(
          width: 600,
          child: Wrap(
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 5,
            runSpacing: 5,
            children: [
              CalendarEventModal<T>(
                event: event,
                style: calendarStyle,
                eventStyle: eventStyle,
                options: modalOptions,
                dialog: true,
              )
            ],
          ),
        )),
      );
    }
  }
}
