import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/booking_detail_controller.dart';
import 'package:praktek_app/screens/doctor_booking_payment_confirmation.dart';
import 'package:praktek_app/screens/doctor_join_room.dart';

class DoctorHistoryAppointmentBox extends StatelessWidget {
  const DoctorHistoryAppointmentBox(
      {Key? key, required this.appointment, required this.type})
      : super(key: key);
  final Map appointment;
  final int type;
  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    NumberFormat formatter = new NumberFormat("00");

    return InkWell(
      onTap: () {
        print('Appointment Clicked');
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
            width: Get.width - 40,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300.withOpacity(0.9),
                  spreadRadius: 3,
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
                                  imageUrl: appointment['attributes']['profile']['data']['attributes']
                                                  ['profile_picture']['data']['attributes']
                                              ['formats']['medium'] ==
                                          null
                                      ? appointment['attributes']['profile']['data']['attributes']
                                              ['profile_picture']['data']['attributes']
                                          ['formats']['thumbnail']['url']
                                      : appointment['attributes']['profile']['data']
                                              ['attributes']['profile_picture']['data']
                                          ['attributes']['formats']['medium']['url'],
                                  fit: BoxFit.cover,
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
                            appointment['attributes']['profile']['data']
                                    ['attributes']['name'] ??
                                '-',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            appointment['attributes']['patient_notes'] ?? '-',
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
                    children: [
                      Row(
                        children: [
                          Icon(
                            LineIcons.calendar,
                            size: 14,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            (DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(appointment['attributes']
                                            ['doctor_availability']['data']
                                        ['attributes']['start'])
                                    .toLocal())
                                .toString()),
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Row(
                        children: [
                          Icon(
                            LineIcons.clock,
                            size: 14,
                          ),
                          Text(
                            (DateFormat('HH:mm')
                                .format(DateTime.parse(appointment['attributes']
                                            ['doctor_availability']['data']
                                        ['attributes']['start'])
                                    .toLocal())
                                .toString()),
                            style: TextStyle(fontSize: 12),
                          )
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
                      Text(
                        'Rp. ${currencyFormatter.format(appointment['attributes']['amount'])}',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      type == 0
                          ? InkWell(
                              onTap: () {
                                if (type == 0) {
                                  Get.find<BookingDetailController>()
                                      .lastOrderId
                                      .value = appointment['id'];
                                  Get.to(() =>
                                      DoctorJoinRoom(appointment: appointment));
                                }
                              },
                              child: Container(
                                width: 100,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Center(
                                    child: Text(
                                      "Join",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: LinearGradient(
                                        colors: [kPrimary, kSecondary])),
                              ),
                            )
                          : Container()
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
