import 'package:flutter/material.dart';
import 'package:invoice_manage/core/constants/spacing_constants.dart';

class CircleIconBorderButton extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final Color backgroundColor;
  final double borderWidth;
  final Color borderColor;
  final double padding;

  const CircleIconBorderButton(
      {Key? key,
      required this.iconData,
      this.iconColor = Colors.black,
      this.backgroundColor = Colors.white,
      this.borderWidth = 1,
      this.borderColor = Colors.black12,
      this.padding = spacingSmallX})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: CircleBorder(),
      onTap: () => {},
      child: Ink(
        child: Icon(iconData, color: iconColor),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: CircleBorder(
              side: BorderSide(width: borderWidth, color: borderColor)),
        ),
        padding: EdgeInsets.all(padding),
      ),
    );
  }
}
