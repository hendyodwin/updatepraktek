import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/screens/phone_code.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    Get.lazyPut(() => AuthController());
    super.initState();
  }

  final Uri _url = Uri.parse('https://www.praktek.io/tnc');

  void _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication))
      throw 'Could not launch $_url';
  }

  void _onChanged(dynamic val) => debugPrint(val);
  var genderOptions = ['Male', 'Female', 'Other'];
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    // this below line is used to make notification bar transparent
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
          children: <Widget>[
            // Image.asset(
            //   //TODO update background image according to your brand
            //   'assets/images/background.jpeg',
            //   fit: BoxFit.cover,
            //   height: double.infinity,
            //   width: double.infinity,
            // ),
            Container(
              decoration: BoxDecoration(color: Colors.white
                  // gradient: LinearGradient(
                  //     begin: Alignment.bottomCenter,
                  //     end: Alignment.topCenter,
                  //     colors: [
                  //       Colors.black.withOpacity(.9),
                  //       Colors.black.withOpacity(.1),
                  //     ]),
                  ),
            ),
            Builder(builder: (BuildContext context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset(
                    'assets/icon/icon.png',
                    width: Get.width / 3,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Selamat datang',
                    style: TextStyle(
                      fontSize: 27.0,
                      color: kText,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16),
                    child: Text(
                      //TODO update this
                      'Masuk dengan nomor handphone dulu biar bisa cari praktek dokter anda.',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: kText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 48.0, right: 48.0),
                    child: Column(
                      children: <Widget>[
                        FormBuilder(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            children: <Widget>[
                              FormBuilderPhoneField(
                                name: 'phone_number',
                                defaultSelectedCountryIsoCode: 'ID',
                                isSearchable: false,
                                controller: Get.find<AuthController>().myPhone,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: 8.0, bottom: 8.0, left: 8.0),
                                  hintStyle: TextStyle(color: kText),
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintText: '8123456789',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: const BorderSide(
                                        color: kPrimary, width: 0.0),
                                  ),
                                ),
                                priorityListByIsoCode: ['ID'],
                                countryFilterByIsoCode: ['SG'],
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context,
                                      errorText:
                                          'Harus masukin nomor telpon anda.'),
                                  FormBuilderValidators.maxLength(context, 14,
                                      errorText:
                                          'Harus masukin nomor telpon yg benar.'),
                                ]),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              FormBuilderCheckbox(
                                name: 'accept_terms',
                                activeColor: kPrimary,
                                checkColor: Colors.white,
                                initialValue: false,
                                onChanged: _onChanged,
                                title: InkWell(
                                  onTap: () {
                                    _launchUrl();
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'I have read and agree to the ',
                                          style: TextStyle(color: kText),
                                        ),
                                        TextSpan(
                                          text: 'Terms and Conditions',
                                          style: TextStyle(color: kPrimary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                validator: FormBuilderValidators.equal(
                                  context,
                                  true,
                                  errorText:
                                      'You must accept terms and conditions to continue',
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                //Get.find<AuthController>().googleSignIn();
                                if (_formKey.currentState?.saveAndValidate() ??
                                    false) {
                                  debugPrint(
                                      _formKey.currentState?.value.toString());
                                  Get.find<AuthController>().phoneSignIn();
                                  Get.to(() => PhoneCode());
                                } else {
                                  debugPrint(
                                      _formKey.currentState?.value.toString());
                                  debugPrint('validation failed');
                                }
                              },
                              child: Container(
                                width: Get.width - 48 - 48,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Center(
                                    child: Text(
                                      "Masuk dgn nomor handphone",
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
                        )
                      ],
                    ),
                  )
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
