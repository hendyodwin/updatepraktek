import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/screens/doctor_profile_patient.dart';

class DoctorBox extends StatelessWidget {
  const DoctorBox({Key? key, required this.doctor}) : super(key: key);
  final Map doctor;
  @override
  Widget build(BuildContext context) {
    debugPrint(doctor.toString());
    return InkWell(
      onTap: () {
        Get.to(() => DoctorProfilePatient(doctor: doctor['id']));
      },
      child: Padding(
        padding:
            const EdgeInsets.only(right: 8.0, top: 16, bottom: 16, left: 8),
        child: Container(
            width: 184,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300.withOpacity(0.9),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
              border: Border.all(
                color: Colors.white,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                        color: kSecondary,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade300)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: doctor['attributes']['profile_picture']
                                        ['data']['attributes']['formats']
                                    ['medium'] ==
                                null
                            ? doctor['attributes']['profile_picture']['data']
                                ['attributes']['formats']['thumbnail']['url']
                            : doctor['attributes']['profile_picture']['data']
                                ['attributes']['formats']['medium']['url'],
                        fit: BoxFit.cover,
                        height: 120.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    doctor['attributes']['full_name'] ?? '-',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    doctor['attributes']['doctor_specialty']['data']
                        ['attributes']['name'],
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: kSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 12,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
