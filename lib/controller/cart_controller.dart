import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/models/cart_item_model.dart';
import 'package:praktek_app/models/product_model.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  var now = new DateTime.now();
  var formatter = new DateFormat('M');
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var _products = {}.obs;
  var _totalAmount = 0.0.obs;
  var _cart = {}.obs;
  RxInt _steps = 0.obs;

  final customerCompany = TextEditingController();
  final customerName = TextEditingController();
  final customerAddress = TextEditingController();
  final customerEmail = TextEditingController();
  final customerPhone = TextEditingController();
  final customerNPWP = TextEditingController();
  final validFrom = TextEditingController();
  final validTo = TextEditingController();
  final discountPercentage = TextEditingController();
  final discountNominal = TextEditingController();

  get step => _steps.value;

  void addStep() {
    _steps.value += 1;
  }

  void removeStep() {
    if (_steps.value > 0) {
      _steps.value -= 1;
    }
  }

  void resetStep() {
    _steps.value = 0;
  }

  void addProduct(ProductModel product) async {
    // Choose from any of these available methods
    // enum FeedbackType {
    // success,
    // error,
    // warning,
    // selection,
    // impact,
    // heavy,
    // medium,
    // light
    // }

    var _type = FeedbackType.light;
    Vibrate.feedback(_type);
    if (_cart.containsKey(product.id)) {
      _cart[product.id] += 1;
    } else {
      _cart[product.id] = 1;
      Get.snackbar(
          'Produk di tambah', 'Anda berhasil bertambah produk baru ke cart.',
          backgroundColor: kPrimary,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    }
    await FirebaseAnalytics().logAddToCart(
        itemId: product.id.toString(),
        itemName: product.name.toString(),
        itemCategory: '',
        quantity: _cart[product.id]);
    // if (_products.containsKey(product)) {
    //   _products[product] += 1;
    // } else {
    //   _products[product] = 1;
    // }
    _totalAmount.value += product.price!.toDouble();
    debugPrint(_products.value.toString());
    debugPrint(_cart.value.toString());
  }

  get products => _products;
  void vibrateProduct() {
    var _type = FeedbackType.light;
    Vibrate.feedback(_type);
  }

  void removeProduct(ProductModel product) async {
    var _type = FeedbackType.light;
    Vibrate.feedback(_type);
    if (_cart.containsKey(product.id) && _cart[product.id] == 1) {
      _cart.removeWhere((key, value) => key == product.id);
      _totalAmount.value -= product.price!.toDouble();
    } else {
      _cart[product.id] -= 1;
      _totalAmount.value -= product.price!.toDouble();
    }
    await FirebaseAnalytics().logRemoveFromCart(
        itemId: product.id.toString(),
        itemName: product.name.toString(),
        itemCategory: '',
        quantity: 1);
    // if (_products.containsKey(product) && _products[product] == 1) {
    //   _products.removeWhere((key, value) => key == product);
    // } else {
    //   _products[product] -= 1;
    // }
    debugPrint('TOTAL ==> ${_totalAmount}');
  }

  void saveQuote() async {
    print('Okay saving this...');
    var token = await Get.find<AuthController>().getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    var urlCek = Uri.parse(
        'https://admin.cashenable.com/clients?client_id=${Get.find<AuthController>().user}');

    var responseCek = await http.get(urlCek, headers: headers);
    final userInfo = jsonDecode(responseCek.body);

    var itemList = [];
    for (int i = 0; i < _products.length; i++) {
      var theItem = CartItemModel(
          productId: _products.keys.toList()[i].id,
          name: _products.keys.toList()[i].name,
          quantity: _products.values.toList()[i],
          price: _products.keys.toList()[i].price,
          cost: _products.keys.toList()[i].price);

      itemList.add(theItem.toJson());
    }
    var dataPackage = {
      "quote_uid": Uuid().v1(),
      "client": userInfo[0]['id'],
      "client_name": userInfo[0]['company_name'],
      "customer_name": customerName.value.text,
      "client_address": userInfo[0]['client_address'],
      "customer_address": customerAddress.value.text,
      "client_npwp": userInfo[0]['client_npwp'],
      "customer_npwp": customerNPWP.value.text,
      "client_top": userInfo[0]['client_top_days'],
      "customer_top": userInfo[0]['client_top_days'],
      "quote_item_details": itemList,
      "total_before_tax": total,
      "total_tax_vat": 0,
      "total": total,
      "discount": 0,
      "total_tax_service": 0,
      "customer_company_name": customerCompany.value.text,
      "customer_phone": customerPhone.value.text,
      "customer_email": customerEmail.value.text,
      "is_invoice": false,
      "is_paid": false,
    };
    print(dataPackage);
    var url_post = Uri.parse('https://admin.cashenable.com/quotes');
    var response_post = await http.post(url_post,
        headers: headers, body: jsonEncode(dataPackage));
    final invoiceDetail = jsonDecode(response_post.body);
    debugPrint(invoiceDetail['id'].toString());
    Map<String, String> headersAWS = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': 'qH6wXGVXAh4R3TDr3hDjkaOkqgoNHkRB74b47uyw'
    };
    var url_email = Uri.parse(
        'https://qugvr2v420.execute-api.ap-southeast-1.amazonaws.com/dev/pdf/create?id=${invoiceDetail['id'].toString()}&email=1');
    var response_email = await http.get(url_email, headers: headersAWS);
    resetStep();
    Get.snackbar("Quote sent",
        "We have sent your quote to ${customerName.value.text} via email ${customerEmail.value.text}.",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: kPrimary);
  }

  void saveInvoice() async {
    print('Okay saving this...');
    var token = await Get.find<AuthController>().getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    var urlCek = Uri.parse(
        'https://admin.cashenable.com/clients?client_id=${Get.find<AuthController>().user}');

    var responseCek = await http.get(urlCek, headers: headers);
    final userInfo = jsonDecode(responseCek.body);
    var itemList = [];
    for (int i = 0; i < _products.length; i++) {
      var theItem = CartItemModel(
          productId: _products.keys.toList()[i].id,
          name: _products.keys.toList()[i].name,
          quantity: _products.values.toList()[i],
          price: _products.keys.toList()[i].price,
          cost: _products.keys.toList()[i].price);

      itemList.add(theItem.toJson());
    }
    var dataPackage = {
      "quote_uid": Uuid().v1(),
      "client": userInfo[0]['id'],
      "client_name": userInfo[0]['company_name'],
      "customer_name": customerName.value.text,
      "client_address": userInfo[0]['client_address'],
      "customer_address": customerAddress.value.text,
      "client_npwp": userInfo[0]['client_npwp'],
      "customer_npwp": customerNPWP.value.text,
      "client_top": userInfo[0]['client_top_days'],
      "customer_top": userInfo[0]['client_top_days'],
      "quote_item_details": itemList,
      "total_before_tax": total,
      "total_tax_vat": 0,
      "total": total,
      "discount": 0,
      "total_tax_service": 0,
      "customer_company_name": customerCompany.value.text,
      "customer_phone": customerPhone.value.text,
      "customer_email": customerEmail.value.text,
      "is_invoice": true,
      "is_paid": false,
    };
    print(dataPackage);
    var url_post = Uri.parse('https://admin.cashenable.com/quotes');
    var response_post = await http.post(url_post,
        headers: headers, body: jsonEncode(dataPackage));
    final invoiceDetail = jsonDecode(response_post.body);
    debugPrint(invoiceDetail['id'].toString());
    Map<String, String> headersAWS = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': 'qH6wXGVXAh4R3TDr3hDjkaOkqgoNHkRB74b47uyw'
    };
    var url_email = Uri.parse(
        'https://qugvr2v420.execute-api.ap-southeast-1.amazonaws.com/dev/pdf/create?id=${invoiceDetail['id'].toString()}&email=1');
    var response_email = await http.get(url_email, headers: headersAWS);

    var userRef = _db.collection('users').doc(Get.find<AuthController>().user);
    String month = formatter.format(now);
    userRef
        .update({month.toString(): FieldValue.increment(double.parse(total))});

    resetStep();
    Get.snackbar("Invoice sent",
        "We have sent your invoice to ${customerName.value.text} via email ${customerEmail.value.text}.",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: kPrimary);
  }

  get cartList => _cart;
  get totalAmount => _totalAmount;
  get totalProducts => _cart.length > 0
      ? _cart.entries
          .map((product) => product.value)
          .toList()
          .reduce((value, element) => value + element)
          .toStringAsFixed(0)
      : '0';
  get productSubtotal => _products.entries
      .map((product) => product.key.price * product.value)
      .toList();

  get total => _products.length > 0
      ? _products.entries
          .map((product) => product.key.price * product.value)
          .toList()
          .reduce((value, element) => value + element)
          .toStringAsFixed(0)
      : 0;
}
