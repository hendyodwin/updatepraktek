import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/edit_profile_controller.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.put(EditProfileController());
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
            'Informasi dasar',
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
                                        Text('Nama lengkap'),
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
                                              controller.fullNameController,
                                          decoration: InputDecoration(
                                              hintText:
                                                  'Masukkan nama lengkapmu',
                                              border: InputBorder.none),
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Silakan masukkan nama lengkap Anda';
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
                                        Text('Tempat Lahir'),
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
                                          controller: controller.PoBController,
                                          decoration: InputDecoration(
                                              hintText:
                                                  'Masukkan Tempat Lahir Anda',
                                              border: InputBorder.none),
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Silakan masukkan Tempat Lahir Anda';
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
                                        Text('Tanggal lahir'),
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
                                          controller: controller.dateBirthday,
                                          onTap: () async {
                                            DateTime? date = DateTime(1900);
                                            FocusScope.of(context)
                                                .requestFocus(new FocusNode());

                                            date = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2100));

                                            controller.dateBirthday.text =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(date!)
                                                    .toString();
                                            controller.dateToSave.value =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(date)
                                                    .toString();
                                          },
                                          decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                onPressed: () async {
                                                  DateTime? date =
                                                      DateTime(1900);
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          new FocusNode());

                                                  date = await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime(2100));

                                                  controller.dateBirthday.text =
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(date!)
                                                          .toString();
                                                  controller.dateToSave.value =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(date)
                                                          .toString();
                                                },
                                                icon: Icon(Icons
                                                    .calendar_today_rounded),
                                              ),
                                              hintText:
                                                  'Pilih tanggal lahir Anda',
                                              border: InputBorder.none),
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Silakan pilih tanggal lahir Anda';
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
                                        Text('Jenis kelamin'),
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
                                    Obx(
                                      () => Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                controller.isMale.value = true;
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        controller.isMale.value
                                                            ? kSecondary
                                                            : Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                  color: controller.isMale.value
                                                      ? kSecondary
                                                      : Colors.white,
                                                ),
                                                height: 45,
                                                child: Center(
                                                  child: Text(
                                                    'Pria',
                                                    style: TextStyle(
                                                        color: controller
                                                                .isMale.value
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                controller.isMale.value = false;
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        !controller.isMale.value
                                                            ? kSecondary
                                                            : Colors.grey,
                                                  ),
                                                  color:
                                                      !controller.isMale.value
                                                          ? kSecondary
                                                          : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                ),
                                                height: 45,
                                                child: Center(
                                                  child: Text(
                                                    'Wanita',
                                                    style: TextStyle(
                                                        color: !controller
                                                                .isMale.value
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: [
                                        Text('Nomor KTP'),
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
                                          keyboardType: TextInputType.number,
                                          maxLength: 16,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          controller:
                                              controller.KTPNumberController,

                                          decoration: InputDecoration(
                                              counterText: "",
                                              hintText:
                                                  'Masukkan Nomor KTP Anda',
                                              border: InputBorder.none),
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Silakan masukkan Nomor KTP Anda';
                                            }
                                            if (value.length < 16 ||
                                                value.isEmpty) {
                                              return 'Silahkan masukkan Nomor KTP (16 Digit)';
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
                                        Text('Alamat'),
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
                                              controller.AddressController,

                                          maxLines: 4,
                                          decoration: InputDecoration(
                                              hintText:
                                                  'Masukkan alamat lengkap Anda',
                                              border: InputBorder.none),
                                          // The validator receives the text that the user has entered.
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              height: 16,
                              thickness: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16, bottom: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      Text('Berat badan'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: Get.width * .7,
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
                                                controller.weightController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            decoration: InputDecoration(
                                                hintText:
                                                    'Masukkan berat badan Anda',
                                                border: InputBorder.none),
                                            // The validator receives the text that the user has entered.
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Kg',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      Text('Tinggi badan'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: Get.width * .7,
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
                                                controller.heightController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            decoration: InputDecoration(
                                                hintText:
                                                    'Masukkan tinggi badan Anda',
                                                border: InputBorder.none),
                                            // The validator receives the text that the user has entered.
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'cm',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
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
