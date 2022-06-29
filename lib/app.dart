import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praktek_app/controller/auth_binding.dart';
import 'package:praktek_app/root.dart';

import 'flavors.dart';

class App extends StatelessWidget {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialBinding: AuthBinding(),
          title: 'Praktek',
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFF487CCA),
            primaryColorLight: const Color(0xFF487CCA),
            primaryColorDark: const Color(0xFF487CCA),
            backgroundColor: const Color(0xffFCFCFD),
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color(0xFF487CCA),
              secondary: const Color(0xff28C1E1),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF487CCA),
            primaryColorLight: const Color(0xFF487CCA),
            primaryColorDark: const Color(0xFF487CCA),
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          localizationsDelegates: [
            FormBuilderLocalizations.delegate,
          ],
          enableLog: true,
          defaultTransition: Transition.noTransition,
          opaqueRoute: Get.isOpaqueRouteDefault,
          popGesture: Get.isPopGestureEnable,
          transitionDuration: Get.defaultDialogTransitionDuration,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          home: Root(),
        );
      },
    );
  }

  Widget _flavorBanner({
    required Widget child,
    bool show = true,
  }) =>
      show
          ? Banner(
              child: child,
              location: BannerLocation.topStart,
              message: F.name,
              color: Colors.green.withOpacity(0.6),
              textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                  letterSpacing: 1.0),
              textDirection: TextDirection.ltr,
            )
          : Container(
              child: child,
            );
}
