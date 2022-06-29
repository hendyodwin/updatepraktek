import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPhotoBox extends StatelessWidget {
  const AddPhotoBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      height: (Get.width - 60) / 4,
      width: (Get.width - 60) / 4,
      child: Center(
        child: Icon(
          Icons.add,
          color: Colors.grey,
          size: 30,
        ),
      ),
    );
  }
}
