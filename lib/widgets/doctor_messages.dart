import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/controller/booking_detail_controller.dart';
import 'package:praktek_app/controller/doctor_messages_list_controller.dart';
import 'package:praktek_app/helpers/debug.dart';
import 'package:praktek_app/screens/doctor_booking_payment_confirmation.dart';
import 'package:praktek_app/screens/doctor_chat_screen.dart';

//TODO: ADD MESSAGE STREAM
class DoctorMessages extends StatefulWidget {
  const DoctorMessages({Key? key}) : super(key: key);

  @override
  State<DoctorMessages> createState() => _DoctorMessagesState();
}

class _DoctorMessagesState extends State<DoctorMessages> {
  final DoctorMessagesListController controller =
      Get.put(DoctorMessagesListController());
  final BookingDetailController controllerBooking =
      Get.put(BookingDetailController());

  final _formKey = GlobalKey<FormBuilderState>();
  final List dummyList = List.generate(1000, (index) {
    return {
      "id": index,
      "title": "dr. Justing Sharma $index",
      "subtitle": "Selamat siang Mba Vania, ada yang bisa saya bantu..."
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 8.0,
          shadowColor: Colors.grey.shade100,
          title: Container(
            width: double.infinity,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: Get.width - 16,
                  decoration: BoxDecoration(
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.shade300.withOpacity(0.9),
                    //     spreadRadius: 3,
                    //     blurRadius: 10,
                    //     offset: Offset(0, 0), // changes position of shadow
                    //   ),
                    // ],
                    border: Border.all(
                      color: Colors.white,
                    ),
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: FormBuilder(
                    key: _formKey,
                    child: FormBuilderTextField(
                      controller: Get.find<AuthController>().mySearch,
                      name: 'search',
                      style: TextStyle(
                          fontSize: 14.0, height: 2.0, color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 8.0, bottom: 8.0, left: 12.0, right: 8.0),
                          hintText: Get.find<AuthController>()
                                      .defaultWarungName
                                      .value !=
                                  ''
                              ? 'Cari di ${Get.find<AuthController>().defaultWarungName.value}...'
                              : 'Cari patient anda',
                          border: InputBorder.none,
                          prefixIcon: InkWell(
                            onTap: () {
                              print(Get.find<AuthController>()
                                  .mySearch
                                  .value
                                  .text);
                            },
                            child: Icon(
                              LineIcons.search,
                              color: kText,
                            ),
                          )),

                      onEditingComplete: () {
                        print(Get.find<AuthController>().mySearch.value.text);
                      },
                      onChanged: (value) {
                        print(value);
                      },
                      // validator: FormBuilderValidators.compose([
                      //   FormBuilderValidators.required(context),
                      // ]),
                    ),
                  ),
                ),
                // Your widgets here
              ],
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 3,
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => RefreshIndicator(
            onRefresh: () {
              return controller.getChatList();
            },
            child: ListView.builder(
              itemCount: controller.messageList.length,
              itemBuilder: (context, index) {
                return MessageCard(messageData: controller.messageList[index]);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  const MessageCard({
    Key? key,
    required this.messageData,
  }) : super(key: key);

  final Map messageData;

  @override
  Widget build(BuildContext context) {
    DebugTools().printWrapped(messageData.toString());
    return InkWell(
      onTap: () {



        if (messageData['attributes']['paid']) {
          Get.to(() => DoctorChatScreen(
                orderId: messageData['id'].toString(),
                roomId: messageData['attributes']['room_id'],
              ));
        } else {
          Get.find<BookingDetailController>().lastOrderId.value =
              messageData['id'];
          Get.to(() => DoctorBookingPaymentConfirmation());
        }
        print('clicked');
      },
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                      backgroundColor: kPrimary,
                      backgroundImage: CachedNetworkImageProvider(
                        messageData['attributes']['profile']['data']
                                        ['attributes']['profile_picture']['data']
                                    ['attributes']['formats']['medium'] ==
                                null
                            ? messageData['attributes']['profile']['data']
                                    ['attributes']['profile_picture']['data']
                                ['attributes']['formats']['thumbnail']['url']
                            : messageData['attributes']['profile']['data']
                                    ['attributes']['profile_picture']['data']
                                ['attributes']['formats']['medium']['url'],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -4,
                    right: -2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        border: Border.all(color: Colors.white, width: 2),
                        shape: BoxShape.circle,
                      ),
                      height: 18.0,
                      width: 18.0,
                      child: Center(
                          // Your Widget
                          ),
                    ),
                  ),
                ],
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(

                messageData['attributes']['profile']['data']['attributes']
                        ['name'] ??
                    '-'
                 ,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Text(
                (DateFormat('dd/MM/yyyy')
                    .format(
                        DateTime.parse(messageData['attributes']['createdAt'])
                            .toLocal())
                    .toString()),
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 10,
                    color: kText,
                    height: 1.3),
              ),
            ),
            trailing: messageData['attributes']['paid']
                ? SizedBox(
                    width: 20,
                    height: 20,
                  )
                // ? Container(
                //     width: 20,
                //     height: 20,
                //     decoration: BoxDecoration(
                //         color: Colors.redAccent,
                //         border: Border.all(
                //           color: Colors.redAccent,
                //         ),
                //         borderRadius: BorderRadius.all(Radius.circular(50))),
                //     child: Center(
                //         child: Text(
                //       '1',
                //       style: TextStyle(
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold,
                //           fontSize: 12),
                //     )))
                : InkWell(
                    onTap: () {
                      Get.find<BookingDetailController>().lastOrderId.value =
                          messageData['id'];
                      Get.to(() => DoctorBookingPaymentConfirmation());
                    },
                    child: Container(
                      width: 70,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Center(
                          child: Text(
                            "Pay",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient:
                              LinearGradient(colors: [kPrimary, kSecondary])),
                    ),
                  ),
            // : Icon(
            //     Icons.add_a_photo,
            //     color: Colors.white,
            //   ),
          ),
        ),
      ),
    );
  }
}

class FilterBox extends StatelessWidget {
  const FilterBox({Key? key, required this.color, required this.title})
      : super(key: key);

  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              (Radius.circular(20)),
            ),
            border: Border.all(
              color: color,
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, top: 8.0, bottom: 8, right: 16),
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 12, color: color),
            ),
          ),
        ),
      ),
    );
  }
}
