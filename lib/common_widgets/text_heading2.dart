import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextHeading2 {
  final String title;
  final bool? isBold;
  final int? maxLines;
  const TextHeading2(
      {Key? key, this.maxLines, required this.title, this.isBold});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Text(
      title,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: 20.0.sp,
          fontWeight: isBold != null ? FontWeight.w600 : FontWeight.w400),
      textAlign: TextAlign.left,
    );
  }
}
