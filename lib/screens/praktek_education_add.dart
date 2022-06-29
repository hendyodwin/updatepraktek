import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/praktek_education_edit.dart';
import 'package:timelines/timelines.dart';

class PraktekEducationAdd extends StatelessWidget {
  const PraktekEducationAdd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PraktekEducationEditController controller =
        Get.put(PraktekEducationEditController());
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
            'Tambahkan Pendidikan',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: Obx(
          () => controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Form(
                      key: controller.formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Nama'),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          '*',
                                          style: TextStyle(
                                              color: Colors.redAccent),
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
                                                  controller.nameController,
                                              keyboardType: TextInputType.name,

                                              decoration: InputDecoration(
                                                hintText:
                                                    'Di mana kamu belajar?',
                                                contentPadding:
                                                    const EdgeInsets.all(8.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Tolong beri tahu kami di mana Anda belajar';
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
                                        Text('Tahun'),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          '*',
                                          style: TextStyle(
                                              color: Colors.redAccent),
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
                                                  controller.yearController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9]')),
                                              ],
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Tahun Anda menyelesaikan pendidikan Anda',
                                                contentPadding:
                                                    const EdgeInsets.all(8.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Tolong beri tahu kami tahun';
                                                }
                                                return null;
                                              },
                                              // The validator receives the text that the user has entered.
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    Container(
                      width: Get.width,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: () {
                            if (controller.formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.

                              controller.saveEducationInformation();
                              Get.back();
                              Get.snackbar('Update Successful',
                                  'We have saved your studies.',
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
                                    left: 16.0, right: 16, top: 12, bottom: 12),
                                child: Text(
                                  'Simpan',
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
        ));
  }
}
