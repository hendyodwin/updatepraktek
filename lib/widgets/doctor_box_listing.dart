import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/controller/listing_controller.dart';
import 'package:praktek_app/helpers/debug.dart';
import 'package:praktek_app/screens/doctor_profile_patient.dart';

class DoctorBoxListing extends StatelessWidget {
  const DoctorBoxListing({Key? key, required this.doctor}) : super(key: key);
  final Map doctor;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,##0', 'ID');

    DebugTools().printWrapped(doctor.toString());
    return InkWell(
      onTap: () {
        Get.to(() => DoctorProfilePatient(doctor: doctor['id']));
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
                      SizedBox(
                        width: 65,
                        child: Stack(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: kSecondary,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border:
                                      Border.all(color: Colors.grey.shade300)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: doctor['attributes']
                                              ['profile_picture']['data']
                                          ['attributes']['formats']['thumbnail']
                                      ['url'],
                                  fit: BoxFit.cover,
                                  height: 120.0,
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: RawMaterialButton(
                                    onPressed: () {},
                                    elevation: 2.0,
                                    fillColor: kSecondary,
                                    child: Icon(
                                      Icons.video_call,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    padding: EdgeInsets.all(2.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(color: Colors.white)),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor['attributes']['full_name'] ?? '-',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            doctor['attributes']['doctor_specialty']['data']
                                ['attributes']['name'],
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: kSecondary),
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
                          Container(
                            decoration: BoxDecoration(
                              // border: Border.all(
                              //   color: kSecondary,
                              // ),
                              color: kSecondaryBG,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 6.0, right: 6.0, top: 4, bottom: 4),
                              child: Text(
                                '${doctor['attributes']['years_experience']}th Pengalaman',
                                style:
                                    TextStyle(fontSize: 10, color: kSecondary),
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
                            doctor['attributes']['review'].toString(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Rp. ${currencyFormatter.format(doctor['attributes']['rate_video'])}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.find<ListingController>()
                              .saveDoctor(doctor['id'], true);
                        },
                        child: Container(
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
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Get.find<AuthController>()
                                  .user_doctors_ids
                                  .contains(doctor['id'])
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16, top: 8, bottom: 8),
                                  child: Text(
                                    'Simpan',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                        ),
                      )
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
