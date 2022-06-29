import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praktek_app/common_widgets/text_heading5.dart';
import 'package:praktek_app/common_widgets/text_heading6.dart';
import 'package:praktek_app/common_widgets/text_heading7.dart';
import 'package:praktek_app/widgets/medical_report_info.dart';

import '../constants/colors.dart';
import '../controller/listing_controller.dart';

class MedialRecordScreen extends StatelessWidget {
  MedialRecordScreen({Key? key}) : super(key: key);
  final ListingController controller = Get.put(ListingController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: CupertinoColors.white,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
            title: Text(
              'Medical Record',
              style: GoogleFonts.poppins(fontSize: 15.sp, color: Colors.black),
            ),
          ),
          body: ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: kToolbarHeight,
                margin: EdgeInsets.only(left: 20.w),
                padding: EdgeInsets.symmetric(vertical: 20.h),
                // color: Colors.white,
                child: Wrap(spacing: 2.w, children: [
                  TextHeading6(
                    title: 'No. MR:',
                    isBold: false,
                    color: Colors.grey,
                  ),
                  TextHeading6(title: '8700-8000'),
                ]),
              ),
              Divider(
                height: 2,
                color: Colors.grey,
              ),
              Container(
                margin: const EdgeInsets.all(20),
                // height: 131.h,
                // color: Colors.white,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                              height: 50.h,
                              width: 50.h,
                              child: Image.asset(
                                'assets/images/4.0x/doctor-1.png',
                                fit: BoxFit.cover,
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextHeading7(
                                title: 'Gender:',
                                isBold: false,
                                color: kText2,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextHeading6(
                                title: 'Male',
                                isBold: false,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextHeading5(
                            title: 'Aurelie Moeramoe',
                            isBold: false,
                          ),
                          TextHeading7(
                            title: '27 Tahun',
                            color: kPrimary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 2.h,
                color: Colors.grey,
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextHeading7(
                      title: 'Date of Birth:',
                      isBold: false,
                      color: kText2,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextHeading6(
                      title: '01/09/1994',
                      isBold: false,
                    ),
                  ],
                ),
              ),
              Divider(
                height: 2,
                color: Colors.grey,
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextHeading7(
                      title: 'Address:',
                      isBold: false,
                      color: kText2,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextHeading6(
                      title: 'Kelapa Gading Martin',
                      isBold: false,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextHeading7(
                      title:
                          'Jl. Raya Martin - Kelapa Gading No.8, Kec. Pagedangan, Tangerang, Banten 15810',
                      isBold: false,
                      color: kText2,
                    ),
                  ],
                ),
              ),
              Divider(
                height: 2,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.h, left: 20.w, bottom: 16.h),
                child: TextHeading5(
                  title: 'Riwayat',
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Column(children: [
                  ...controller.doctorList.value.map((product) {
                    return MedicalRecordInfo(
                      doctor: product,
                    );
                  }).toList(),
                ]),
              ),
              const SizedBox(
                height: 14,
              ),
              // OutlinedButton(
              //   onPressed: () {},
              //   child: Text(
              //     "Lihat Semua",
              //     style: TextStyle(
              //         fontSize: 12.sp,
              //         color: kPrimary,
              //         fontWeight: FontWeight.bold),
              //   ),
              // )
              Center(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    height: 30,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: kPrimary, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        'Lihat Semua',
                        style:
                            GoogleFonts.poppins(fontSize: 10, color: kPrimary),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 48,
              )
            ],
          )),
    );
  }
}
