import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextHeading5 extends StatelessWidget {
  final String? title;
  final bool centerTitle;
  final Color? color;
  final int? maxLines;
  final bool? isBold;
  const TextHeading5(
      {Key? key,
      this.centerTitle = false,
      this.maxLines = 1,
      this.title,
      this.color,
      this.isBold});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Text(
      title ?? 'Text Heading 6',
      maxLines: maxLines,
      textAlign: centerTitle ? TextAlign.center : TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 14.0.sp,
        color: color ?? Colors.black,
        fontWeight: isBold ?? true ? FontWeight.bold : FontWeight.normal,
        height: 1.5,
      ),
    );
  }
}
