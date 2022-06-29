import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextHeading6 extends StatelessWidget {
  final String? title;
  final Color? color;
  final bool? isBold;
  final bool? isCenter;

  const TextHeading6(
      {Key? key, this.isCenter, this.title, this.color, this.isBold});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Text(
      title ?? 'Text Heading 6',
      textAlign: isCenter ?? true ? TextAlign.center : TextAlign.left,
      style: TextStyle(
        fontSize: 12.0.sp,
        color: color ?? Colors.black,
        fontWeight: isBold ?? true ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
