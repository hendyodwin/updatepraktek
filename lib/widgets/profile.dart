import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/controller/profile_controller.dart';
import 'package:praktek_app/root.dart';
import 'package:praktek_app/screens/edit_profile.dart';
import 'package:praktek_app/screens/edit_profile_contact.dart';
import 'package:praktek_app/screens/new_praktek.dart';
import 'package:praktek_app/screens/praktek_edit_profile.dart';
import 'package:praktek_app/screens/praktek_education.dart';
import 'package:praktek_app/screens/praktek_price.dart';
import 'package:praktek_app/screens/praktek_schedule.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.height}) : super(key: key);
  final double height;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () {
                Get.find<AuthController>().updateUserStrapi();
                return controller.getUserInformation();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: widget.height + 20, left: 0, right: 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            CircleAvatar(
                              backgroundColor: kPrimary,
                              backgroundImage: Get.find<AuthController>()
                                          .profileImage
                                          .length >
                                      0
                                  ? CachedNetworkImageProvider(
                                      Get.find<AuthController>()
                                              .profileImage['formats']
                                          ['thumbnail']['url'])
                                  : null,
                            ),
                            Positioned(
                                bottom: -5,
                                right: -30,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    controller.uploadPP();
                                  },
                                  elevation: 2.0,
                                  fillColor: Color(0xFFF5F6F9),
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.blue,
                                    size: 16,
                                  ),
                                  padding: EdgeInsets.all(2.0),
                                  shape: CircleBorder(),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => Text(
                          Get.find<AuthController>().profileName.value,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Obx(
                        () => Text(
                          Get.find<AuthController>().profilePhone.value,
                          style: TextStyle(
                              color: kText,
                              fontWeight: FontWeight.normal,
                              fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => Get.find<AuthController>().profileIsDoctor.value
                            ? Get.find<AuthController>().doctorUI.value
                                ? InkWell(
                                    onTap: () {
                                      Get.find<AuthController>().uiSwitch();
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 21.0),
                                      child: Container(
                                        width: Get.width / 2,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: kSecondary,
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
                                              'Gunakan sebagai pasien',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kSecondary),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      Get.find<AuthController>().uiSwitch();
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 21.0),
                                      child: Container(
                                        width: Get.width / 2,
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
                                              'Gunakan sebagai dokter',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                            : Container(),
                      ),
                      Divider(),
                      InkWell(
                        onTap: () {
                          Get.to(() => EditProfile());
                        },
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Text(
                              'Informasi dasar',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: kText),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: kText,
                            size: 16,
                          ),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: () {
                          Get.to(() => EditProfileContact());
                        },
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Text(
                              'Kontak',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: kText),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: kText,
                            size: 16,
                          ),
                        ),
                      ),
                      Divider(),
                      // ListTile(
                      //   title: Padding(
                      //     padding: const EdgeInsets.only(top: 0.0),
                      //     child: Text(
                      //       'Settings',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.normal, fontSize: 14, color: kText),
                      //     ),
                      //   ),
                      //   trailing: Icon(
                      //     Icons.arrow_forward_ios,
                      //     color: kText,
                      //     size: 16,
                      //   ),
                      // ),
                      // Divider(),

                      Obx(
                        () => Get.find<AuthController>().profileIsDoctor.value
                            ? InkWell(
                                onTap: () {
                                  Get.to(() => PraktekEditProfile());
                                },
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 0.0),
                                    child: Text(
                                      'Profil dokter',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: kPrimary),
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    color: kPrimary,
                                    size: 16,
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  if (Get.find<AuthController>()
                                          .my_doctor_id
                                          .value ==
                                      0) {
                                    Get.to(() => NewPraktek());
                                  }
                                },
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 0.0),
                                    child: Text(
                                      Get.find<AuthController>()
                                                  .my_doctor_id
                                                  .value ==
                                              0
                                          ? 'Apakah Anda seorang dokter? Buka Praktekmu.'
                                          : 'Aplikasi diterima, kami akan segera meninjau.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: kPrimary),
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    color: kPrimary,
                                    size: 16,
                                  ),
                                ),
                              ),
                      ),
                      Obx(
                        () => Get.find<AuthController>().my_doctor_id.value != 0
                            ? Column(
                                children: [
                                  Divider(),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => PraktekPrice());
                                    },
                                    child: ListTile(
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: Text(
                                          'Tetapkan harga',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              color: kPrimary),
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: kPrimary,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ),
                      Obx(
                        () => Get.find<AuthController>().my_doctor_id.value != 0
                            ? Column(
                                children: [
                                  Divider(),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => PraktekSchedule());
                                    },
                                    child: ListTile(
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: Text(
                                          'Atur jadwal Anda',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              color: kPrimary),
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: kPrimary,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ),
                      Obx(
                        () => Get.find<AuthController>().my_doctor_id.value != 0
                            ? Column(
                                children: [
                                  Divider(),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => PraktekEducation());
                                    },
                                    child: ListTile(
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: Text(
                                          'Pendidikan',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              color: kPrimary),
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: kPrimary,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ),

                      Divider(),
                      InkWell(
                        onTap: () async {
                          final Uri _url =
                              Uri.parse('https://www.praktek.io/faq');
                          if (!await launchUrl(_url,
                              mode: LaunchMode.externalApplication))
                            throw 'Could not launch $_url';
                        },
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Text(
                              'FAQ',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: kText),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: kText,
                            size: 16,
                          ),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: () {
                          Get.find<AuthController>().signOut();
                          Get.offAll(() => Root());
                        },
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Text(
                              'Keluar',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: kText),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: kText,
                            size: 16,
                          ),
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 50,
                      ),
                      FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.done:
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    top: 8,
                                    bottom: 32),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'versi: ${snapshot.data!.version}',
                                      style:
                                          TextStyle(fontSize: 12, color: kText),
                                    ),
                                    Text(
                                      '#praktekyuk',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kSecondary),
                                    )
                                  ],
                                ),
                              );

                            default:
                              return const SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
