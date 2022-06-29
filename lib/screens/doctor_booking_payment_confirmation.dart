import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/controller/booking_detail_controller.dart';
import 'package:praktek_app/controller/main_controller.dart';
import 'package:praktek_app/controller/payment_detail_controller.dart';
import 'package:praktek_app/root.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorBookingPaymentConfirmation extends StatelessWidget {
  const DoctorBookingPaymentConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<MainController>().trackEventMixPanel('payment_confirmation');
    final PaymentDetailController controller =
        Get.put(PaymentDetailController());
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    String intToTimeLeft(int value) {
      int h, m, s;

      h = value ~/ 3600;

      m = ((value - h * 3600)) ~/ 60;

      s = value - (h * 3600) - (m * 60);

      String hourLeft =
          h.toString().length < 2 ? "0" + h.toString() : h.toString();

      String minuteLeft =
          m.toString().length < 2 ? "0" + m.toString() : m.toString();

      String secondsLeft =
          s.toString().length < 2 ? "0" + s.toString() : s.toString();

      String result = "$hourLeft:$minuteLeft:$secondsLeft";

      return result;
    }

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.grey.withOpacity(0.2),
        elevation: 4,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Order Created Successfully',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : Stack(children: [
              SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: Get.height, minWidth: double.infinity),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Batas Akhir Pembayaran:',
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  DateFormat('yyyy-MM-dd H:m:s')
                                      .format(DateTime.parse(controller
                                              .paymentInfo['attributes']
                                                  ['createdAt']
                                              .toString())
                                          .add(new Duration(hours: 24))
                                          .toLocal())
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Center(
                              child: TimerBuilder.periodic(Duration(seconds: 1),
                                  builder: (context) {
                                return Text(
                                  DateTime.parse(controller
                                                  .paymentInfo['attributes']
                                                      ['createdAt']
                                                  .toString())
                                              .add(new Duration(hours: 1))
                                              .difference(DateTime.now())
                                              .inSeconds >
                                          0
                                      ? intToTimeLeft(DateTime.parse(controller
                                                  .paymentInfo['attributes']
                                                      ['createdAt']
                                                  .toString())
                                              .add(new Duration(hours: 24))
                                              .difference(DateTime.now())
                                              .inSeconds)
                                          .toString()
                                      : 'Order has expired',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 22,
                                      color: Colors.red),
                                );
                              }),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Row(
                              children: [
                                Text('ORDER ID:'),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  Get.find<BookingDetailController>()
                                      .lastOrderId
                                      .toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              width: Get.width - 32,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.grey.shade300.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
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
                              child: controller.paymentInfo['attributes']
                              ['payment_transaction']
                              ['data'] == null?Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [Container(
                                          width: 60.0,
                                          height: 60.0,
                                          decoration:  BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage('assets/images/midtrans-logo.jpeg')
                                              )
                                          )
                                      ),
                                        
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Container(
                                          width: Get.width - 32 - 120,
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Midtrans',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                'Please finish payment',
                                                style: TextStyle(fontSize: 10),
                                                overflow: TextOverflow.ellipsis,
                                              ),

                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(thickness: 1,height: 1,),

                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text('Please finish payment following the instructions given by Midtrans.')
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Payment Amount', style:TextStyle(fontSize:12, color: kText)),
                                                Text('Rp. ${currencyFormatter.format(controller.paymentInfo['attributes']
                                                ['amount']
                                               )}'.toString(), style:TextStyle(fontSize:16, fontWeight: FontWeight.bold)),

                                              ],
                                            ),InkWell(
                                                onTap:(){
                                                  controller.copyToClipboard(controller.paymentInfo['attributes']

                                                  ['amount'].toString());
                                                },child: Text('Copy Amount', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kPrimary),))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(thickness: 1,height: 1,),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child:   Row(
                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [InkWell(
                                      onTap: () {
                                        Get.offAll(Root());
                                      },
                                      child: Container(
                                        width: Get.width * 0.4,
                                        decoration: BoxDecoration(
                                          // border: Border.all(
                                          //   color: kSecondary,
                                          // ),
                                          color: Colors.grey,
                                          gradient: LinearGradient(
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
                                          borderRadius: BorderRadius.all(Radius.circular(24)),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, right: 16, top: 12, bottom: 12),
                                            child: Text(
                                              'Home',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),InkWell(
                                      onTap: () {
                                        Get.find<AuthController>().selectedIndex.value = 1;
                                        Get.offAll(Root());

                                      },
                                      child: Container(
                                        width: Get.width * 0.4,
                                        decoration: BoxDecoration(
                                          // border: Border.all(
                                          //   color: kSecondary,
                                          // ),
                                          color: Colors.grey,
                                          gradient: LinearGradient(
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
                                          borderRadius: BorderRadius.all(Radius.circular(24)),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, right: 16, top: 12, bottom: 12),
                                            child: Text(
                                              'My Consultation',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),],),
                                  )
                                ],
                              ):
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 31,
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.3),
                                          child: CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.white,
                                            child: ClipOval(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                    controller.paymentInfo['attributes']
                                                    ['payment_transaction']
                                                    ['data']['attributes']
                                                    ['bank'] ==
                                                        'bca'
                                                        ? 'assets/images/bca.png'
                                                        :controller.paymentInfo['attributes']
                                                    ['payment_transaction']
                                                    ['data']['attributes']
                                                    ['payment_type'] ==
                                                        'shopeepay'
                                                        ? 'assets/images/shopeepay.png'
                                                        :controller.paymentInfo['attributes']
                                                    ['payment_transaction']
                                                    ['data']['attributes']
                                                    ['payment_type'] ==
                                                        'gopay'
                                                        ? 'assets/images/gopay.png'
                                                        : controller.paymentInfo['attributes']
                                                    ['payment_transaction']
                                                    ['data']['attributes']
                                                    ['bank'] ==
                                                        'echannel'
                                                        ? 'assets/images/mandiri.png'
                                                        : controller.paymentInfo['attributes']
                                                    ['payment_transaction']
                                                    ['data']
                                                    ['attributes']
                                                    ['bank'] ==
                                                        'bni'
                                                        ? 'assets/images/bni.png'
                                                        : controller.paymentInfo['attributes']['payment_transaction']['data']['attributes']['bank'] == 'permata'
                                                        ? 'assets/images/permata_bank.png'
                                                        : controller.paymentInfo['attributes']['payment_transaction']['data']['attributes']['bank'] == 'bri'
                                                        ? 'assets/images/bri.png'
                                                        : controller.paymentInfo['attributes']['payment_transaction']['data']['attributes']['bank'] == 'other'
                                                        ? 'assets/images/bank_transfer_network_atm_bersama.png'
                                                        : 'assets/images/bank_transfer_network_atm_bersama.png'),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Container(
                                          width: Get.width - 32 - 120,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.paymentInfo['attributes']
                                                                    ['payment_transaction']
                                                                ['data']['attributes']
                                                            ['bank'] ==
                                                        'bca'
                                                    ? 'BCA Virtual Account'
                                                    : controller.paymentInfo['attributes']
                                                ['payment_transaction']
                                                ['data']['attributes']
                                                ['payment_type'] ==
                                                    'shopeepay'
                                                    ? 'ShopeePay'
                                                    :controller.paymentInfo['attributes']
                                                ['payment_transaction']
                                                ['data']['attributes']
                                                ['payment_type'] ==
                                                    'gopay'
                                                    ? 'GoPay'
                                                    :controller.paymentInfo['attributes']
                                                                        ['payment_transaction']
                                                                    ['data']['attributes']
                                                                ['bank'] ==
                                                            'echannel'
                                                        ? 'Mandiri Virtual Account'
                                                        : controller.paymentInfo['attributes']
                                                                                ['payment_transaction']
                                                                            ['data']
                                                                        ['attributes']
                                                                    ['bank'] ==
                                                                'bni'
                                                            ? 'BNI Virtual Account'
                                                            : controller.paymentInfo['attributes']['payment_transaction']['data']['attributes']['bank'] == 'permata'
                                                    ? 'Permata Virtual Account'
                                                    : controller.paymentInfo['attributes']['payment_transaction']['data']['attributes']['bank'] == 'bri'
                                                    ? 'BRI Virtual Account'
                                                    : controller.paymentInfo['attributes']['payment_transaction']['data']['attributes']['bank'] == 'other'
                                                    ? 'Other Banks'
                                                    : '-',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                controller.paymentInfo['attributes']
                                                ['payment_transaction']
                                                ['data']['attributes']
                                                ['bank'] ==
                                                    'bca'
                                                    ? 'Pay from BCA ATM\'s or internet banking'
                                                    : controller.paymentInfo['attributes']
                                                ['payment_transaction']
                                                ['data']['attributes']
                                                ['payment_type'] ==
                                                    'shopeepay'
                                                    ? 'Pay using QR-Code or in the app.'
                                                    :controller.paymentInfo['attributes']
                                                ['payment_transaction']
                                                ['data']['attributes']
                                                ['payment_type'] ==
                                                    'gopay'
                                                    ? 'Pay using QR-Code or in the app.'
                                                    :controller.paymentInfo['attributes']
                                                ['payment_transaction']
                                                ['data']['attributes']
                                                ['bank'] ==
                                                    'echannel'
                                                    ? 'Pay from Mandiri ATM\'s or internet banking'
                                                    : controller.paymentInfo['attributes']
                                                ['payment_transaction']
                                                ['data']
                                                ['attributes']
                                                ['bank'] ==
                                                    'bni'
                                                    ? 'Pay from BNI ATM\'s or internet banking'
                                                    : controller.paymentInfo['attributes']['payment_transaction']['data']['attributes']['bank'] == 'permata'
                                                    ? 'Pay from Permata Bank ATM\'s or internet banking'
                                                    : controller.paymentInfo['attributes']['payment_transaction']['data']['attributes']['bank'] == 'bri'
                                                    ? 'Pay from BRI ATM\'s or internet banking'
                                                    : controller.paymentInfo['attributes']['payment_transaction']['data']['attributes']['bank'] == 'other'
                                                    ? 'Pay from other bank ATM or via internet banking'
                                                    : 'Pay from bank ATM or via internet banking',
                                                style: TextStyle(fontSize: 10),
                                                overflow: TextOverflow.ellipsis,
                                              ),

                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(thickness: 1,height: 1,),
                                  controller.paymentInfo['attributes']
                                  ['payment_transaction']
                                  ['data']['attributes']
                                  ['bank']==''?Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                    controller.paymentInfo['attributes']
                                    ['payment_transaction']
                                    ['data']['attributes']
                                    ['payment_type'] ==
                                        'shopeepay'?Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap:() async{
                                                await launch( controller.paymentInfo['attributes']
                                                ['payment_transaction']
                                                ['data']['attributes']['deeplink_redirect']);

                                              },
                                              child: Container(
                                              width: Get.width * 0.4,
                                    decoration: BoxDecoration(
                                      // border: Border.all(
                                      //   color: kSecondary,
                                      // ),
                                      color: Colors.deepOrange,

                                      borderRadius: BorderRadius.all(Radius.circular(24)),
                                    ),
                                    child: Center(
                                      child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, right: 16, top: 12, bottom: 12),
                                              child: Text(
                                                'Open Shopee',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                      ),
                                    ),
                                  ),
                                            ),
                                          ),
                                        ):Column(
                                          children: [
                                            controller.paymentInfo['attributes']
                                            ['payment_transaction']
                                            ['data']['attributes']['qr_code']!= ''?Image.network(controller.paymentInfo['attributes']
                                    ['payment_transaction']
                                    ['data']['attributes']['qr_code']):Container(),Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap:() async{
                                                  await launch( controller.paymentInfo['attributes']
                                                  ['payment_transaction']
                                                  ['data']['attributes']['deeplink_redirect']);

                                                },
                                                child: Container(
                                                  width: Get.width * 0.4,
                                                  decoration: BoxDecoration(
                                                    // border: Border.all(
                                                    //   color: kSecondary,
                                                    // ),
                                                    color: Colors.green,

                                                    borderRadius: BorderRadius.all(Radius.circular(24)),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 16.0, right: 16, top: 12, bottom: 12),
                                                      child: Text(
                                                        'Open Gopay',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height:32),

                                          ],
                                        ),

                                  ],):Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Virtual Account Number', style:TextStyle(fontSize:12, color: kText)),
                                                Text(controller.paymentInfo['attributes']
                                                ['payment_transaction']
                                                ['data']['attributes']
                                                ['va_numbers']??'-', style:TextStyle(fontSize:16, fontWeight: FontWeight.bold)),

                                              ],
                                            ),InkWell(onTap:(){
                                              controller.copyToClipboard(controller.paymentInfo['attributes']
                                              ['payment_transaction']
                                              ['data']['attributes']
                                              ['va_numbers']??'-');
    },
    child: Text('Copy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kPrimary),))
                                              ],
                                              ),
                                              ),
                                      Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                              Column(mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                              Text('Payment Amount', style:TextStyle(fontSize:12, color: kText)),
                                              Text('Rp. ${currencyFormatter.format(controller.paymentInfo['attributes']
                                                ['payment_transaction']
                                                ['data']['attributes']
                                                ['amount'])}'.toString(), style:TextStyle(fontSize:16, fontWeight: FontWeight.bold)),

                                              ],
                                            ),InkWell(
                                                    onTap:(){
                                                      controller.copyToClipboard(controller.paymentInfo['attributes']
                                                      ['payment_transaction']
                                                      ['data']['attributes']
                                                      ['amount'].toString());
                                                    },child: Text('Copy Amount', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kPrimary),))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(thickness: 1,height: 1,),
Padding(
  padding: const EdgeInsets.all(16.0),
  child:   Row(
    mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [InkWell(
    onTap: () {
      Get.offAll(Root());
    },
    child: Container(
      width: Get.width * 0.4,
      decoration: BoxDecoration(
        // border: Border.all(
        //   color: kSecondary,
        // ),
        color: Colors.grey,
        gradient: LinearGradient(
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
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16, top: 12, bottom: 12),
          child: Text(
            'Home',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    ),
  ),InkWell(
    onTap: () {
      Get.find<AuthController>().selectedIndex.value = 1;
      Get.offAll(Root());

    },
    child: Container(
      width: Get.width * 0.4,
      decoration: BoxDecoration(
        // border: Border.all(
        //   color: kSecondary,
        // ),
        color: Colors.grey,
        gradient: LinearGradient(
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
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16, top: 12, bottom: 12),
          child: Text(
            'My Consultation',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    ),
  ),],),
)
                                ],
                              ),
                            ),

                            SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Positioned(
              //   bottom: 20,
              //   left: (Get.width * 0.1) / 2,
              //   child: Container(
              //     decoration: new BoxDecoration(
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.grey.withOpacity(0.2),
              //             spreadRadius: 10,
              //             blurRadius: 5,
              //             offset: Offset(0, 7), // changes position of shadow
              //           ),
              //         ],
              //         borderRadius: new BorderRadius.only(
              //           topLeft: const Radius.circular(24.0),
              //           topRight: const Radius.circular(24.0),
              //         )),
              //     width: Get.width * 0.9,
              //     child: InkWell(
              //       onTap: () {
              //         Get.snackbar('Nothing to do',
              //             'Anda belum memilih cara pembayaran.',
              //             backgroundColor: Colors.redAccent,
              //             colorText: Colors.white);
              //       },
              //       child: Container(
              //         width: Get.width * 0.9,
              //         decoration: BoxDecoration(
              //           // border: Border.all(
              //           //   color: kSecondary,
              //           // ),
              //           color: Colors.grey,
              //           gradient: LinearGradient(
              //             begin: Alignment.centerLeft,
              //             end: Alignment.centerRight,
              //             colors: [
              //               kPrimary,
              //               kSecondary,
              //             ],
              //             stops: [
              //               0.0,
              //               1.0,
              //             ],
              //           ),
              //           borderRadius: BorderRadius.all(Radius.circular(24)),
              //         ),
              //         child: Center(
              //           child: Padding(
              //             padding: const EdgeInsets.only(
              //                 left: 16.0, right: 16, top: 12, bottom: 12),
              //             child: Text(
              //               'test',
              //               style: TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.white),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ])),
    );
  }
}
