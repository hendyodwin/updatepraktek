import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextHeading3 {
  final String? title;
  final bool? isBold;
  final Color color;
  const TextHeading3(
      {Key? key, this.color = Colors.black, this.title, this.isBold});

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? 'Text Heading 3',
      style: TextStyle(
          fontSize: 18.0.sp,
          fontWeight: isBold != null ? FontWeight.w600 : FontWeight.w400,
          color: color),
    );
  }
}
