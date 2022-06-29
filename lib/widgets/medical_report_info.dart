import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:praktek_app/common_widgets/text_heading6.dart';
import 'package:praktek_app/common_widgets/text_heading7.dart';
import 'package:praktek_app/screens/detail_medical_report.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';

import '../helpers/debug.dart';

class MedicalRecordInfo extends StatelessWidget {
  MedicalRecordInfo({Key? key, required this.doctor}) : super(key: key);
  final Map doctor;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,##0', 'ID');

    DebugTools().printWrapped(doctor.toString());
    return InkWell(
      onTap: () {
        Get.to(DetailMedical());
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
            width: Get.width - 40,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
              border: Border.all(
                color: Colors.white,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                            height: 50.h,
                            width: 50.h,
                            color: kSecondary,
                            padding: EdgeInsets.all(11),
                            child: Image.asset(
                              'assets/images/shape.png',

                              // fit: BoxFit.fill,
                            )),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextHeading6(
                            title: 'Keluhan: Jantung',
                            isBold: false,
                          ),
                          TextHeading7(
                            title: 'Video Call',
                            isBold: false,
                            color: kSecondary,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.date_range_outlined,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 6.0, right: 6.0, top: 4, bottom: 4),
                            child: Text(
                              'Senin, 07/03/2021',
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Icon(
                            Icons.access_time,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            '09.30 WIB',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      Expanded(
                        flex: 5,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 150,
                            ),
                            height: 24.h,
                            decoration: BoxDecoration(
                              color: Colors.grey,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                            ),
                            child: Center(
                              child: Text(
                                'Lihat',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.sp,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                )
              ],
            )),
      ),
    );
  }
}
