import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:praktek_app/constants/api_details.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/helpers/debug.dart';
import 'package:praktek_app/models/user_model.dart';
import 'package:praktek_app/root.dart';
import 'package:praktek_app/screens/login_screen.dart';
import 'package:praktek_app/screens/new_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var now = DateTime.now();
  var formatter = DateFormat('M');

  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseMessaging _fcm = FirebaseMessaging.instance;

  String usersCollection = "users";

  Rxn<User> _firebaseUser = Rxn<User>();
  Rx<UserModel> userModel = UserModel().obs;
  UserModel tempUserModel = UserModel();
  RxString fcmToken = ''.obs;
  DocumentSnapshot? _userProfile;
  RxInt my_doctor_id = 0.obs;
  RxInt user_id_db = 0.obs;
  RxInt profile_id_db = 0.obs;
  RxInt selectedIndex = 0.obs;
  RxList user_doctors = [].obs;
  RxList user_doctors_ids = [].obs;
  RxList my_doctors = [].obs;
  RxList my_orders_user_patient = [].obs;
  RxList my_orders_user_patient_video = [].obs;

  RxList my_orders_user_patient_chat = [].obs;

  RxString profileName = ''.obs;
  RxString profileEmail = ''.obs;
  RxString profilePhone = ''.obs;
  RxBool profileIsDoctor = false.obs;
  RxBool profileIsDoctorApproved = false.obs;
  RxMap profileImage = {}.obs;
  RxMap profileImageDoctor = {}.obs;
  RxString profileNameDoctor = ''.obs;

  final myPhone = TextEditingController();
  final mySearch = TextEditingController();
  var myCode = TextEditingController();
  RxString loginOption = 'default'.obs;
  RxString phoneStatus = ''.obs;
  RxString actualCode = ''.obs;
  RxInt monthlySales = 0.obs;
  RxInt month1Sales = 0.obs;
  RxInt month2Sales = 0.obs;
  RxInt month3Sales = 0.obs;
  RxInt month4Sales = 0.obs;
  RxInt month5Sales = 0.obs;
  RxInt month6Sales = 0.obs;
  RxInt month7Sales = 0.obs;
  RxInt month8Sales = 0.obs;
  RxInt month9Sales = 0.obs;
  RxInt month10Sales = 0.obs;
  RxInt month11Sales = 0.obs;
  RxInt month12Sales = 0.obs;
  RxBool isDoctorUser = false.obs;
  RxString deliveryName = ''.obs;
  RxString deliveryAddress = ''.obs;
  RxDouble deliveryLat = 0.0.obs;
  RxDouble deliveryLng = 0.0.obs;

  RxInt notificationCounter = 0.obs;

  RxString defaultWarung = ''.obs;
  RxString defaultWarungName = ''.obs;
  RxBool showProfile = false.obs;
  RxBool doctorUI = false.obs;

  var theToken = '';
  String? get phone => _firebaseUser.value?.phoneNumber;
  String? get user => _firebaseUser.value?.uid;
  String get profilePicture =>
      (_userProfile?.data() as Map<String, dynamic>).containsKey('avatar')
          ? _userProfile!['avatar'] ?? ''
          : '';
  String? get name =>
      (_userProfile?.data() as Map<String, dynamic>).containsKey('name')
          ? _userProfile!['name'] ?? ''
          : '';
  late Rx<User?> firebaseUser;
  UserModel get theUser => userModel.value;

  @override
  void onInit() async {
    _firebaseUser.bindStream(_auth.authStateChanges());
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      debugPrint(
          'Auth has changed =====> ${_firebaseUser.value?.uid.toString()}');
      theToken = '';
      if (_firebaseUser.value != null) {
        getUserData(_firebaseUser.value?.uid.toString());
      }

      // do whatever you want based on the firebaseUser state
    });

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('doctorUI') != null) {
      doctorUI.value = prefs.getBool('doctorUI')!;
    }
    super.onInit();
  }

  void uiSwitch() async {
    final prefs = await SharedPreferences.getInstance();
    doctorUI.value = !doctorUI.value;
    await prefs.setBool('doctorUI', doctorUI.value);
  }

  thisMonthSales() {
    String month = formatter.format(now);

    return _userProfile![month.toString()];
  }

  theMonthSales(month) {
    return _userProfile![month.toString()] ?? 0;
  }

  Future<bool> loggedInCheck() async {
    if (_firebaseUser.value?.uid == null) {
      Get.offAll(Root());
      Get.to(() => const LoginScreen());
    }
    if (name == '') {
      Get.offAll(Root());
      // Get.to(() => TokitaProfileEdit());
    }

    return _firebaseUser.value?.uid == null ? false : true;
  }

  Future<void> updateUserStrapi() async {
    var token = await getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var urlCek = Uri.parse('${apiUrl}/api/me/doctors');

    var responseCek = await http.get(urlCek, headers: headers);

    var data = jsonDecode(responseCek.body);
    DebugTools().printWrapped('==== userStrapi ====>' + data.toString());
    if (data['doctor'] != null) {
      my_doctor_id.value = data['doctor']['id'] ?? 0;
    }
    if (data['doctors'] != null) {
      user_doctors.value = data['doctors'];
      user_doctors_ids.value = [];
      user_doctors.forEach((doctor) {
        user_doctors_ids.add(doctor['id']);
      });
    }

    user_doctors.value = data['doctors'];
    user_doctors_ids.value = [];
    user_doctors.forEach((doctor) {
      user_doctors_ids.add(doctor['id']);
    });
    var urlGetProfile = Uri.parse('${apiUrl}/api/me/profile');
    // var urlGetProfile = Constants.BASEURL;

    // var urlGetProfile = Uri.parse('$apiUrl/api/me/profile');

    //var urlGetProfile = Uri.parse('http://localhost:1338/api/me/profile');

    print('Profile data >>> ${urlGetProfile.toString()}');
    var responseProfile = await http.get(urlGetProfile, headers: headers);
    print('======> ${responseProfile.body.toString()} <======');
    try {
      var responseProfile = await http.get(urlGetProfile, headers: headers);
      print('======> ${jsonDecode(responseProfile.body).toString()} <======');
      var dataProfile = jsonDecode(responseProfile.body);
      DebugTools().printWrapped('== PROFILE ==> ${dataProfile.toString()}');

      if (dataProfile.length > 0) {
        profile_id_db.value = dataProfile['id'];
        profileName.value = dataProfile['name'];
        profileEmail.value = dataProfile['email'] ?? '';
        profileImage.value = dataProfile['profile_picture'];
        profileIsDoctor.value = dataProfile['is_doctor'] ?? false;
        profileIsDoctorApproved.value =
            dataProfile['is_doctor_approved'] ?? false;
      }
    } on Exception catch (e) {
      DebugTools().printWrapped(e.toString());
      Get.offAll(() => NewProfile());
      print('======> NOTHING THERE <======');
    }
    String? _fcmToken = await _fcm.getToken();
    debugPrint("FirebaseMessaging token: $_fcmToken");

    if (_fcmToken != fcmToken.value) {
      fcmToken.value = _fcmToken!;
      var dataUpdate = {
        "data": {"fcmToken": _fcmToken}
      };

      var urlUpdateProfile =
          Uri.parse('${apiUrl}/api/profiles/${profile_id_db.value}');

      try {
        debugPrint('Saving FCM Token.....');
        var responseUpdateProfile = await http.put(urlUpdateProfile,
            body: jsonEncode(dataUpdate), headers: headers);
        debugPrint(
            '======> ${jsonDecode(responseUpdateProfile.body).toString()} <======');
      } on Exception catch (e) {
        debugPrint('Saving FCM Token FAILED.....');
        debugPrint(e.toString());
        // TODO
      }

      if (my_doctor_id.value > 0) {
        var urlUpdateDoctor =
            Uri.parse('$apiUrl/api/doctors/${my_doctor_id.value}');

        try {
          debugPrint('Saving FCM Token Doctor.....');
          var responseUpdateDoctor = await http.put(urlUpdateDoctor,
              body: jsonEncode(dataUpdate), headers: headers);
          debugPrint(
              '======> ${jsonDecode(responseUpdateDoctor.body).toString()} <======');
        } on Exception catch (e) {
          debugPrint('Saving FCM Token Doctor FAILED.....');
          debugPrint(e.toString());
          // TODO
        }
      }
    }

    getMyDoctors();
  }

  void getMyDoctors() async {
    if (user_doctors_ids.length > 0) {
      var token = await Get.find<AuthController>().getToken();
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
      var query_str = '';
      int index = 0;
      user_doctors.toList().asMap().forEach((doctorIndex, doctor) {
        query_str += 'filters[id][\$in][${doctorIndex}]=${doctor['id']}&';
        index++;
        user_doctors_ids.add(doctor['id']);
      });

      var urlCek = Uri.parse('$apiUrl/api/doctors?${query_str}populate=*');
      // debugPrint('$apiUrl/api/doctors?${query_str}populate=*');
      var responseCek = await http.get(urlCek, headers: headers);

      var data = jsonDecode(responseCek.body)['data'];
      my_doctors.value = data;
      // debugPrint('------- GOT MY DOCTORS -------');
      // debugPrint(data.toString());
    } else {}
  }

  void getMyOrders() async {
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    var query_str = '';
    int index = 0;
    user_doctors.toList().asMap().forEach((doctorIndex, doctor) {
      query_str += 'filters[id][\$in][${doctorIndex}]=${doctor['id']}&';
      index++;
      user_doctors_ids.add(doctor['id']);
    });

    var urlCek = Uri.parse(
        '$apiUrl/api/appointments?filters[users_permissions_user][0]=${user_id_db}&filters[type][1]=chat&filters[paid][2]=1&sort[0]=createdAt&populate[0]=*&populate[1]=doctor.profile_picture&populate[2]=doctor.doctor_specialty&populate[3]=doctor_availability');
    var responseCek = await http.get(urlCek, headers: headers);
    var data = jsonDecode(responseCek.body)['data'];
    my_orders_user_patient_chat.value = data;
    urlCek = Uri.parse(
        '$apiUrl/api/appointments?filters[users_permissions_user][0]=${user_id_db}&filters[type][1]=video&filters[paid][2]=1&filters[doctor_availability][start][\$gt][3]=${DateTime.now().add(const Duration(minutes: -30)).toUtc()}&sort[0]=createdAt&populate[0]=*&populate[1]=doctor.profile_picture&populate[2]=doctor.doctor_specialty&populate[3]=doctor_availability');
    responseCek = await http.get(urlCek, headers: headers);
    data = jsonDecode(responseCek.body)['data'];
    my_orders_user_patient_video.value = data;
    urlCek = Uri.parse(
        '$apiUrl/api/appointments?filters[users_permissions_user][0]=${user_id_db}&filters[paid][1]=1&sort[0]=createdAt&populate[0]=*&populate[1]=doctor.profile_picture&populate[2]=doctor.doctor_specialty&populate[3]=doctor_availability');
    responseCek = await http.get(urlCek, headers: headers);

    data = jsonDecode(responseCek.body)['data'];
    my_orders_user_patient.value = data;
  }

  void getMyOrdersDoctor() async {
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    var query_str = '';
    int index = 0;

    var urlCek = Uri.parse(
        '$apiUrl/api/appointments?filters[users_permissions_user][0]=${user_id_db}&filters[type][1]=chat&filters[paid][2]=1&sort[0]=createdAt&populate[0]=*&populate[1]=doctor.profile_picture&populate[2]=doctor.doctor_specialty&populate[3]=doctor_availability');
    var responseCek = await http.get(urlCek, headers: headers);
    var data = jsonDecode(responseCek.body)['data'];
    my_orders_user_patient_chat.value = data;
    urlCek = Uri.parse(
        '$apiUrl/api/appointments?filters[users_permissions_user][0]=${user_id_db}&filters[type][1]=video&filters[paid][2]=1&filters[doctor_availability][start][\$gt][3]=${DateTime.now().toUtc()}&sort[0]=createdAt&populate[0]=*&populate[1]=doctor.profile_picture&populate[2]=doctor.doctor_specialty&populate[3]=doctor_availability');
    responseCek = await http.get(urlCek, headers: headers);
    data = jsonDecode(responseCek.body)['data'];
    my_orders_user_patient_video.value = data;
    urlCek = Uri.parse(
        '$apiUrl/api/appointments?filters[users_permissions_user][0]=${user_id_db}&filters[paid][1]=1&sort[0]=createdAt&populate[0]=*&populate[1]=doctor.profile_picture&populate[2]=doctor.doctor_specialty&populate[3]=doctor_availability');
    responseCek = await http.get(urlCek, headers: headers);

    data = jsonDecode(responseCek.body)['data'];
    my_orders_user_patient.value = data;
  }

  Future<void> getUserData(user) async {
    print('----??');
    _userProfile =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    print('USER PROFILE ===> ${_userProfile.toString()}');
    showProfile.value = true;
    notificationCounter.value = (_userProfile?.data() as Map<String, dynamic>)
            .containsKey('notifications')
        ? _userProfile!['notifications'] ?? 0
        : 0;

    await updateUserStrapi();
    getMyDoctors();
    getMyOrders();
  }

  Future<User?> googleSignIn() async {
    // loading.value = true;
    print('loading');
    GoogleSignInAccount? googleUser =
        await _googleSignIn.signIn().catchError((onError) => print(onError));

    if (googleUser == null) {
      // loading.value = false;
      return null;
    }
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    User user = (await _auth.signInWithCredential(credential)).user!;
    print("GETX - signed in " + user.displayName!);
    print(user.providerData);
    print(user.providerData[0].email);

    await FirebaseAnalytics().logLogin(loginMethod: 'Google');
    updateUserData(user);
    await getUserData(user.uid);
    _saveDeviceToken(user.uid);

    // loading.value = false
    return user;
  }

  Future<http.Response> fetchToken() async {
    var url = Uri.parse('$apiUrl/auth/local');

    var response = await http.post(url,
        body: {"identifier": "praktek_app", "password": "SWq5rWS6gkwDiGF"});
    debugPrint(response.body);
    return response;
  }

  Future<String> getToken() async {
    print('Is there a token? => ${theToken}');
    // theToken == '';
    if (theToken == '') {

      var token = await FirebaseAuth.instance.currentUser!.getIdToken();
      print(token);

      var urlAuth = Uri.parse('$apiUrl/api/firebase/auth');

      print('$apiUrl/api/firebase/auth');
      print('Token ==> ${token}');

      var responseCekAuth = await http.post(urlAuth, body: {"token": token});
      var dataAuth = jsonDecode(responseCekAuth.body);
      print('====== Before Token =======');
      DebugTools().printWrapped(dataAuth.toString());
      profilePhone.value = dataAuth['user']['username'];
      theToken = dataAuth['jwt'];
      user_id_db.value = dataAuth['user']['id'];

      getMyDoctors();
      return dataAuth['jwt'];
    } else {
      debugPrint('===> CACHED TOKEN');
      return theToken;
    }
  }

  Future<User?> phoneSignInCode() async {
    var code = myCode.text.trim();
    debugPrint(code);

    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: actualCode.value, smsCode: code);

      await _auth.signInWithCredential(credential).then((value) async {
        if (value.user != null) {
          User user = value.user!;
          updateUserData(user);
          _saveDeviceToken(user.uid);
          await getUserData(user.uid);
          // var response = await fetchToken();
          // final parsed = jsonDecode(response.body);
          //
          // debugPrint(parsed.toString());
          // debugPrint('TOKEN RECEIVED: ${parsed['jwt']}');
          // Map<String, String> headers = {
          //   'Content-Type': 'application/json',
          //   'Accept': 'application/json',
          //   'Authorization': 'Bearer ${parsed['jwt']}'
          // };
          //
          // var url_cek = Uri.parse(
          //     'https://admin.cashenable.com/clients?client_id=${Get.find<AuthController>().user}');
          //
          // var response_cek = await http.get(url_cek, headers: headers);
          //
          // if (response_cek.body.toString() == '[]') {
          //   Get.to(NewUser(token: parsed['jwt']));
          // } else {
          //   Get.find<UserProfileController>()
          //       .getUserData(Get.find<AuthController>().user);
          //   myPhone.clear();
          //   myCode.clear();
          //   Get.offAll(Root());
          // }
          myPhone.clear();
          myCode.clear();
          Get.offAll(Root());
          //Get.to(Home());
          //onAuthenticationSuccessful();
        } else {
          phoneStatus.value = 'Invalid code/invalid authentication';
          Get.snackbar('Phone Login Error', phoneStatus.value,
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
              backgroundColor: kPrimary);
        }
      }).catchError((error) {
        phoneStatus.value = 'Invalid code/invalid authentication';
        Get.snackbar('Your OTP failed', phoneStatus.value,
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: kPrimary);
      });
    } catch (e) {
      print(e);
      if (e.toString().contains('firebase_auth/invalid-verification-code')) {
        Get.snackbar('Phone Login Error',
            'The sms verification code that was used is invalid. Please check your code and try again.',
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: kPrimary);
      }
      print(e);
    }

    return null;
  }

  Future<User?> phoneSignIn() async {
    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      Get.find<AuthController>().loginOption.value = 'code';
      actualCode.value = verificationId;
      phoneStatus.value = "Enter the code sent to 0" + myPhone.text;
      Get.snackbar('Phone Login', phoneStatus.toString(),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: kPrimary);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      Get.find<AuthController>().loginOption.value = 'phone';
      actualCode.value = verificationId;
      phoneStatus.value = ("Auto retrieval time out, please try again");
      // Get.snackbar('Phone Login', phoneStatus.toString(),
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: kPrimary);
    };
    final PhoneVerificationFailed verificationFailed = (exception) {
      phoneStatus.value = '${exception.message}';

      print("Error message: " + phoneStatus.toString());
      if (exception.message!.contains('not authorized'))
        phoneStatus.value = 'Something has gone wrong, please try later';
      else if (exception.message!.contains('Network'))
        phoneStatus.value =
            'Please check your internet connection and try again';
      else if (exception.message!.contains('Invalid format.'))
        phoneStatus.value =
            'Please check if you entered a valid phone number and try again.';
      else
        phoneStatus.value = 'Something has gone wrong, please try later.';

      Get.snackbar('Phone Login', phoneStatus.toString(),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: kPrimary);
    };

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential auth) {
      phoneStatus.value = 'Auto retrieving verification code';
      debugPrint('step 1');

      //_authCredential = auth;
      _auth.signInWithCredential(auth).then((value) async {
        debugPrint("YOOOOO");
        if (value.user != null) {
          User user = value.user!;
          updateUserData(user);
          myPhone.clear();
          myCode.clear();
          Get.offAll(Root());
          await getUserData(user.uid);
          _saveDeviceToken(user.uid);
          FirebaseAnalytics().logLogin(loginMethod: 'Phone');
          // Get.find<UserProfileController>()
          //     .getUserData(Get.find<AuthController>().user);

          // _saveDeviceToken(user.uid);
          phoneStatus.value = 'Authentication successful';
          Get.snackbar('Phone Login', phoneStatus.toString(),
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
              backgroundColor: kPrimary);

          print('step 2');

          return value;
          //onAuthenticationSuccessful();
        } else {
          phoneStatus.value = 'Invalid code/invalid authentication';
        }
      }).catchError((error) {
        phoneStatus.value = 'Something has gone wrong, please try later.';
      });
      debugPrint('step 3 : ' + phoneStatus.string);
      Get.snackbar('Phone Login', phoneStatus.toString(),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: kPrimary);
    };

    var phoneNumber = myPhone.text;
    phoneNumber = '+62' + int.parse(phoneNumber).toString();
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential auth) async {
          phoneStatus.value = 'Auto retrieving verification code';
          debugPrint('step 1');
          //_authCredential = auth;
          await _auth.signInWithCredential(auth).then((value) async {
            if (value.user != null) {
              User user = value.user!;
              updateUserData(user);
              Get.offAll(Root());

              await getUserData(user.uid);
              // TODO: Save token if notification service is added.
              _saveDeviceToken(user.uid);

              //onAuthenticationSuccessful();
            } else {
              phoneStatus.value = 'Invalid code/invalid authentication';
            }
          }).catchError((error) {
            phoneStatus.value = 'Something has gone wrong, please try later.';
          });
          debugPrint('step 3 : ' + phoneStatus.string);
          // if (phoneStatus.toString() == 'Authentication successful') {
          //   Get.offAll(Root());
          // }
          Get.snackbar('Phone Login', phoneStatus.toString(),
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
              backgroundColor: kPrimary);
        },
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<void> updateUserData(User user) async {
    await FirebaseAnalytics().setUserId(user.uid);

    DocumentReference ref = _db.collection('users').doc(user.uid);

    var userUpdate = {
      'uid': user.uid,
      'refferedBy': '',
      'photoURL': user.photoURL ?? '',
      'lastSeen': DateTime.now(),
    };

    if (user.email != null) {
      userUpdate['email'] = user.email.toString();
    } else {
      if (user.providerData[0].email != null) {
        userUpdate['email'] = user.providerData[0].email.toString();
      }
    }
    if (user.phoneNumber != null) {
      userUpdate['phoneNumber'] = user.phoneNumber.toString();
    }
    if (user.displayName != null) {
      userUpdate['displayName'] = user.displayName.toString();
    }
    return ref.set(userUpdate, SetOptions(merge: true));
  }

  void _saveDeviceToken(user) async {
    String uid = user;
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String? fcmToken = await _fcm.getToken();
    if (GetPlatform.isAndroid) {
      _fcm.subscribeToTopic('AndroidUser');
    }
    if (GetPlatform.isIOS) {
      _fcm.subscribeToTopic('iOSUser');
    }

    // Save it to Firestore
    if (!GetPlatform.isWeb) {
      if (fcmToken != null) {
        print(fcmToken);
        var tokens =
            _db.collection('users').doc(uid).collection('tokens').doc(fcmToken);

        await tokens.set({
          'token': fcmToken,
          'createdAt': FieldValue.serverTimestamp(), // optional
          'platform': Platform.operatingSystem // optional
        });
      }
    } else {
      if (fcmToken != null) {
        var tokens =
            _db.collection('users').doc(uid).collection('tokens').doc(fcmToken);

        await tokens.set({
          'token': fcmToken,
          'createdAt': FieldValue.serverTimestamp(), // optional
          'platform': 'web' // optional
        });
      }
    }
  }

  void signOut() async {
    try {
      //TODO: Remove messaging tokens from Firestore and FCM
      await FirebaseAnalytics().setUserId(null);
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      doctorUI.value = false;
      fcmToken.value = '';
      await prefs.setBool('doctorUI', doctorUI.value);
      // await Get.find<UserProfileController>().resetUser();
      myPhone.clear();
      myCode.clear();
      Get.to(Root());
      _userProfile = null;
    } catch (e) {
      //e.message
      Get.snackbar("Error signing out", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
