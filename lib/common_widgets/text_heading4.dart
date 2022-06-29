import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextHeading4 {
  final String? title;
  final bool? isBold;
  final bool? isCenter;
  final Color color;
  final int maxLines;
  const TextHeading4({
    Key? key,
    this.color = Colors.black,
    this.title,
    this.isCenter = false,
    this.isBold,
    this.maxLines = 1,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Text(
      title ?? 'Text Heading 6',
      maxLines: maxLines,
      textAlign: isCenter == true ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontSize: 16.0.sp,
        fontWeight: isBold != null ? FontWeight.w600 : FontWeight.w400,
        color: color,
        height: 1.3,
      ),
    );
  }
}
