import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/booking_detail_controller.dart';
import 'package:praktek_app/controller/main_controller.dart';

class DoctorBookingPaymentMethodPatient extends StatelessWidget {
  const DoctorBookingPaymentMethodPatient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<MainController>().trackEventMixPanel('payment_selection');
    final BookingDetailController controller =
        Get.put(BookingDetailController());
    final currencyFormatter = NumberFormat('#,##0', 'ID');

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
        title: Obx(
          () => Text(
            controller.midtransCoreApi.value ? 'Payment Method' : 'Payment',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : controller.midtransCoreApi.value
                ? Stack(children: [
                    SingleChildScrollView(
                      child: Container(
                        width: Get.width,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 4,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('E-Wallet'),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  PaymentBox(
                                    option: 'gopay',
                                    title: 'GoPay',
                                    subTitle: 'Pay with your GoPay wallet.',
                                    logo: 'assets/images/gopay.png',
                                    selectedPayment:
                                        controller.paymentOptionSelected.value,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  // PaymentBox(
                                  //     option: 'shopeepay',
                                  //     title: 'ShopeePay',
                                  //     subTitle: 'Pay with your ShopeePay wallet..',
                                  //     logo: 'assets/images/shopeepay.png',
                                  //     selectedPayment:
                                  //         controller.paymentOptionSelected.value),
                                  // SizedBox(
                                  //   height: 16,
                                  // ),
                                  Text('Virtual Account'),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  // PaymentBox(
                                  //     option: 'bca',
                                  //     title: 'BCA Virtual Account',
                                  //     subTitle:
                                  //         'Pay from BCA ATM\'s or internet banking',
                                  //     logo: 'assets/images/bca.png',
                                  //     selectedPayment:
                                  //         controller.paymentOptionSelected.value),
                                  // SizedBox(
                                  //   height: 8,
                                  // ),
                                  PaymentBox(
                                      option: 'permata',
                                      title: 'Permata Virtual Account',
                                      subTitle:
                                          'Pay from Permata Bank ATM\'s or internet banking',
                                      logo: 'assets/images/permata_bank.png',
                                      selectedPayment: controller
                                          .paymentOptionSelected.value),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  PaymentBox(
                                      option: 'echannel',
                                      title: 'Mandiri Virtual Account',
                                      subTitle:
                                          'Pay from Mandiri ATM\'s or internet banking',
                                      logo: 'assets/images/mandiri.png',
                                      selectedPayment: controller
                                          .paymentOptionSelected.value),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  PaymentBox(
                                      option: 'bni',
                                      title: 'BNI Virtual Account',
                                      subTitle:
                                          'Pay from BNI ATM\'s or internet banking',
                                      logo: 'assets/images/bni.png',
                                      selectedPayment: controller
                                          .paymentOptionSelected.value),
                                  SizedBox(
                                    height: 8,
                                  ),

                                  PaymentBox(
                                      option: 'bri',
                                      title: 'BRI Virtual Account',
                                      subTitle:
                                          'Pay from BRI ATM\'s or internet banking',
                                      logo: 'assets/images/bri.png',
                                      selectedPayment: controller
                                          .paymentOptionSelected.value),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  PaymentBox(
                                      option: 'other',
                                      title: 'Other Banks',
                                      subTitle:
                                          'Pay from other bank ATM or via internet banking',
                                      logo:
                                          'assets/images/bank_transfer_network_atm_bersama.png',
                                      selectedPayment: controller
                                          .paymentOptionSelected.value),
                                  SizedBox(height: 100),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: (Get.width * 0.1) / 2,
                      child: Container(
                        decoration: new BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 10,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 7), // changes position of shadow
                              ),
                            ],
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(24.0),
                              topRight: const Radius.circular(24.0),
                            )),
                        width: Get.width * 0.9,
                        child: InkWell(
                          onTap: () {
                            if (controller.paymentOptionSelected != '') {
                              controller.placeOrder();
                            } else {
                              Get.snackbar('Select Payment Option',
                                  'Anda belum memilih cara pembayaran.',
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white);
                            }
                          },
                          child: Container(
                            width: Get.width * 0.9,
                            decoration: BoxDecoration(
                              // border: Border.all(
                              //   color: kSecondary,
                              // ),
                              color: Colors.grey,
                              gradient: controller.paymentOptionSelected != ''
                                  ? LinearGradient(
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
                                    )
                                  : null,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16, top: 12, bottom: 12),
                                child: Obx(
                                  () => Text(
                                    controller.bookingType.value == 'chat'
                                        ? 'Book dan Bayar Rp${currencyFormatter.format(controller.doctor['attributes']['rate_chat'])}'
                                        : 'Book dan Bayar Rp${currencyFormatter.format(controller.slot['attributes']['price'])}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ])
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: Get.width,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 32,
                              ),
                              Container(
                                decoration: new BoxDecoration(
                                  color: Color(0xFFE7FBFF),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Image.asset(
                                      'assets/images/payment_image.png'),
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                'Make Payment Securely',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: kPrimary),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0),
                                child: Text(
                                  'Click on the below button to book your appointment and after that you will be redirected to do a secure payment using Midtrans. Do not close the app before the booking has been finalized.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: (Get.width * 0.1) / 2,
                            vertical: (Get.width * 0.1) / 2),
                        child: Container(
                          decoration: new BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 10,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 7), // changes position of shadow
                                ),
                              ],
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(24.0),
                                topRight: const Radius.circular(24.0),
                              )),
                          width: Get.width * 0.9,
                          child: InkWell(
                            onTap: () {
                              controller.placeOrder();
                            },
                            child: Container(
                              width: Get.width * 0.9,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24)),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16,
                                      top: 12,
                                      bottom: 12),
                                  child: Obx(
                                    () => Text(
                                      controller.bookingType.value == 'chat'
                                          ? 'Book dan Bayar Rp${currencyFormatter.format(controller.doctor['attributes']['rate_chat'])}'
                                          : 'Book dan Bayar Rp${currencyFormatter.format(controller.slot['attributes']['price'])}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class PaymentBox extends StatelessWidget {
  const PaymentBox({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.logo,
    required this.selectedPayment,
    required this.option,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final String logo;
  final String selectedPayment;
  final String option;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (Get.find<BookingDetailController>().paymentOptionSelected.value !=
            option) {
          Get.find<BookingDetailController>().paymentOptionSelected.value =
              option;
        } else {
          Get.find<BookingDetailController>().paymentOptionSelected.value = '';
        }
      },
      child: Container(
        width: Get.width - 32,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
          border: Border.all(
            color: Get.find<BookingDetailController>()
                        .paymentOptionSelected
                        .value ==
                    option
                ? kPrimary
                : Colors.white,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 31,
                backgroundColor: Colors.grey.withOpacity(0.3),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(logo),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      subTitle,
                      style: TextStyle(fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
