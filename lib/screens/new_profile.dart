import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/controller/new_profile_controller.dart';

class NewProfile extends StatelessWidget {
  const NewProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NewProfileController controller = Get.put(NewProfileController());
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.grey.withOpacity(0.2),
          elevation: 4,
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: null,
          title: Text(
            'We would like to know you',
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
                                        InkWell(
                                          onTap: () {
                                            Get.find<AuthController>()
                                                .selectedIndex
                                                .value = 3;
                                          },
                                          child: Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                                color: kSecondary,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade300)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Obx(
                                                () => controller.profileImage
                                                            .value.length >
                                                        0
                                                    ? Image.file(
                                                        controller
                                                            .profileImageFile
                                                            .value,
                                                        fit: BoxFit.cover,
                                                        height: 150.0,
                                                        width: 100.0,
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .camera_alt_outlined,
                                                        color: Colors.white,
                                                        size: 40,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Gunakan head shot foto dengan \nmaksimum size 320x320 px',
                                              style: TextStyle(fontSize: 11),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                controller.uploadPP();
                                                debugPrint('Upload photo...');
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: kSecondary,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                  color: Colors.white,
                                                ),
                                                height: 35,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      'Upload Profile',
                                                      style: TextStyle(
                                                          color: kSecondary,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: [
                                        Text('Full name'),
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
                                              hintText: 'Enter your full name',
                                              border: InputBorder.none),
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your full name';
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
                                        Text('Place of Birth'),
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
                                                  'Enter your Place of Birth',
                                              border: InputBorder.none),
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your Place of Birth';
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
                                        Text('Date of Birth'),
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
                                              hintText: 'Select your Birthday',
                                              border: InputBorder.none),
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select your birthday';
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
                                        Text('Gender'),
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
                                                    'Male',
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
                                                    'Female',
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
                                        Text('KTP Number'),
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
                                              hintText: 'Enter your KTP Number',
                                              border: InputBorder.none),
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your KTP Number';
                                            }
                                            if (value.length < 16 ||
                                                value.isEmpty) {
                                              return 'Please enter your KTP Number (16 Digits)';
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
                                        Text('Address'),
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
                                                  'Enter your full address',
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
                                      Text('Weigth'),
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
                                                hintText: 'Enter your weight',
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
                                      Text('Height'),
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
                                                hintText: 'Enter your height',
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
                              if (controller.profileImage.value.length > 0) {
                                Get.snackbar('Update Successful',
                                    'We have saved your profile',
                                    backgroundColor: Colors.greenAccent,
                                    snackPosition: SnackPosition.BOTTOM);
                                controller.saveUserInformation();
                              } else {
                                Get.snackbar('Please Upload A Profile Picture',
                                    'Because we believe in a personal connection please upload your profile picture to continue.',
                                    backgroundColor: Colors.redAccent,
                                    snackPosition: SnackPosition.TOP,
                                    colorText: Colors.white);
                              }
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
        ));
  }
}
