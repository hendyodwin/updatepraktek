import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:praktek_app/controller/doctor_profile_controller.dart';
import 'package:praktek_app/screens/doctor_booking_detail_chat_patient.dart';
import 'package:praktek_app/screens/doctor_schedule_patient.dart';
import 'package:readmore/readmore.dart';
import 'package:timelines/timelines.dart';

import '../constants/colors.dart';

class DoctorProfilePatient extends StatelessWidget {
  const DoctorProfilePatient({Key? key, required this.doctor})
      : super(key: key);
  final int doctor;
  @override
  Widget build(BuildContext context) {
    final DoctorProfileController controller =
        Get.put(DoctorProfileController());
    controller.doctorId.value = this.doctor;
    final currencyFormatter = NumberFormat('#,##0', 'ID');

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
          'Profil dokter',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  SingleChildScrollView(
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
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: kSecondary,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: CachedNetworkImage(
                                        imageUrl: controller.doctor['attributes']
                                                            ['profile_picture']
                                                        ['data']['attributes']
                                                    ['formats']['medium'] ==
                                                null
                                            ? controller.doctor['attributes']
                                                    ['profile_picture']['data']['attributes']
                                                ['formats']['thumbnail']['url']
                                            : controller.doctor['attributes']
                                                    ['profile_picture']['data']
                                                ['attributes']['formats']['medium']['url'],
                                        fit: BoxFit.cover,
                                        height: 120.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.doctor['attributes']
                                              ['full_name'] ??
                                          '-',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      controller.doctor['attributes']
                                              ['doctor_specialty']['data']
                                          ['attributes']['name'],
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: kSecondary),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            // border: Border.all(
                                            //   color: kSecondary,
                                            // ),
                                            color: kSecondaryBG,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 6.0,
                                                right: 6.0,
                                                top: 4,
                                                bottom: 4),
                                            child: Text(
                                              '${controller.doctor['attributes']['years_experience']}th Pengalaman',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: kSecondary),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                        Text(
                                          controller.doctor['attributes']
                                                  ['review']
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
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
                                Text(
                                  'About Me:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                ReadMoreText(
                                  controller.doctor['attributes']['about'] ??
                                      '-',
                                  trimLines: 4,
                                  colorClickableText: kPrimary,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: '\nShow more',
                                  trimExpandedText: 'Show less',
                                  style: TextStyle(color: kText2),
                                  moreStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: kPrimary),
                                  lessStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: kSecondary),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                controller
                                            .doctor['attributes']
                                                ['doctor_cv_educations']['data']
                                            .length >
                                        0
                                    ? Text(
                                        'Educational Background:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Container(),
                                controller
                                            .doctor['attributes']
                                                ['doctor_cv_educations']['data']
                                            .length >
                                        0
                                    ? SizedBox(
                                        height: 8,
                                      )
                                    : Container(),
                                FixedTimeline.tileBuilder(
                                  theme: TimelineThemeData(
                                      color: kText2,
                                      nodePosition: 0.0,
                                      connectorTheme:
                                          ConnectorThemeData(space: 51)),
                                  builder:
                                      TimelineTileBuilder.connectedFromStyle(
                                    connectionDirection:
                                        ConnectionDirection.before,
                                    connectorStyleBuilder: (context, index) {
                                      return (index == 1 ||
                                              index ==
                                                  controller
                                                      .doctor['attributes'][
                                                          'doctor_cv_educations']
                                                          ['data']
                                                      .length)
                                          ? ConnectorStyle.dashedLine
                                          : ConnectorStyle.solidLine;
                                    },
                                    indicatorStyleBuilder: (context, index) =>
                                        IndicatorStyle.dot,
                                    contentsBuilder: (context, index) =>
                                        Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.doctor['attributes']
                                                    ['doctor_cv_educations']
                                                    ['data'][index]
                                                    ['attributes']['year']
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(controller.doctor['attributes']
                                                      ['doctor_cv_educations']
                                                  ['data'][index]['attributes']
                                              ['name']),
                                        ],
                                      ),
                                    ),
                                    itemCount: controller
                                        .doctor['attributes']
                                            ['doctor_cv_educations']['data']
                                        .length,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 20,
                      left: 20,
                      child: InkWell(
                        onTap: () {
                          Get.defaultDialog(
                              title: "Consult by",
                              backgroundColor: Colors.white,
                              titleStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              titlePadding: EdgeInsets.only(top: 16, bottom: 0),
                              middleTextStyle: TextStyle(color: Colors.white),
                              barrierDismissible: true,
                              radius: 20,
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      height: 4,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                        Get.to(() => DoctorSchedulePatient(
                                              doctor: this.doctor,
                                            ));
                                      },
                                      child: Container(
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                            color: kPrimary.withOpacity(0.1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                          child: Row(
                                            children: [
                                              MaterialButton(
                                                color: kSecondary,
                                                shape: const CircleBorder(),
                                                onPressed: () {
                                                  Get.back();
                                                  Get.to(() =>
                                                      DoctorSchedulePatient(
                                                        doctor: this.doctor,
                                                      ));
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Icon(
                                                    Icons.video_call_rounded,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 16,
                                                  ),
                                                  Text(
                                                    'Video Call',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    'Consult with your doctor by video call',
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        color: kText,
                                                        fontSize: 8),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    'Rp. ${currencyFormatter.format(controller.doctor['attributes']['rate_video'])}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(() =>
                                            DoctorBookingDetailChatPatient(
                                                doctor: doctor));
                                      },
                                      child: Container(
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                            color: kPrimary.withOpacity(0.1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                          child: Row(
                                            children: [
                                              MaterialButton(
                                                color: kSecondary,
                                                shape: const CircleBorder(),
                                                onPressed: () {
                                                  Get.to(() =>
                                                      DoctorBookingDetailChatPatient(
                                                          doctor: doctor));
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Icon(
                                                    Icons.message_rounded,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 16,
                                                  ),
                                                  Text(
                                                    'Chat',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    'Consult with your doctor by chat',
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        color: kText,
                                                        fontSize: 8),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    'Rp. ${currencyFormatter.format(controller.doctor['attributes']['rate_chat'])}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ));
                        },
                        child: Container(
                          width: Get.width - 40,
                          decoration: BoxDecoration(
                            // border: Border.all(
                            //   color: kSecondary,
                            // ),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                kPrimary,
                                kSecondary,
                              ],
                              stops: [
                                0.0,
                                1.0,
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16, top: 12, bottom: 12),
                              child: Text(
                                'Book Consultation',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
      ),
    );
  }
}
