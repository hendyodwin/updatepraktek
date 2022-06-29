import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextHeading1 {
  final String? title;
  final bool? isBold;
  final Color? color;
  const TextHeading1({Key? key, this.title, this.isBold, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? 'Text Heading 1',
      style: TextStyle(
          fontSize: 23.0.sp,
          fontWeight: isBold != null ? FontWeight.w600 : FontWeight.w400,
          color: color ?? Colors.black),
      textAlign: TextAlign.left,
    );
  }
}
