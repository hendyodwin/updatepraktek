import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextHeading7 extends StatelessWidget {
  final String? title;
  final Color? color;
  final bool? isBold;
  const TextHeading7({Key? key, this.title, this.color, this.isBold});

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? 'Text Heading 6',
      style: TextStyle(
        fontSize: 11.0.sp,
        color: color ?? Colors.black,
        fontWeight: isBold ?? true ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
