import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/controller/praktek_home_controller.dart';
import 'package:praktek_app/screens/patient_list.dart';
import 'package:praktek_app/widgets/appointment_box.dart';
import 'package:praktek_app/widgets/appointment_box_doctor.dart';
import 'package:praktek_app/widgets/doctor_box.dart';

class HomepageDoctor extends StatefulWidget {
  const HomepageDoctor({Key? key, required this.height}) : super(key: key);
  final double height;

  @override
  _HomepageDoctorState createState() => _HomepageDoctorState();
}

class _HomepageDoctorState extends State<HomepageDoctor> {
  final _formKey = GlobalKey<FormBuilderState>();
  final AuthController controller = Get.put(AuthController());
  final PraktekHomeController controllerHome = Get.put(PraktekHomeController());
  bool _showAppointments = false;
  bool _showDoctors = false;

  void toggle() {
    print('toggle');
    setState(() {
      _showAppointments = !_showAppointments;
    });
  }

  Future<String> _refreshHomeDate() async {
    print('Refreshing....');
    controller.getMyDoctors();
    controllerHome.getMyOrders();
    return 'Done';
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshHomeDate,
      child: GestureDetector(
        onHorizontalDragDown: (_) {
          _refreshHomeDate();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.only(top: widget.height + 20, left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
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
                                border:
                                    Border.all(color: Colors.grey.shade300)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Obx(
                                () => controllerHome.doctorInfo.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: controllerHome.doctorInfo[
                                                        'attributes']
                                                    ['profile_picture']['data']
                                                ['attributes']['formats']
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
                              'Welcome',
                              style: TextStyle(fontSize: 11),
                            ),
                            Obx(
                              () => Text(
                                controllerHome.profileName.value,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Image.asset('assets/images/praktek-logo.png', width: 50,)
                    // Icon(
                    //   Icons.notifications,
                    //   color: kText,
                    // ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _refreshHomeDate();
                    });
                  },
                  child: Text(
                    'Upcoming Appointments',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Obx(
                  () => controllerHome.my_orders_user_patient_video.length > 0
                      ? Column(
                          children: List<Widget>.generate(
                            controllerHome.my_orders_user_patient_video.length,
                            (index) => AppointmentBoxDoctor(
                              appointment: controllerHome
                                  .my_orders_user_patient_video[index],
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
                                    color:
                                        Colors.grey.shade300.withOpacity(0.9),
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
                                    onTap: () {},
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
                                          'Share your profile',
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
                  height: 42,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
