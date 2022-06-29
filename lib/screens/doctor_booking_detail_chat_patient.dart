import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/controller/booking_detail_controller.dart';
import 'package:praktek_app/controller/main_controller.dart';
import 'package:praktek_app/screens/doctor_booking_payment_method_patient.dart';
import 'package:praktek_app/widgets/add_photo_box.dart';
import 'package:video_player/video_player.dart';

class DoctorBookingDetailChatPatient extends StatelessWidget {
  const DoctorBookingDetailChatPatient({Key? key, required this.doctor})
      : super(key: key);
  final int doctor;
  @override
  Widget build(BuildContext context) {
    Get.find<MainController>().trackEventMixPanel('booking_chat');

    final BookingDetailController controller =
        Get.put(BookingDetailController());
    controller.doctorId.value = this.doctor;
    controller.bookingType.value = 'chat';
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    final ImagePicker _picker = ImagePicker();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
            'Booking Details',
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
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: kSecondary,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.5),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: controller.doctor.length > 0
                                            ? Image.network(
                                                controller.doctor['attributes']
                                                                    ['profile_picture']['data']
                                                                ['attributes']['formats']
                                                            ['medium'] ==
                                                        null
                                                    ? controller.doctor['attributes']
                                                                ['profile_picture']['data']
                                                            ['attributes']['formats']
                                                        ['thumbnail']['url']
                                                    : controller.doctor['attributes']
                                                                ['profile_picture']
                                                            ['data']['attributes']
                                                        ['formats']['medium']['url'],
                                                fit: BoxFit.cover,
                                                height: 120.0,
                                              )
                                            : null,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.doctor.length > 0
                                            ? controller.doctor['attributes']
                                                    ['full_name'] ??
                                                '-'
                                            : '-',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        controller.doctor.length > 0
                                            ? controller.doctor['attributes']
                                                    ['doctor_specialty']['data']
                                                ['attributes']['name']
                                            : '-',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: kSecondary),
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
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16, top: 8, bottom: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nama pasien:',
                                    style:
                                        TextStyle(color: kText, fontSize: 12),
                                  ),
                                  Obx(
                                    () => Text(Get.find<AuthController>()
                                        .profileName
                                        .value),
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
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    'Upload Video',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          controller.video.value =
                                              await _picker.pickVideo(
                                                  source: ImageSource.camera);
                                          controller.videoReady.value = false;
                                          controller.controllerVideo =
                                              VideoPlayerController.file(File(
                                                  controller.video.value!.path))
                                                ..initialize().then((_) {
                                                  controller.videoReady.value =
                                                      true;
                                                  // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                                });
                                        },
                                        child: controller.video.value == null
                                            ? AddPhotoBox()
                                            : Obx(
                                                () => InkWell(
                                                    onLongPress: () {
                                                      controller.video.value =
                                                          null;
                                                    },
                                                    child:
                                                        controller.videoReady
                                                                .value
                                                            ? Column(
                                                                children: [
                                                                  Container(
                                                                    width: 100,
                                                                    height: 150,
                                                                    child:
                                                                        AspectRatio(
                                                                      aspectRatio: controller
                                                                          .controllerVideo
                                                                          .value
                                                                          .aspectRatio,
                                                                      child: VideoPlayer(
                                                                          controller
                                                                              .controllerVideo),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      controller
                                                                              .controllerVideo
                                                                              .value
                                                                              .isPlaying
                                                                          ? controller
                                                                              .controllerVideo
                                                                              .pause()
                                                                          : controller
                                                                              .controllerVideo
                                                                              .play();
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child: controller
                                                                              .controllerVideo
                                                                              .value
                                                                              .isPlaying
                                                                          ? Icon(
                                                                              Icons.pause_circle_filled_rounded,
                                                                              size: 30,
                                                                            )
                                                                          : Icon(
                                                                              Icons.play_circle_fill_rounded,
                                                                              size: 30),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container()),
                                              ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Pesan anda',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '*',
                                        style:
                                            TextStyle(color: Colors.redAccent),
                                      ),
                                    ],
                                  ),
                                  Scrollbar(
                                    controller: controller.scrollController,
                                    isAlwaysShown: true,
                                    child: TextField(
                                      minLines: 5,
                                      scrollController:
                                          controller.scrollController,
                                      controller: controller.editTextController,
                                      autofocus: false,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      autocorrect: true,
                                      onChanged: (s) => {},
                                      decoration: InputDecoration(
                                        hintText:
                                            'Describe here your questions to the doctor...',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2.0),
                                        ),
                                        isDense: true,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          decoration: new BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 10,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 7), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(24.0),
                                topRight: const Radius.circular(24.0),
                              )),
                          width: Get.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    new Expanded(
                                      flex: 5,
                                      child: InkWell(
                                        onTap: () {},
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Total Price:',
                                              style: TextStyle(color: kText2),
                                            ),
                                            Text(
                                              controller.doctor.length > 0
                                                  ? 'Rp. ${currencyFormatter.format(controller.doctor['attributes']['rate_chat'])}'
                                                  : '-',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: InkWell(
                                        onTap: () {
                                          if (controller.editTextController.text
                                                  .length >
                                              0) {
                                            Get.to(() =>
                                                DoctorBookingPaymentMethodPatient());
                                          } else {
                                            Get.snackbar(
                                                'Anda belum isi pesan buat dokter',
                                                'Anda belum isi pesan buat dokter biar dia bisa membantu anda.',
                                                backgroundColor:
                                                    Colors.redAccent,
                                                colorText: Colors.white);
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // border: Border.all(
                                            //   color: kSecondary,
                                            // ),
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(24)),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16,
                                                  top: 12,
                                                  bottom: 12),
                                              child: Text(
                                                'Next',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
        ),
      ),
    );
  }
}
