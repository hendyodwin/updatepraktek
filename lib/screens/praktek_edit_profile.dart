import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/praktek_edit_profile.dart';

class PraktekEditProfile extends StatelessWidget {
  const PraktekEditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PraktekEditProfileController controller =
        Get.put(PraktekEditProfileController());
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
            'Dokter Profile',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16, top: 16, bottom: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Form(
                          key: controller.formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    fit: StackFit.expand,
                                    children: [
                                      Obx(
                                        () => CircleAvatar(
                                          backgroundColor: kPrimary,
                                          backgroundImage: controller
                                                      .doctorInfo.length >
                                                  0
                                              ? CachedNetworkImageProvider(
                                                  controller.doctorInfo[
                                                                  'attributes'][
                                                              'profile_picture']
                                                          ['data']['attributes']
                                                      [
                                                      'formats']['thumbnail']['url'])
                                              : null,
                                        ),
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
                                Row(
                                  children: [
                                    Text('Your professional name'),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      '*',
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: Get.width,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: Get.width - 32,
                                        child: TextFormField(
                                          controller: controller.nameController,
                                          keyboardType: TextInputType.name,

                                          decoration: InputDecoration(
                                            hintText: 'Your name...',
                                            contentPadding:
                                                const EdgeInsets.all(8.0),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'How do your patients call you?';
                                            }
                                            return null;
                                          },
                                          // The validator receives the text that the user has entered.
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    Text('Introduce yourself to your patients'),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      '*',
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: Get.width,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: Get.width - 32,
                                        child: TextFormField(
                                          controller:
                                              controller.aboutController,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 7,
                                          decoration: InputDecoration(
                                            hintText: 'Short introduction...',
                                            contentPadding:
                                                const EdgeInsets.all(8.0),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please tell us something about yourself';
                                            }
                                            return null;
                                          },
                                          // The validator receives the text that the user has entered.
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: Get.width,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                            onTap: () async {
                              if (controller.formKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.

                                await controller.saveUserInformation();
                                Get.back(result: 'true');
                                Get.snackbar('Update Successful',
                                    'We have saved your profile.',
                                    backgroundColor: Colors.greenAccent,
                                    snackPosition: SnackPosition.BOTTOM);
                                // controller.saveUserInformation();
                              } else {
                                print('ERROR');
                              }
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24)),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16,
                                      top: 12,
                                      bottom: 12),
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }
}
