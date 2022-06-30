import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/booking_detail_controller.dart';
import 'package:praktek_app/controller/history_controller.dart';
import 'package:praktek_app/screens/patient_list.dart';
import 'package:praktek_app/widgets/history_appointment_box.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.put(HistoryController());
    final BookingDetailController controllerDetail =
        Get.put(BookingDetailController());

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
              shadowColor: Colors.grey.shade100,
              title: Text(
                'Riwayat Konsultasi',
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
                            title: 'Janji Konsultasi Mendatang',
                            color: controller.selectedIndex.value == 0
                                ? kSecondary
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
                            title: 'Selesai',
                            color: controller.selectedIndex == 1
                                ? kSecondary
                                : kText,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.updateIndex(3);
                        },
                        child: Obx(
                          () => FilterBox(
                            title: 'Menunggu Pembayaran',
                            color: controller.selectedIndex == 3
                                ? kSecondary
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
                            title: 'Dibatalkan',
                            color: controller.selectedIndex.value == 2
                                ? kSecondary
                                : kText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() => controller.selectedIndex.value == 0 &&
                      controller.my_orders_user_patient_video_upcoming.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Image.asset('assets/images/konsultasi.png'),
                        Container(
                          child: Text('Tidak Ada Janji Konsultasi Mendatang'),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => PatientList());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                (Radius.circular(20)),
                              ),
                              border: Border.all(
                                color: kSecondary,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8.0, bottom: 8, right: 16),
                              child: Text(
                                'membuat janji',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kSecondary),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                      ],
                    )
                  : Container()),
              Obx(() => controller.selectedIndex.value == 1 &&
                      controller.my_orders_user_patient_video_done.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Image.asset('assets/images/konsultasi.png'),
                        Container(
                          child:
                              Text('Tidak Ada Konsultasi Yang Sudah Selesai'),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => PatientList());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                (Radius.circular(20)),
                              ),
                              border: Border.all(
                                color: kSecondary,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8.0, bottom: 8, right: 16),
                              child: Text(
                                'membuat janji',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kSecondary),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                      ],
                    )
                  : Container()),
              Obx(() => controller.selectedIndex.value == 3 &&
                      controller.my_orders_user_patient_video_waiting.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Image.asset('assets/images/konsultasi.png'),
                        Container(
                          child: Text(
                              'Tidak Ada Konsultasi Yang Menunggu Pembayaran'),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => PatientList());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                (Radius.circular(20)),
                              ),
                              border: Border.all(
                                color: kSecondary,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8.0, bottom: 8, right: 16),
                              child: Text(
                                'membuat janji',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kSecondary),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                      ],
                    )
                  : Container()),
              Obx(() => controller.selectedIndex.value == 2 &&
                      controller.my_orders_user_patient_video_cancelled.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Image.asset('assets/images/konsultasi.png'),
                        Container(
                          child: Text('Tidak Ada Konsultasi Yang Dibatalkan'),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => PatientList());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                (Radius.circular(20)),
                              ),
                              border: Border.all(
                                color: kSecondary,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8.0, bottom: 8, right: 16),
                              child: Text(
                                'membuat janji',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kSecondary),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                      ],
                    )
                  : Container()),
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
                    (index) => HistoryAppointmentBox(
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
