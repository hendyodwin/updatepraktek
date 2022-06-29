import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/controller/chat_screen_controller.dart';
import 'package:praktek_app/screens/doctor_profile_patient.dart';
import 'package:video_player/video_player.dart';

import 'medical_record_screen.dart';

class DoctorChatScreen extends StatelessWidget {
  const DoctorChatScreen(
      {Key? key, required this.roomId, required this.orderId})
      : super(key: key);
  final String roomId;
  final String orderId;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    Stream<DocumentSnapshot> documentStream =
        _db.collection('chatroom').doc(this.roomId).snapshots();

    final ChatScreenController controller = Get.put(ChatScreenController());
    controller.isDoctorScreen.value = true;
    controller.orderId.value = orderId;
    return Obx(
      () => controller.isLoading.value
          ? Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : StreamBuilder<DocumentSnapshot>(
              stream: documentStream,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshotDoc) {
                if (!snapshotDoc.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshotDoc.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                bool isActiveChat = snapshotDoc.data!['active'] ?? false;
                return Scaffold(
                    appBar: AppBar(
                      shadowColor: Colors.grey.withOpacity(0.2),
                      elevation: 4,
                      titleSpacing: 0,
                      backgroundColor: Colors.white,
                      centerTitle: false,
                      leading: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                      ),
                      title: InkWell(
                        onTap: () {
                          Get.to(() => DoctorProfilePatient(
                              doctor: controller.doctorID.value));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CircleAvatar(
                              backgroundColor: kPrimary,
                              backgroundImage:
                                  NetworkImage(controller.chatWithPP.value),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.chatWithName.value,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  controller.chatWithStatus.value,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        InkWell(
                          onTap: () async {
                            if (isActiveChat) {
                              await _db
                                  .collection('chatroom')
                                  .doc(this.roomId)
                                  .update({'active': false});
                            } else {
                              await _db
                                  .collection('chatroom')
                                  .doc(this.roomId)
                                  .update({'active': true});
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Icon(
                              isActiveChat
                                  ? Icons.stop_circle_outlined
                                  : Icons.play_circle_fill,
                              size: 40,
                              color: isActiveChat ? Colors.redAccent : kPrimary,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              return MedialRecordScreen();
                            })));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Image.asset(
                              'assets/images/Document.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    body: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                                stream: _db
                                    .collection('chatroom')
                                    .doc(this.roomId)
                                    .collection("chat")
                                    .orderBy('timestamp', descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  print(this.roomId);
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  final messages = snapshot.data!.docs;
                                  debugPrint(messages.toString());

                                  List<MessageBubble> messageBubbles = [];
                                  for (var message in messages) {
                                    debugPrint(message.toString());
                                    final messageText =
                                        (message.data() as Map<String, dynamic>)
                                                .containsKey('content')
                                            ? message['content']
                                            : null;
                                    final messageSender = message['sender'];
                                    final messageType = message['type'];
                                    final currentUser =
                                        Get.find<AuthController>().user_id_db;
                                    final timeStamp = message['timestamp'];
                                    if (messageType == 'txt') {
                                      final messageBubble = MessageBubble(
                                        content: messageText,
                                        type: messageType,
                                        sender: messageSender.toString(),
                                        isMe: currentUser == messageSender,
                                        timeStamp: timeStamp.toString(),
                                        title: null,
                                        photo: null,
                                        price: 0,
                                      );
                                      messageBubbles.add(messageBubble);
                                    } else if (messageType == 'video') {
                                      final messageBubble = MessageBubble(
                                        content: messageText,
                                        type: messageType,
                                        sender: messageSender.toString(),
                                        isMe: currentUser == messageSender,
                                        timeStamp: timeStamp.toString(),
                                        title: null,
                                        photo: null,
                                        price: 0,
                                      );
                                      messageBubbles.add(messageBubble);
                                    } else if (messageType == 'image') {
                                      final messageBubble = MessageBubble(
                                        content: messageText,
                                        type: messageType,
                                        sender: messageSender.toString(),
                                        isMe: currentUser == messageSender,
                                        timeStamp: timeStamp.toString(),
                                        title: null,
                                        photo: null,
                                        price: 0,
                                      );
                                      messageBubbles.add(messageBubble);
                                    } else {
                                      final messageBubble = MessageBubble(
                                          content: messageText,
                                          type: messageType,
                                          sender: messageSender,
                                          isMe: currentUser == messageSender,
                                          timeStamp: timeStamp,
                                          title: message['product']['title'],
                                          photo: message['product']['photos']
                                              [0],
                                          price: double.parse(
                                              message['product']['price']));
                                      messageBubbles.add(messageBubble);
                                    }
                                  }
                                  return messageBubbles.length > 0
                                      ? ListView(
                                          reverse: true,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 20,
                                          ),
                                          children: messageBubbles,
                                        )
                                      : Container();
                                })),
                        isActiveChat
                            ? Column(
                                children: [
                                  Divider(
                                    height: 1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            controller.uploadImage(roomId);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12,
                                                top: 8.0,
                                                bottom: 8,
                                                right: 8),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: TextField(
                                              decoration:
                                                  InputDecoration.collapsed(
                                                hintText:
                                                    "Ketik pesan disini...",
                                              ),
                                              textInputAction:
                                                  TextInputAction.send,
                                              controller: controller.textField,
                                              onEditingComplete: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                controller.sendMessage(
                                                    this.roomId, 'doctor');

                                              },
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            controller.sendMessage(
                                                this.roomId, 'doctor');

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12,
                                                top: 8.0,
                                                bottom: 8,
                                                left: 8),
                                            child: Icon(
                                              Icons.send,
                                              color: kPrimary,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ));
              }),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {this.sender,
      this.content,
      this.type,
      this.timeStamp,
      this.isMe,
      this.title,
      this.photo,
      this.price});

  final content;
  final String? type;
  final String? sender;
  final String? timeStamp;
  final bool? isMe;
  final String? title;
  final String? photo;
  final double? price;

  @override
  Widget build(BuildContext context) {
    final ChatScreenController controller = Get.put(ChatScreenController());

    print('========');
    var earlier = DateTime.now().subtract(const Duration(days: 1));
    final f = new DateFormat('d/M');
    int datetimeint = int.parse(timeStamp!);
    // TODO: implement build
    if (type == 'txt') {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              !isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Material(
              borderRadius: !isMe!
                  ? BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                      topLeft: Radius.circular(12),
                    ),
              elevation: 0,
              color: isMe! ? kSecondary : Colors.grey.shade100,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$content',
                      style: TextStyle(
                          color: isMe! ? Colors.white : Colors.black,
                          fontSize: 14),
                    ),
                    Text(
                      earlier.isBefore(
                              DateTime.fromMillisecondsSinceEpoch(datetimeint))
                          ? DateFormat.Hm()
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  datetimeint))
                              .toString()
                          : f.format(
                              DateTime.fromMillisecondsSinceEpoch(datetimeint)),
                      style: TextStyle(
                          color: isMe! ? Colors.white : Colors.black54,
                          fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (type == 'video') {
      return Obx(
        () => controller.videoIsLoading.value
            ? SizedBox(
                width: 40,
                height: 40,
                child: Align(
                    alignment: Alignment.topLeft,
                    child: CircularProgressIndicator(
                      color: kSecondary,
                    )))
            : Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: !isMe!
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  controller.toggleVideoPlay();
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      width: Get.width / 2,
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: SizedBox(
                                            height: controller.controllerVideo
                                                .value.size.height,
                                            width: controller.controllerVideo
                                                .value.size.width,
                                            child: VideoPlayer(
                                                controller.controllerVideo)),
                                      ),
                                    ),
                                    Obx(
                                      () => controller.videoPlaying.value
                                          ? Positioned.fill(child: Container())
                                          : Positioned.fill(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Icon(
                                                    Icons.play_circle_fill,
                                                    color: Colors.white,
                                                    size: 40),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            earlier.isBefore(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        datetimeint))
                                ? DateFormat.Hm()
                                    .format(DateTime.fromMillisecondsSinceEpoch(
                                        datetimeint))
                                    .toString()
                                : f.format(DateTime.fromMillisecondsSinceEpoch(
                                    datetimeint)),
                            style:
                                TextStyle(color: Colors.black54, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      );
    } else if (type == 'image') {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              !isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  Container(
                    width: Get.width / 2,
                    height: Get.width ,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: CachedNetworkImage(imageUrl: content, fit: BoxFit.cover,)

                    // Column(
                    // children: [
                    //   Container(
                    //     width: Get.width / 2,
                    //     decoration: BoxDecoration(
                    //       color: Colors.grey,
                    //       border: Border.all(
                    //         color: Colors.grey,
                    //       ),
                    //     ),
                    //     child: FittedBox(
                    //       fit: BoxFit.cover,
                    //       child: CachedNetworkImage(
                    //         imageUrl: '$content',
                    //       ),
                    //     ),
                    //   ),
                    // ],
                  ),
                  Text(
                    earlier.isBefore(
                            DateTime.fromMillisecondsSinceEpoch(datetimeint))
                        ? DateFormat.Hm()
                            .format(DateTime.fromMillisecondsSinceEpoch(
                                datetimeint))
                            .toString()
                        : f.format(
                            DateTime.fromMillisecondsSinceEpoch(datetimeint)),
                    style: TextStyle(color: Colors.black54, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      print(content);
      return Container();
      // return Column(
      //   children: [
      //     Container(
      //       decoration: BoxDecoration(
      //           color: Colors.yellow.withOpacity(0.2),
      //           borderRadius: BorderRadius.all(Radius.circular(8))),
      //       child: Padding(
      //         padding: const EdgeInsets.all(14.0),
      //         child: Row(
      //           children: [
      //             FadeInImage.memoryNetwork(
      //               placeholder: kTransparentImage,
      //               width: 60,
      //               fit: BoxFit.cover,
      //               image: storageURL_100 + photo!,
      //             ),
      //             SizedBox(
      //               width: 15,
      //             ),
      //             Column(
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Container(
      //                   width: Get.width - 130,
      //                   child: Text(
      //                     title!,
      //                     overflow: TextOverflow.ellipsis,
      //                     maxLines: 2,
      //                   ),
      //                 ),
      //                 Text(
      //                   '${kCurrency} ${oCcy.format(price)}',
      //                   style: TextStyle(fontWeight: FontWeight.bold),
      //                 )
      //               ],
      //             )
      //           ],
      //         ),
      //       ),
      //     ),
      //     SizedBox(
      //       height: 12,
      //     ),
      //     Container(
      //       child: Row(
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.only(left: 16.0, right: 8),
      //             child: Icon(Icons.security_rounded),
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: Column(
      //               children: [
      //                 Container(
      //                   width: Get.width - 100,
      //                   child: Text(
      //                     'chat_safe_1'.tr + 'chat_safe_2'.tr,
      //                     overflow: TextOverflow.ellipsis,
      //                     softWrap: true,
      //                     maxLines: 3,
      //                     textAlign: TextAlign.center,
      //                     style: TextStyle(fontSize: 10),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //     SizedBox(
      //       height: 12,
      //     ),
      //     Divider(),
      //   ],
      // );
    }
  }
}
