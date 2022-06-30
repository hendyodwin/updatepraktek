import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/screens/patient_list.dart';
import 'package:praktek_app/widgets/appointment_box.dart';
import 'package:praktek_app/widgets/doctor_box.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key, required this.height}) : super(key: key);
  final double height;
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final AuthController controller = Get.put(AuthController());
  bool _showAppointments = false;
  bool _showDoctors = false;

  void toggle() {
    print('toggle');
    setState(() {
      _showAppointments = !_showAppointments;
    });
  }

  Future<void> _refreshHomeDate() async {
    print('Refreshing....');
    controller.getMyDoctors();
    controller.getMyOrders();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshHomeDate,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: widget.height + 20, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.find<AuthController>().selectedIndex.value = 3;
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: kSecondary,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey.shade300)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Obx(
                              () => Get.find<AuthController>()
                                          .profileImage
                                          .length >
                                      0
                                  ? CachedNetworkImage(
                                      imageUrl: Get.find<AuthController>()
                                              .profileImage['formats']
                                          ['thumbnail']['url'],
                                      fit: BoxFit.cover,
                                      height: 150.0,
                                      width: 100.0,
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat datang',
                            style: TextStyle(fontSize: 11),
                          ),
                          Obx(
                            () => Text(
                              Get.find<AuthController>().profileName.value,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Image.asset(
                    'assets/images/praktek-logo.png',
                    width: 50,
                  )
                  // Icon(
                  //   Icons.notifications,
                  //   color: kText,
                  // ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Container(
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
                            print(
                                Get.find<AuthController>().mySearch.value.text);
                          },
                          child: Icon(
                            LineIcons.search,
                            color: kText,
                          ),
                        )),

                    onEditingComplete: () {
                      print(Get.find<AuthController>().mySearch.value.text);
                      Get.to(() => PatientList());
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
              SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _refreshHomeDate();
                  });
                },
                child: Text(
                  'Konsultasi Mendatang',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Obx(
                () => controller.my_orders_user_patient_video.length > 0
                    ? Column(
                        children: List<Widget>.generate(
                          controller.my_orders_user_patient_video.length,
                          (index) => AppointmentBox(
                            appointment: controller.my_orders_user_patient_video[index],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                            width: Get.width - 40,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300.withOpacity(0.9),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white,
                              ),
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 32,
                                ),
                                Image.asset(
                                    'assets/images/no-appointments.png'),
                                SizedBox(
                                  height: 32,
                                ),
                                Text(
                                  'Anda belum mempunyai jadwal konsultasi',
                                  style: TextStyle(color: kText),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => PatientList());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        (Radius.circular(20)),
                                      ),
                                      border: Border.all(
                                        color: kSecondary,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          top: 8.0,
                                          bottom: 8,
                                          right: 16),
                                      child: Text(
                                        'membuat janji',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: kSecondary),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                              ],
                            )),
                      ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'List Dokter Anda',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => PatientList());
                    },
                    child: Row(
                      children: const [
                        Text(
                          'Lihat semua',
                          style: TextStyle(
                              color: kPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: kPrimary,
                        )
                      ],
                    ),
                  )
                ],
              ),
              Obx(
                () => Get.find<AuthController>().my_doctors.length > 0
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List<Widget>.generate(
                            Get.find<AuthController>().my_doctors.length,
                            (index) => DoctorBox(
                                doctor: Get.find<AuthController>()
                                    .my_doctors[index]),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          width: Get.width - 40,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300.withOpacity(0.9),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset:
                                    Offset(0, 0), // changes position of shadow
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
                              SizedBox(
                                height: 32,
                              ),
                              Image.asset('assets/images/no-doctors.png'),
                              SizedBox(
                                height: 32,
                              ),
                              Text(
                                'Anda belum mempunyai list dokter',
                                style: TextStyle(color: kText),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => PatientList());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      (Radius.circular(20)),
                                    ),
                                    border: Border.all(
                                      color: kSecondary,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16,
                                        top: 8.0,
                                        bottom: 8,
                                        right: 16),
                                    child: Text(
                                      'Tambah dokter',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kSecondary),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 32,
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              SizedBox(
                height: 42,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
