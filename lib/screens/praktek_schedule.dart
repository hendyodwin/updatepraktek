import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/controller/praktek_schedule_controller.dart';
import 'package:praktek_app/screens/praktek_price.dart';
import 'package:praktek_app/screens/praktek_schedule_add.dart';

class PraktekSchedule extends StatelessWidget {
  const PraktekSchedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PraktekScheduleController controller =
        Get.put(PraktekScheduleController());
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    NumberFormat formatter = new NumberFormat("00");
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.grey.withOpacity(0.2),
        elevation: 4,
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () async {
              var selectedTime = TimeOfDay.now();
              final TimeOfDay? timeOfDay = await showTimePicker(
                context: context,
                helpText: "Waktu mulai konsultasi 20 menit",
                initialTime: TimeOfDay.now(),
                initialEntryMode: TimePickerEntryMode.dial,
              );
              if (timeOfDay != null && timeOfDay != selectedTime) {
                print('======${timeOfDay}======');
                Get.find<PraktekScheduleController>().addTimeSlot(timeOfDay);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.add,
                color: kSecondary,
              ),
            ),
          )
        ],
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
          'Atur jadwal Anda',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  height: Get.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Biaya Konsultasi',
                              style: TextStyle(fontSize: 12, color: kText),
                            ),
                            InkWell(
                              onTap: () async {
                                var resultPrice =
                                    await Get.to(() => PraktekPrice());

                                if (resultPrice == 'true') {
                                  controller.isLoading.value = true;
                                  controller.getDoctor(
                                      Get.find<AuthController>().my_doctor_id);
                                  controller.isLoading.value = false;
                                }
                              },
                              child: Obx(
                                () => Text(
                                  'Rp. ${currencyFormatter.format(controller.doctor['attributes']['rate_video'])}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: kText,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 4,
                        thickness: 2,
                        color: Colors.grey.shade200,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                controller.selectedMonth.value ==
                                        controller.currentMonth.value
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          controller.previousMonth();
                                        },
                                        child: Icon(Icons.navigate_before)),
                                Obx(
                                  () => Text(
                                    '${controller.selectedMonth.value} ${controller.selectedYear.value}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                InkWell(
                                    onTap: () {
                                      controller.nexMonth();
                                    },
                                    child: Icon(Icons.navigate_next))
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              height: 80,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.lastDay.value -
                                      controller.today.value +
                                      1,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          controller.changeSelectedDate(
                                              controller.today.value + index);
                                        },
                                        child: Obx(
                                          () => Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              gradient: controller
                                                          .selectedDay ==
                                                      controller.today.value +
                                                          index
                                                  ? LinearGradient(
                                                      begin: Alignment
                                                          .bottomCenter,
                                                      end: Alignment.topCenter,
                                                      colors: [
                                                        kPrimary,
                                                        kSecondary,
                                                      ],
                                                      stops: [
                                                        0.0,
                                                        1.0,
                                                      ],
                                                    )
                                                  : null,
                                              boxShadow: [
                                                BoxShadow(
                                                    //offset: Offset(0, 4),
                                                    color: Colors.grey
                                                        .withOpacity(
                                                            0.2), //edited
                                                    spreadRadius: 1,
                                                    blurRadius: 5 //edited
                                                    ),
                                              ],
                                            ),
                                            width: 60,
                                            height: 80,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    (DateFormat('EEE').format(
                                                            DateTime.parse(
                                                                '${controller.selectedYear}-${controller.selectedMonthInt}-${formatter.format(controller.today.value + index)}')))
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: controller
                                                                    .selectedDay ==
                                                                controller.today
                                                                        .value +
                                                                    index
                                                            ? Colors.white
                                                            : Colors.black87),
                                                  ),
                                                  Text(
                                                    (controller.today.value +
                                                            index)
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: controller
                                                                    .selectedDay ==
                                                                controller.today
                                                                        .value +
                                                                    index
                                                            ? Colors.white
                                                            : Colors.black87),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Pagi',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Obx(
                              () => controller.scheduleMorning.length > 0
                                  ? Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      children: List.generate(
                                          controller.scheduleMorning.length,
                                          (index) {
                                        var utc = DateTime.parse(
                                            controller.scheduleMorning[index]
                                                ['attributes']['start']);
                                        return TimeSlotDoctor(
                                          time: DateFormat('hh:mm a')
                                              .format(utc.toLocal()),
                                          slot: controller
                                              .scheduleMorning[index]['id'],
                                        );
                                      }),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: AddTimeSlotDoctor(
                                        year: controller.selectedYear.value,
                                        month:
                                            controller.selectedMonthInt.value,
                                        day: controller.selectedDay.value,
                                        price: controller.doctor['attributes']
                                            ['rate_video'],
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Siang',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Obx(
                              () => controller.scheduleAfternoon.length > 0
                                  ? Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      children: List.generate(
                                          controller.scheduleAfternoon.length,
                                          (index) {
                                        var utc = DateTime.parse(
                                            controller.scheduleAfternoon[index]
                                                ['attributes']['start']);
                                        return TimeSlotDoctor(
                                            time: DateFormat('hh:mm a')
                                                .format(utc.toLocal()),
                                            slot: controller
                                                    .scheduleAfternoon[index]
                                                ['id']);
                                      }),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: AddTimeSlotDoctor(
                                        year: controller.selectedYear.value,
                                        month:
                                            controller.selectedMonthInt.value,
                                        day: controller.selectedDay.value,
                                        price: controller.doctor['attributes']
                                            ['rate_video'],
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Malam',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Obx(
                              () => controller.scheduleEvening.length > 0
                                  ? Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      children: List.generate(
                                          controller.scheduleEvening.length,
                                          (index) {
                                        var utc = DateTime.parse(
                                            controller.scheduleEvening[index]
                                                ['attributes']['start']);
                                        return TimeSlotDoctor(
                                            time: DateFormat('hh:mm a')
                                                .format(utc.toLocal()),
                                            slot: controller
                                                .scheduleEvening[index]['id']);
                                      }),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: AddTimeSlotDoctor(
                                        year: controller.selectedYear.value,
                                        month:
                                            controller.selectedMonthInt.value,
                                        day: controller.selectedDay.value,
                                        price: controller.doctor['attributes']
                                            ['rate_video'],
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class TimeSlotDoctor extends StatelessWidget {
  const TimeSlotDoctor({Key? key, required this.time, required this.slot})
      : super(key: key);
  final String time;
  final int slot;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onLongPress: () {
          Get.find<PraktekScheduleController>().removeTimeSlot(slot);
          print('Remove ${slot}');
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(
              Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                  //offset: Offset(0, 4),
                  color: Colors.grey.withOpacity(0.2), //edited
                  spreadRadius: 1,
                  blurRadius: 5 //edited
                  ),
            ],
          ),
          width: (Get.width * 0.8) / 3,
          height: 35,
          child: Center(
              child: Text(
            time,
            style: TextStyle(color: Colors.black),
          )),
        ),
      ),
    );
  }
}

class AddTimeSlotDoctor extends StatelessWidget {
  const AddTimeSlotDoctor(
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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () async {
          var selectedTime = TimeOfDay.now();
          final TimeOfDay? timeOfDay = await showTimePicker(
            context: context,
            helpText: "Waktu mulai konsultasi 20 menit",
            initialTime: TimeOfDay.now(),
            initialEntryMode: TimePickerEntryMode.dial,
          );
          if (timeOfDay != null && timeOfDay != selectedTime) {
            print('======${timeOfDay}======');
            Get.find<PraktekScheduleController>().addTimeSlot(timeOfDay);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(
              Radius.circular(28),
            ),
            border: Border.all(color: kSecondary),
            boxShadow: [
              BoxShadow(
                  //offset: Offset(0, 4),
                  color: Colors.grey.withOpacity(0.2), //edited
                  spreadRadius: 1,
                  blurRadius: 5 //edited
                  ),
            ],
          ),
          width: (Get.width * 0.8) / 3,
          height: 35,
          child: Center(
              child: Text(
            'Tambahkan',
            style: TextStyle(color: kSecondary),
          )),
        ),
      ),
    );
  }
}
