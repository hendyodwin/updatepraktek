import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/auth_controller.dart';

class PhoneCode extends StatefulWidget {
  const PhoneCode({Key? key}) : super(key: key);

  @override
  _PhoneCodeState createState() => _PhoneCodeState();
}

class _PhoneCodeState extends State<PhoneCode> {
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  void _onChanged(dynamic val) => debugPrint(val);
  var genderOptions = ['Male', 'Female', 'Other'];
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();
  bool _genderHasError = false;
  TextEditingController textEditingController = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          'Verifikasi kode OTP',
          style: TextStyle(
              fontWeight: FontWeight.normal, color: kText, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: kText,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 100),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Masukkan Kode OTP yang dikirim ke nomor 0${authController.myPhone.text}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Form(
                            key: formKey,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 30),
                                child: PinCodeTextField(
                                  controller: Get.find<AuthController>().myCode,
                                  appContext: context,
                                  pastedTextStyle: TextStyle(
                                    color: Colors.green.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  length: 6,
                                  autoDisposeControllers: false,
                                  obscureText: true,
                                  obscuringCharacter: '*',
                                  animationType: AnimationType.fade,
                                  validator: (v) {
                                    if (v!.length < 3) {
                                      return "Please fill in your OTP";
                                    } else {
                                      return null;
                                    }
                                  },
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(5),
                                    fieldHeight: 60,
                                    fieldWidth: (Get.width * .7) / 6,
                                    selectedColor: Colors.white,
                                    selectedFillColor: kPrimary,
                                    inactiveFillColor: Colors.white,
                                    inactiveColor: kPrimary,
                                    activeColor:
                                        hasError ? Colors.redAccent : kPrimary,
                                    activeFillColor:
                                        hasError ? Colors.redAccent : kPrimary,
                                  ),
                                  cursorColor: Colors.black,
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  textStyle:
                                      TextStyle(fontSize: 20, height: 1.6),
                                  enableActiveFill: true,
                                  errorAnimationController: errorController,
                                  keyboardType: TextInputType.number,
                                  boxShadows: [
                                    BoxShadow(
                                      offset: Offset(0, 1),
                                      color: Colors.black12,
                                      blurRadius: 10,
                                    )
                                  ],
                                  onCompleted: (v) {
                                    print("Completed");
                                  },
                                  // onTap: () {
                                  //   print("Pressed");
                                  // },
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      currentText = value;
                                    });
                                  },
                                  beforeTextPaste: (text) {
                                    print("Allowing to paste $text");
                                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                    return true;
                                  },
                                )),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Get.find<AuthController>().phoneSignInCode();
                                },
                                child: Container(
                                  width: Get.width - 32,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Center(
                                      child: Text(
                                        "Verify",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      gradient: LinearGradient(
                                          colors: [kPrimary, kSecondary])),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
