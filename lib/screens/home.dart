import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/controller/main_controller.dart';
import 'package:praktek_app/controller/messages_list_controller.dart';
import 'package:praktek_app/screens/login.dart';
import 'package:praktek_app/screens/on_boarding_screen.dart';
import 'package:praktek_app/widgets/doctor_history.dart';
import 'package:praktek_app/widgets/doctor_messages.dart';
import 'package:praktek_app/widgets/history.dart';
import 'package:praktek_app/widgets/homepage.dart';
import 'package:praktek_app/widgets/homepage_doctor.dart';
import 'package:praktek_app/widgets/messages.dart';
import 'package:praktek_app/widgets/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MessagesListController controller = Get.put(MessagesListController());
  final MainController _mainController = Get.put(MainController());
  final _mainLazy = Get.lazyPut(() => MainController());

  var _selectedIndex = 0;
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    debugPrint(_seen.toString());
    if (!_seen) {
      await prefs.setBool('seen', true);
      Get.offAll(OnBoardingScreen());
    } else {
      // await prefs.setBool('seen', false);
      if (Get.find<AuthController>().user == null) {
        Get.to(() => Login());
      }
      ;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkFirstSeen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    var height = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
            child: Obx(
              () => GNav(
                rippleColor: Color(0x4f0C77BD),
                hoverColor: Color(0x1f0C77BD),
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                color: Get.find<AuthController>().doctorUI.value
                    ? kSecondary
                    : Colors.grey[800],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundGradient: Get.find<AuthController>().doctorUI.value
                    ? LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          kSecondary,
                          kSecondary,
                        ],
                        stops: [
                          0.0,
                          1.0,
                        ],
                      )
                    : LinearGradient(
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
                tabs: [
                  GButton(
                    icon: LineIcons.home,
                    text: 'Beranda',
                  ),
                  GButton(
                    icon: LineIcons.fileInvoice,
                    text: 'Riwayat',
                  ),
                  GButton(
                    icon: LineIcons.sms,
                    text: 'Chat',
                  ),
                  GButton(
                    icon: LineIcons.userCircle,
                    text: 'Profil',
                  ),
                ],
                selectedIndex: Get.find<AuthController>().selectedIndex.value,
                onTabChange: (index) {
                  if (index == 0) {
                    Get.find<AuthController>().getMyOrders();
                  }
                  if (index == 2) {
                    Get.find<MessagesListController>().getChatList();
                  }
                  Get.find<AuthController>().selectedIndex.value = index;
                },
              ),
            ),
          ),
        ),
      ),
      body: Obx(
        () => Get.find<AuthController>().selectedIndex.value == 0
            ? Get.find<AuthController>().doctorUI.value
                ? HomepageDoctor(
                    height: height,
                  )
                : Homepage(
                    height: height,
                  )
            : Get.find<AuthController>().selectedIndex.value == 1
                ? Get.find<AuthController>().doctorUI.value
                    ? DoctorHistory()
                    : History()
                : Get.find<AuthController>().selectedIndex.value == 2
                    ? Get.find<AuthController>().doctorUI.value
                        ? DoctorMessages()
                        : Messages()
                    : Get.find<AuthController>().selectedIndex.value == 3
                        ? Profile(
                            height: height,
                          )
                        : Container(),
      ),
    );
  }
}

// ? TokitaHistory()
//     : _selectedIndex == 2
// ? TokitaFavorites()
//     : _selectedIndex == 3
// ? TokitaProfile()
//     :
