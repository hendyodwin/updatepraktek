import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:praktek_app/controller/auth_controller.dart';

class UserProfileController extends GetxController {
  RxInt clientId = 0.obs;
  RxString clientName = ''.obs;
  RxString clientPhone = ''.obs;
  RxString companyName = ''.obs;
  RxString companyNPWP = ''.obs;
  RxString companyNPWPString = ''.obs;
  RxString companyAddress = ''.obs;
  RxString clientEmail = ''.obs;
  RxInt clientTOP = 7.obs;
  RxInt clientCreditLimit = 0.obs;
  RxBool companyPKP = false.obs;
  RxString articlesList = ''.obs;
  RxString bannerList = ''.obs;
  RxString categoriesList = ''.obs;
  RxString terlarisList = ''.obs;

  RxString quoteList = ''.obs;
  RxString invoiceList = ''.obs;
  RxString paidList = ''.obs;

  RxBool initLoadingArticles = true.obs;
  RxBool initLoadingCategories = true.obs;
  RxBool initLoadingPromos = true.obs;
  RxBool notificationSwitch = true.obs;
  RxBool profileLoading = false.obs;
  RxString yourLocation = 'Belum dpt lokasi, klik untuk refresh'.obs;
  RxString Address = 'search'.obs;
  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  get clientTOPValue => clientTOP.value;
  get getClientName => clientName.value;

  Future<String> getArticles() async {
    if (initLoadingArticles.value) {
      var token = await Get.find<AuthController>().getToken();
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
      var urlCek =
          Uri.parse('https://admin.tokita.co.id/api/banners?populate=*');

      var responseCek = await http.get(urlCek, headers: headers);
      print('data received Banner ==> ${responseCek.body}');
      bannerList.value = responseCek.body;
      initLoadingArticles.value = false;
    }

    return 'Ok';
  }

  Future<String> getCategories() async {
    if (initLoadingCategories.value) {
      var token = await Get.find<AuthController>().getToken();
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
      var urlCek = Uri.parse(
          'https://admin.tokita.co.id/api/departments?populate[categories][populate]=*');

      var responseCek = await http.get(urlCek, headers: headers);
      print('data received Categories ==> ${responseCek.body}');
      categoriesList.value = responseCek.body;
      initLoadingCategories.value = false;
    }

    return 'Ok';
  }

  Future<String> getPromos() async {
    if (initLoadingPromos.value) {
      var token = await Get.find<AuthController>().getToken();
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
      var urlCek = Uri.parse('https://admin.tokita.co.id/api/products');

      var responseCek = await http.get(urlCek, headers: headers);
      print('data received Products ==> ${responseCek.body}');
      terlarisList.value = responseCek.body;
      initLoadingPromos.value = false;
    }

    return 'Ok';
  }

  // Future<String> getUserData(userid) async {
  //   var token = await Get.find<AuthController>().getToken();
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer ${token}'
  //   };
  //   var urlCek =
  //       Uri.parse('https://admin.cashenable.com/clients?client_id=${userid}');
  //
  //   var responseCek = await http.get(urlCek, headers: headers);
  //   print('data received ==> ${responseCek.body}');
  //   if (responseCek.body == '[]') {
  //     //TODO: NEW USER CREATION
  //     // Get.to(NewUser(token: token.toString()));
  //   }
  //   // Get.find<UserProfileController>().getInvoiceList(token);
  //   // Get.find<UserProfileController>().getQuoteList(token);
  //   // Get.find<UserProfileController>().getPaidList(token);
  //   Get.find<AuthController>().getUserData(Get.find<AuthController>().user);
  //
  //   final userInfo = jsonDecode(responseCek.body);
  //   clientId.value = userInfo[0]['id'];
  //   clientName.value = userInfo[0]['client_name'];
  //   clientPhone.value = userInfo[0]['client_phone'];
  //   companyName.value = userInfo[0]['company_name'];
  //   companyNPWPString.value = userInfo[0]['client_npwp'];
  //   companyPKP.value = userInfo[0]['client_pkp'];
  //   companyNPWP.value =
  //       '${userInfo[0]['client_npwp']} ${userInfo[0]['client_pkp'] == true ? '(PKP)' : '(Non PKP)'}';
  //   companyAddress.value = userInfo[0]['client_address'];
  //   clientEmail.value = userInfo[0]['client_email'];
  //   clientTOP.value = userInfo[0]['client_top_days'];
  //   clientCreditLimit.value = userInfo[0]['client_credit_limit'] ?? 0;
  //   quoteList.value = '';
  //   invoiceList.value = '';
  //   paidList.value = '';
  //
  //   return token;
  // }

  //Reset
  Future<void> resetUser() async {
    clientId.value = 0;
    clientName.value = '';
    clientPhone.value = '';
    companyName.value = '';
    companyNPWPString.value = '';
    companyPKP.value = false;
    companyNPWP.value = '';
    companyAddress.value = '';
    clientEmail.value = '';
    clientTOP.value = 0;
    clientCreditLimit.value = 0;
    quoteList.value = '';
    invoiceList.value = '';
    paidList.value = '';
  }

  //Invoice & Quotes

  Future<void> getInvoiceList(token) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    var urlCek = Uri.parse(
        'https://admin.cashenable.com/quotes?client_contains=${Get.find<UserProfileController>().clientId.value}&is_invoice=1&is_paid=0');

    var responseCek = await http.get(urlCek, headers: headers);
    print('data received ==> ${responseCek.body}');
    invoiceList.value = responseCek.body;
  }

  Future<void> getQuoteList(token) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    var urlCek = Uri.parse(
        'https://admin.cashenable.com/quotes?client_contains=${Get.find<UserProfileController>().clientId.value}&is_invoice=0');

    var responseCek = await http.get(urlCek, headers: headers);
    print('data received ==> ${responseCek.body}');
    quoteList.value = responseCek.body;
  }

  Future<void> getPaidList(token) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    var urlCek = Uri.parse(
        'https://admin.cashenable.com/quotes?client_contains=${Get.find<UserProfileController>().clientId.value}&is_invoice=1&is_paid=1');

    var responseCek = await http.get(urlCek, headers: headers);
    print('data received ==> ${responseCek.body}');
    paidList.value = responseCek.body;
  }

  @override
  void onInit() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    yourLocation.value = await getAddressFromLocation(
        _locationData.latitude ?? 0, _locationData.longitude ?? 0);
    super.onInit();
  }

  get theLocationData => _locationData;

  void refreshLocation() async {
    debugPrint('Refreshing location .... ');
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    yourLocation.value = await getAddressFromLocation(
        _locationData.latitude ?? 0, _locationData.longitude ?? 0);
  }

  Future<String> getAddressFromLocation(double lat, double lng) async {
    List<geo.Placemark> placemarks =
        await geo.placemarkFromCoordinates(lat, lng);
    var theStreet = placemarks.first.street;
    return theStreet.toString();
  }
}
