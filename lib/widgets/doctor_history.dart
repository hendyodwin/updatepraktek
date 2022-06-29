import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/doctor_booking_detail_controller.dart';
import 'package:praktek_app/controller/doctor_history_controller.dart';
import 'package:praktek_app/widgets/doctor_history_appointment_box.dart';

class DoctorHistory extends StatelessWidget {
  const DoctorHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DoctorHistoryController controller =
        Get.put(DoctorHistoryController());
    final DoctorBookingDetailController controllerDetail =
        Get.put(DoctorBookingDetailController());

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
              shadowColor: Colors.grey.shade100,
              title: Text(
                'History',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 18),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 3,
              actions: [
                InkWell(
                  onTap: () {
                    controller.getMyOrdersScreenData();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.refresh,
                      color: kText,
                    ),
                  ),
                ),
              ]),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, top: 16, bottom: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          controller.updateIndex(0);
                        },
                        child: Obx(
                          () => FilterBox(
                            title: 'Upcoming Appointment',
                            color: controller.selectedIndex.value == 0
                                ? kPrimary
                                : kText,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.updateIndex(1);
                        },
                        child: Obx(
                          () => FilterBox(
                            title: 'Done',
                            color: controller.selectedIndex == 1
                                ? kPrimary
                                : kText,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.selectedIndex.value = 2;
                        },
                        child: Obx(
                          () => FilterBox(
                            title: 'Cancelled',
                            color: controller.selectedIndex.value == 2
                                ? kPrimary
                                : kText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Column(
                  children: List<Widget>.generate(
                    controller.selectedIndex.value == 0
                        ? controller
                            .my_orders_user_patient_video_upcoming.length
                        : controller.selectedIndex.value == 1
                            ? controller
                                .my_orders_user_patient_video_done.length
                            : controller.selectedIndex.value == 2
                                ? controller
                                    .my_orders_user_patient_video_cancelled
                                    .length
                                : controller
                                    .my_orders_user_patient_video_waiting
                                    .length,
                    (index) => DoctorHistoryAppointmentBox(
                        type: controller.selectedIndex.value,
                        appointment: controller.selectedIndex.value == 0
                            ? controller
                                .my_orders_user_patient_video_upcoming[index]
                            : controller.selectedIndex.value == 1
                                ? controller
                                    .my_orders_user_patient_video_done[index]
                                : controller.selectedIndex.value == 2
                                    ? controller
                                            .my_orders_user_patient_video_cancelled[
                                        index]
                                    : controller
                                            .my_orders_user_patient_video_waiting[
                                        index]),
                  ),
                ),
              ),
              Container(),
            ],
          ),
        ));
  }
}

class FilterBox extends StatelessWidget {
  const FilterBox({Key? key, required this.color, required this.title})
      : super(key: key);

  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            (Radius.circular(20)),
          ),
          border: Border.all(
            color: color,
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, top: 8.0, bottom: 8, right: 16),
          child: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12, color: color),
          ),
        ),
      ),
    );
  }
}
