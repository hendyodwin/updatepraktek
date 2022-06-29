import 'package:flutter/material.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:intl/intl.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/screens/phone_code.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    Get.lazyPut(() => AuthController());
    super.initState();
  }

  void _onChanged(dynamic val) => debugPrint(val);
  var genderOptions = ['Male', 'Female', 'Other'];
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();
  bool _genderHasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          'Sign In',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
          child: Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                color: Colors.white,
                // gradient: LinearGradient(
                //     begin: Alignment.topCenter,
                //     end: Alignment.bottomRight,
                //     colors: [Color(0xff002F4E), Color(0xff0C77BD)]),
              ),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                        child: Text(
                          'Untuk mengunakan functionalitas ini Anda harus login dulu. Anda cuma perlu nomor handphone yang aktif untuk lanjut.\n\nKami akan mengirimkan kode OTP ke nomor handphone Anda.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // InkWell(
                      //     onTap: () {
                      //       Get.to(PhoneCode());
                      //     },
                      //     child: Image.asset(
                      //       'assets/images/tokita.png',
                      //       width: Get.width / 2,
                      //     )),
                      // const SizedBox(
                      //   height: 64,
                      // ),
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
                                    controller:
                                        Get.find<AuthController>().myPhone,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          top: 8.0, bottom: 8.0, left: 8.0),
                                      labelText: 'Phone Number',
                                      hintStyle:
                                          TextStyle(color: Colors.black12),
                                      labelStyle: TextStyle(color: kPrimary),
                                      hintText: '8123456789',
                                      border: OutlineInputBorder(),
                                      enabledBorder: const OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderSide: const BorderSide(
                                            color: kPrimary, width: 0.0),
                                      ),
                                    ),
                                    priorityListByIsoCode: ['ID'],
                                    countryFilterByIsoCode: ['SG'],
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(context),
                                    ]),
                                  ),
                                  FormBuilderCheckbox(
                                    name: 'accept_terms',
                                    initialValue: false,
                                    onChanged: _onChanged,
                                    title: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                'I have read and agree to the ',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: 'Terms and Conditions',
                                            style: TextStyle(color: kPrimary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    validator: FormBuilderValidators.equal(
                                      context,
                                      true,
                                      errorText:
                                          'You must accept terms and conditions to continue',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: MaterialButton(
                                    color: kPrimary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        "Continue with Phone Number",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState
                                              ?.saveAndValidate() ??
                                          false) {
                                        debugPrint(_formKey.currentState?.value
                                            .toString());
                                        Get.find<AuthController>()
                                            .phoneSignIn();
                                        Get.to(() => PhoneCode());
                                      } else {
                                        debugPrint(_formKey.currentState?.value
                                            .toString());
                                        debugPrint('validation failed');
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ))),
    );
  }
}
