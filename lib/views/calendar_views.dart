import '../responsive_layout.dart';

export 'calendar_list_view.dart';
export 'calendar_day_view.dart';
export 'calendar_3day_view.dart';
export 'calendar_workweek_view.dart';
export 'calendar_week_view.dart';
export 'calendar_month_view.dart';
export 'calendar_view.dart';

enum CalendarViewType { list, day, threeday, workweek, week, month }

class CalendarViewProvider {
  final CalendarViewType mobileViewType;
  final CalendarViewType tabletViewType;
  final CalendarViewType laptopViewType;
  final CalendarViewType desktopViewType;

  const CalendarViewProvider({
    this.mobileViewType = CalendarViewType.day,
    this.tabletViewType = CalendarViewType.threeday,
    this.laptopViewType = CalendarViewType.workweek,
    this.desktopViewType = CalendarViewType.week,
  });

  CalendarViewType getType(context) {
    if (ScreenSizes.isMobile(context)) {
      return mobileViewType;
    } else if (ScreenSizes.isTablet(context)) {
      return tabletViewType;
    } else if (ScreenSizes.isLaptop(context)) {
      return laptopViewType;
    }
    return desktopViewType;
  }
}
