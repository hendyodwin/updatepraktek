import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praktek_app/constants/colors.dart';

import '../common_widgets/text_heading5.dart';
import '../common_widgets/text_heading6.dart';
import '../common_widgets/text_heading7.dart';

class DetailMedical extends StatelessWidget {
  DetailMedical({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Detail',
          style: GoogleFonts.poppins(fontSize: 15.sp, color: Colors.black),
        ),
      ),
      body: ListView(children: [
        SizedBox(
          height: kToolbarHeight,
        ),
        Divider(
          height: 2.h,
          color: kText,
          thickness: 0.2,
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
                        color: kSecondary,
                        padding: EdgeInsets.all(11),
                        child: Image.asset(
                          'assets/images/shape.png',

                          // fit: BoxFit.fill,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHeading7(
                          title: 'Tanggal:',
                          isBold: false,
                          color: kText2,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextHeading6(
                          title: '07/03/2021',
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
                      title: 'Keluhan: Jantung',
                      isBold: false,
                    ),
                    TextHeading7(
                      title: 'Video Call',
                      color: kPrimary,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Icon(Icons.arrow_drop_up)
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
                title: 'Jam:',
                isBold: false,
                color: kText2,
              ),
              const SizedBox(
                height: 5,
              ),
              TextHeading6(
                title: '09.30 WIB',
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
              TextHeading6(
                title: 'Disease',
                isBold: false,
                color: kText2,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: TextHeading7(
                  title:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry',
                  isBold: false,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              TextHeading6(
                title: 'Main Complaint',
                isBold: false,
                color: kText2,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: TextHeading7(
                  title:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s. Lorem Ipsum is simply dummy text of the printing.',
                  isBold: false,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              TextHeading6(
                title: 'Physical Examination',
                isBold: false,
                color: kText2,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: TextHeading7(
                  title:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s. Lorem Ipsum is simply dummy text of the printing.',
                  isBold: false,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              TextHeading6(
                title: 'Investigation',
                isBold: false,
                color: kText2,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: TextHeading7(
                  title:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s. Lorem Ipsum is simply dummy text of the printing.',
                  isBold: false,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              TextHeading6(
                title: 'Working Diagnose',
                isBold: false,
                color: kText2,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: TextHeading7(
                  title:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s. Lorem Ipsum is simply dummy text of the printing.',
                  isBold: false,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              TextHeading6(
                title: 'Treatment',
                isBold: false,
                color: kText2,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: TextHeading7(
                  title:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s. Lorem Ipsum is simply dummy text of the printing.',
                  isBold: false,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              TextHeading6(
                title: 'Recommendation ',
                isBold: false,
                color: kText2,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: TextHeading7(
                  title:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s. Lorem Ipsum is simply dummy text of the printing.',
                  isBold: false,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
