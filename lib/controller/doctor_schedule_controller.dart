import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:praktek_app/constants/api_details.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:praktek_app/helpers/debug.dart';

class DoctorScheduleController extends GetxController {
  RxInt doctorId = 0.obs;
  RxMap doctor = {}.obs;
  RxBool isLoading = false.obs;
  RxString currentMonth = ''.obs;
  RxString currentMonthInt = ''.obs;
  RxString currentYear = ''.obs;

  RxString selectedMonth = ''.obs;
  RxString selectedMonthInt = ''.obs;
  RxString selectedYear = ''.obs;

  RxInt selectedDay = 1.obs;
  RxString selectedDate = ''.obs;
  RxInt today = 1.obs;
  RxInt lastDay = 31.obs;

  RxList scheduleMorning = [].obs;
  RxList scheduleAfternoon = [].obs;
  RxList scheduleEvening = [].obs;

  RxInt selectedSlot = 0.obs;

  @override
  void onInit() {
    super.onInit();
    var now = new DateTime.now();
    currentMonth.value = DateFormat('MMMM').format(now).toString();
    currentMonthInt.value = DateFormat('MM').format(now);
    currentYear.value = DateFormat('yyyy').format(now).toString();
    selectedMonth.value = currentMonth.value;
    selectedMonthInt.value = currentMonthInt.value;
    selectedYear.value = currentYear.value;
    today.value = int.parse(DateFormat('dd').format(now).toString());
    selectedDay.value = int.parse(DateFormat('dd').format(now).toString());
    selectedDate.value = currentYear.value +
        '-' +
        currentMonthInt.value +
        '-' +
        DateFormat('dd').format(now).toString();
    DateTime lastDayOfMonth = new DateTime(now.year, now.month + 1, 0);
    lastDay.value = lastDayOfMonth.day;
    print('${today.value} --- ${lastDay.value}');
    ever(doctorId, (value) {
      print('DoctorId = $doctorId');
      getDoctor(doctorId);
    });
  }

  void changeSelectedDate(day) {
    debugPrint('====== $day ======');
    selectedDay.value = day;
    selectedSlot.value = 0;
    getDoctorSchedule(doctorId.value);
  }

  void nexMonth() {
    NumberFormat formatter = new NumberFormat("00");
    selectedDay.value = 1;
    if (selectedMonthInt.value == '12') {
      selectedYear.value = (int.parse(selectedYear.value) + 1).toString();
    }
    debugPrint('====== ${currentMonth.value} - ${selectedMonth.value} ======');
    selectedMonthInt.value = selectedMonthInt.value == 12
        ? formatter.format(1).toString()
        : formatter.format(int.parse(selectedMonthInt.value) + 1).toString();
    selectedMonth.value = DateFormat('MMMM')
        .format(DateTime(
                int.parse(currentYear.value),
                int.parse(selectedMonthInt.value),
                int.parse(1.toString()),
                7,
                0,
                0,
                0,
                0)
            .toUtc())
        .toString();
    selectedSlot.value = 0;
    today.value = 1;
    getDoctorSchedule(doctorId.value);
  }

  void previousMonth() {
    NumberFormat formatter = new NumberFormat("00");
    selectedDay.value = 1;
    if (selectedMonthInt.value == '1') {
      selectedYear.value = (int.parse(selectedYear.value) - 1).toString();
    }
    debugPrint('====== ${currentMonth.value} - ${selectedMonth.value} ======');
    selectedMonthInt.value = selectedMonthInt.value == 1
        ? formatter.format(12).toString()
        : formatter.format(int.parse(selectedMonthInt.value) - 1).toString();
    selectedMonth.value = DateFormat('MMMM')
        .format(DateTime(
                int.parse(currentYear.value),
                int.parse(selectedMonthInt.value),
                int.parse(1.toString()),
                7,
                0,
                0,
                0,
                0)
            .toUtc())
        .toString();
    selectedSlot.value = 0;
    if (selectedMonth.value == currentMonth.value &&
        currentYear.value == selectedYear.value) {
      var now = new DateTime.now();
      today.value = int.parse(DateFormat('dd').format(now).toString());
    } else {
      today.value = 1;
    }

    getDoctorSchedule(doctorId.value);
  }

  void changedSelectedSlot(slot) {
    debugPrint('====== $slot ======');
    selectedSlot.value = slot;
  }

  void getDoctor(id) async {
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var urlCek = Uri.parse('$apiUrl/api/doctors/$id?populate=*');

    var responseCek = await http.get(urlCek, headers: headers);

    var data = jsonDecode(responseCek.body)['data'];
    doctor.value = data;
    isLoading.value = false;
    debugPrint('-------');
    DebugTools().printWrapped(data.toString());
    getDoctorSchedule(id);
  }

  void getDoctorSchedule(id) async {
    // isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    NumberFormat formatter = new NumberFormat("00");
    final moonLanding = DateTime.utc(1969, 7, 20, 20, 18, 04);
    var currentDateTime = DateTime.now().toUtc();
    var startMorning = DateTime(
            int.parse(currentYear.value),
            int.parse(selectedMonthInt.value),
            int.parse(selectedDay.value.toString()),
            7,
            0,
            0,
            0,
            0)
        .toUtc();
    var endMorning = DateTime(
            int.parse(currentYear.value),
            int.parse(selectedMonthInt.value),
            int.parse(selectedDay.value.toString()),
            12,
            0,
            0,
            0,
            0)
        .toUtc();
    var startAfternoon = DateTime(
            int.parse(currentYear.value),
            int.parse(selectedMonthInt.value),
            int.parse(selectedDay.value.toString()),
            12,
            0,
            0,
            0,
            0)
        .toUtc();
    var endAfternoon = DateTime(
            int.parse(currentYear.value),
            int.parse(selectedMonthInt.value),
            int.parse(selectedDay.value.toString()),
            18,
            0,
            0,
            0,
            0)
        .toUtc();
    var startEvening = DateTime(
            int.parse(currentYear.value),
            int.parse(selectedMonthInt.value),
            int.parse(selectedDay.value.toString()),
            18,
            0,
            0,
            0,
            0)
        .toUtc();
    var endEvening = DateTime(
            int.parse(currentYear.value),
            int.parse(selectedMonthInt.value),
            int.parse(selectedDay.value.toString()),
            24,
            0,
            0,
            0,
            0)
        .toUtc();

    print(startMorning);
    print(endMorning);
    var minTimeMorning = currentDateTime.compareTo(startMorning) > 0
        ? currentDateTime
        : startMorning;
    var minTimeAfternoon = currentDateTime.compareTo(startAfternoon) > 0
        ? currentDateTime
        : startAfternoon;
    var minTimeEvening = currentDateTime.compareTo(startEvening) > 0
        ? currentDateTime
        : startEvening;
    var urlCekMorning = Uri.parse(
        '$apiUrl/api/doctor-availabilities?filters[doctor][id][\$eq]=${id}&sort=start&filters[start][\$gte]=${DateFormat("yyyy-MM-ddTHH:mm:ss").format(minTimeMorning)}&filters[start][\$lt]=${DateFormat("yyyy-MM-ddTHH:mm:ss").format(endMorning)}');
    var responseCekMorning = await http.get(urlCekMorning, headers: headers);
    var dataMorning = jsonDecode(responseCekMorning.body)['data'];
    scheduleMorning.value = dataMorning;
    var urlCekAfternoon = Uri.parse(
        '$apiUrl/api/doctor-availabilities?filters[doctor][id][\$eq]=${id}&sort=start&filters[start][\$gte]=${DateFormat("yyyy-MM-ddTHH:mm:ss").format(minTimeAfternoon)}&filters[start][\$lt]=${DateFormat("yyyy-MM-ddTHH:mm:ss").format(endAfternoon)}');
    var responseCekAfternoon =
        await http.get(urlCekAfternoon, headers: headers);
    var dataAfternoon = jsonDecode(responseCekAfternoon.body)['data'];
    scheduleAfternoon.value = dataAfternoon;
    var urlCekEvening = Uri.parse(
        '$apiUrl/api/doctor-availabilities?filters[doctor][id][\$eq]=${id}&sort=start&filters[start][\$gte]=${DateFormat("yyyy-MM-ddTHH:mm:ss").format(minTimeEvening)}&filters[start][\$lt]=${DateFormat("yyyy-MM-ddTHH:mm:ss").format(endEvening)}');
    var responseCekEvening = await http.get(urlCekEvening, headers: headers);
    var dataEvening = jsonDecode(responseCekEvening.body)['data'];
    scheduleEvening.value = dataEvening;
    // isLoading.value = false;
  }
}
