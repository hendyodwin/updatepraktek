import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PraktekScheduleAdd extends StatelessWidget {
  const PraktekScheduleAdd(
      {Key? key,
      required this.month,
      required this.year,
      required this.day,
      required this.price})
      : super(key: key);
  final String month;
  final String year;
  final int day;
  final int price;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.grey.withOpacity(0.2),
          elevation: 4,
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: Text(
            'Add a schedule',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 16,
            ),
            Container(
              width: Get.width,
              child: Center(
                  child: Text(
                '${this.day}-${this.month}-${this.year}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              )),
            ),
            TimePickerDialog(
              initialTime: TimeOfDay.now(),
              initialEntryMode: TimePickerEntryMode.input,
              confirmText: "CONFIRM",
              cancelText: "NOT NOW",
              helpText: "BOOKING TIME",
            )
          ],
        ));
  }
}
