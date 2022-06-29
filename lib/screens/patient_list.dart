import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/controller/listing_controller.dart';
import 'package:praktek_app/controller/main_controller.dart';
import 'package:praktek_app/widgets/doctor_box_listing.dart';

class PatientList extends StatelessWidget {
  const PatientList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainController controllerMain = Get.put(MainController());

    controllerMain.trackEventMixPanel('doctor_listing');

    final _formKey = GlobalKey<FormBuilderState>();
    final ListingController controller = Get.put(ListingController());
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 8.0,
            shadowColor: Colors.grey.shade100,
            title: Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: kText,
                      ),
                    ),
                  ),
                  Container(
                    width: Get.width - 70,
                    height: 40,
                    decoration: BoxDecoration(
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.shade300.withOpacity(0.9),
                      //     spreadRadius: 3,
                      //     blurRadius: 10,
                      //     offset: Offset(0, 0), // changes position of shadow
                      //   ),
                      // ],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: FormBuilder(
                      key: _formKey,
                      child: FormBuilderTextField(
                        controller: Get.find<AuthController>().mySearch,
                        name: 'search',
                        style: TextStyle(
                            fontSize: 14.0, height: 2.0, color: Colors.black),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 12.0, right: 8.0),
                            hintText: Get.find<AuthController>()
                                        .defaultWarungName
                                        .value !=
                                    ''
                                ? 'Cari di ${Get.find<AuthController>().defaultWarungName.value}...'
                                : 'Cari dokter anda',
                            border: InputBorder.none,
                            prefixIcon: InkWell(
                              onTap: () {
                                print(Get.find<AuthController>()
                                    .mySearch
                                    .value
                                    .text);
                              },
                              child: Icon(
                                LineIcons.search,
                                color: kText,
                              ),
                            )),

                        onEditingComplete: () {
                          print(Get.find<AuthController>().mySearch.value.text);
                          controller.getDoctors();
                        },
                        onChanged: (value) {
                          print(value);
                        },
                        // validator: FormBuilderValidators.compose([
                        //   FormBuilderValidators.required(context),
                        // ]),
                      ),
                    ),
                  ),
                  // TODO: Add filtering based on specialty
                  // InkWell(
                  //     onTap: () {
                  //       print('filter');
                  //     },
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(2.0),
                  //       child: Image.asset(
                  //         'assets/images/filter_icon.png',
                  //         height: 40,
                  //         width: 40,
                  //       ),
                  //     ),),
                  // Your widgets here
                ],
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 1,
          ),
        ),
        body: Obx(() => controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Column(children: [
                      SizedBox(
                        height: 16,
                      ),
                      ...controller.doctorList.value.map((product) {
                        return DoctorBoxListing(
                          doctor: product,
                        );
                      }).toList(),
                    ]),
                  ),
                ),
              )));
  }
}
