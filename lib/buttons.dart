import 'package:flutter/material.dart';

import 'calendar_style.dart';

class DefualtButton extends StatelessWidget {
  final IconData? icon;
  final String text;
  final Function()? onPressed;
  final Color? backgroundColor;
  final Color? color;

  const DefualtButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return _build(
      context,
      color ?? CalendarStyle.of(context).primaryColorContrast,
      backgroundColor ?? CalendarStyle.of(context).primaryColor,
    );
  }

  Widget _build(BuildContext context, Color color, Color bgColor) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: bgColor, borderRadius: BorderRadius.circular(999)),
            child: IconTheme(
              data: IconThemeData(color: color, size: 17),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (icon != null)
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 7, 0),
                      child: icon != null ? Icon(icon) : Container(),
                    ),
                  Text(
                    text,
                    style: TextStyle(
                        color: color,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends DefualtButton {
  const PrimaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.icon,
  });
}

class SecondaryButton extends DefualtButton {
  const SecondaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.icon,
  });

  @override
  Widget build(BuildContext context) {
    return _build(context, CalendarStyle.of(context).primaryTextColor,
        CalendarStyle.of(context).secondaryBackgroundColor);
  }
}
