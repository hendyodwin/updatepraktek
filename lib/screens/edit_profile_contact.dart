import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/edit_profile_contact_controller.dart';

class EditProfileContact extends StatelessWidget {
  const EditProfileContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditProfileContactController controller =
        Get.put(EditProfileContactController());
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
            'Kontak',
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
                                        Text('Nomor telepon'),
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
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8),
                                        child: TextFormField(
                                          controller:
                                              controller.phoneController,
                                          decoration: InputDecoration(
                                              enabled: false,
                                              hintText:
                                                  'Masukkan nomor telepon Anda',
                                              border: InputBorder.none),
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Masukkan nomor telepon anda';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: [
                                        Text('Alamat email'),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Obx(
                                          () => Text(
                                            controller.emailValidated.value
                                                ? 'diverifikasi'
                                                : 'tidak diverifikasi',
                                            style: TextStyle(
                                                color: Colors.redAccent),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8),
                                        child: TextFormField(
                                          controller:
                                              controller.emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textCapitalization:
                                              TextCapitalization.none,
                                          decoration: InputDecoration(
                                              hintText:
                                                  'Masukkan alamat email Anda',
                                              border: InputBorder.none),
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                !value.isEmail) {
                                              return 'Silakan masukkan alamat email Anda';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
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
                              Get.snackbar('Update Successful',
                                  'We have saved your profile',
                                  backgroundColor: Colors.greenAccent,
                                  snackPosition: SnackPosition.BOTTOM);
                              controller.saveUserInformation();
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
