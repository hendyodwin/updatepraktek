import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:timer_builder/timer_builder.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({Key? key, required this.appointment}) : super(key: key);
  final Map appointment;

  @override
  _JoinRoomState createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  // You can use these to add more control over the meet
  late TextEditingController serverText;
  late TextEditingController roomText;
  late TextEditingController subjectText;
  late TextEditingController nameText;
  late TextEditingController emailText;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  // Self-explainable bools
  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = false;
  var isalreadyJoined = false;
  var isLeft = false;
  int secondsPassed = 0;

  @override
  void initState() {
    super.initState();
    // Intitalising variables
    debugPrint(widget.appointment.toString());
    serverText = TextEditingController(text: "https://meet.sprout.co.id");
    roomText = TextEditingController(
        text: widget.appointment['attributes']['room_id']);
    subjectText = TextEditingController(text: "Consult");
    nameText = TextEditingController(
        text: Get.find<AuthController>().profileName.value);
    emailText = TextEditingController(
        text: Get.find<AuthController>().profileEmail.value);
    // Adding a Listener
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onPictureInPictureWillEnter: _onPictureInPictureWillEnter,
        onPictureInPictureTerminated: _onPictureInPictureTerminated,
        onError: _onError));

    _db.
    collection('video').doc(widget.appointment['attributes']['room_id'])
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) async{


      if(documentSnapshot['doctor_joined']){
        if(!isalreadyJoined) {
          setState(() {
            isalreadyJoined = true;
          });
          await Future.delayed(Duration(seconds: 3));

          _joinMeeting();
        }
      }

    })
        .onError((e) => print(e));
  }

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
    if(h<1){
       result = "$minuteLeft:$secondsLeft";
    }
    return result;
  }

  // Define your own constraints
  static final Map<RoomNameConstraintType, RoomNameConstraint>
      customContraints = {
    RoomNameConstraintType.MAX_LENGTH: new RoomNameConstraint((value) {
      return value.trim().length <= 50;
    }, "Maximum room name length should be 30."),
    RoomNameConstraintType.FORBIDDEN_CHARS: new RoomNameConstraint((value) {
      return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
              .hasMatch(value) ==
          false;
    }, "Currencies characters aren't allowed in room names."),
  };

  _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted");
  }

  _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted");
  }

  _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted");
    setState(() {
      isLeft = true;
    });
  }

  _onPictureInPictureWillEnter(message) {
    debugPrint(
        "_onPictureInPictureWillEnter broadcasted with message: $message");
  }

  _onPictureInPictureTerminated(message) {
    debugPrint(
        "_onPictureInPictureTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted");
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {

    // Designing the page
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AvatarGlow(
                glowColor: Colors.blue,
                endRadius: Get.width/3,
                repeat: true,
                showTwoGlows: true,
                repeatPauseDuration: Duration(milliseconds: 200),
                child: Material(
                  // Replace this child with your own
                  elevation: 8.0,
                  shape: CircleBorder(),
                  child: SizedBox(
                    width: Get.width/3,
                    height: Get.width/3,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      backgroundImage: NetworkImage(
                        widget.appointment['attributes']['doctor']['data']['attributes']['profile_picture']['data']
                                    ['attributes']['formats']['medium'] ==
                                null
                            ? widget.appointment['attributes']['doctor']['data']
                                    ['attributes']['profile_picture']['data']
                                ['attributes']['formats']['thumbnail']['url']
                            : widget.appointment['attributes']['doctor']['data']
                                    ['attributes']['profile_picture']['data']
                                ['attributes']['formats']['medium']['url'],
                      ),
                      radius: Get.width/4,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32,),
              Text('Appointment: ${(DateFormat('dd/MM/yyyy').format(
                  DateTime.parse(widget.appointment['attributes']['doctor_availability']['data']['attributes']['start']).toLocal()).toString())} - ${(DateFormat('HH:mm').format(
                  DateTime.parse(widget.appointment['attributes']['doctor_availability']['data']['attributes']['start']).toLocal()).toString())}', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 16,),
              Text(isLeft?'You left the consult, do you want to rejoin?':'Waiting for ${widget.appointment['attributes']['doctor']['data']
              ['attributes']['full_name']}', style: TextStyle(color:kText2),),
              isLeft?Container():TimerBuilder.periodic(Duration(seconds: 1),
                  builder: (context) {
                    secondsPassed = secondsPassed+1;
                    return Text(
                      intToTimeLeft(secondsPassed)
                          .toString()
                          ,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          color: Colors.red),
                    );
                  }),
              SizedBox(height: 100,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLeft?Padding(
                    padding: const EdgeInsets.only(right:16.0),
                    child: InkWell(
                      onTap:(){Get.back();},

                      child: Container(
                        width:65,
                        height: 65,
                        child: CircleAvatar(
                          backgroundColor:Colors.redAccent,
                          child: Icon(Icons.phone_disabled_outlined, size: 40,color: Colors.white,),),),),
                  ):Container(),
                  InkWell(
                      onTap:(){if(!isLeft){Get.back();}else{_joinMeeting();}},
                    onDoubleTap: (){
                        _joinMeeting();
                    },
                      child: Container(
                          width:65,
                          height: 65,
                          child: CircleAvatar(
                              backgroundColor:isLeft?Colors.green:Colors.redAccent,
                              child: Icon(Icons.phone, size: 40,color: Colors.white,),),),),

                ],
              ),
              // Container(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       IconButton(
              //           icon: Icon(BootstrapIcons
              //               .arrow_left), //Import any icon, which you want
              //           color: Colors.black.withOpacity(0.3),
              //           onPressed: () {
              //             Navigator.pop(context);
              //           }),
              //     ],
              //   ),
              //   margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
              // ),

              // const Spacer(flex: 65),
              // Container(
              //   child: Text(
              //     "Join the Consult",
              //     style: TextStyle(
              //       fontWeight: FontWeight.w700,
              //       fontSize: 35,
              //       color: Colors.black,
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              //   margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
              // ),
              // const Spacer(flex: 65),
              // Container(
              //   width: 350,
              //   height: 60,
              //   decoration: BoxDecoration(
              //     color: Color(0xfff3f3f3),
              //     borderRadius: BorderRadius.circular(16),
              //   ),
              //   child: TextField(
              //     controller: nameText,
              //     maxLines: 1,
              //     keyboardType: TextInputType.name,
              //     textCapitalization: TextCapitalization.words,
              //     textAlignVertical: TextAlignVertical.center,
              //     textAlign: TextAlign.left,
              //     style: TextStyle(
              //       fontWeight: FontWeight.w600,
              //       fontSize: 18,
              //       color: Colors.black,
              //     ),
              //     decoration: InputDecoration(
              //         border: InputBorder.none,
              //         contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 0),
              //         errorBorder: InputBorder.none,
              //         enabledBorder: InputBorder.none,
              //         focusedBorder: InputBorder.none,
              //         disabledBorder: InputBorder.none,
              //         suffixIcon: Icon(Icons.person, color: Colors.black),
              //         hintText: "Name"),
              //   ),
              // ),
              // const Spacer(flex: 58),
              // Container(
              //   width: 350,
              //   child: Text(
              //     "Meet Guidelines:\n1) For privacy reasons please find a private place to join the call.\n2) By default your audio & video are muted.",
              //     style: TextStyle(
              //       fontSize: 14,
              //       color: Color(0xff898989),
              //     ),
              //   ),
              // ),
              // const Spacer(flex: 58),
              // Row(
              //   children: [
              //     const Spacer(flex: 32),
              //     GestureDetector(
              //       onTap: () {
              //         _onAudioMutedChanged(!isAudioMuted);
              //       },
              //       child: AnimatedContainer(
              //         duration: Duration(milliseconds: 300),
              //         decoration: BoxDecoration(
              //             color: isAudioMuted
              //                 ? Color(0xffD64467)
              //                 : Color(0xffffffff),
              //             borderRadius: BorderRadius.circular(16),
              //             boxShadow: [
              //               BoxShadow(
              //                   blurRadius: 10,
              //                   color: Colors.black.withOpacity(0.06),
              //                   offset: Offset(0, 4)),
              //             ]),
              //         width: 72,
              //         height: 72,
              //         child: Icon(
              //           isAudioMuted
              //               ? Icons.mic_off_sharp
              //               : Icons.mic_none_sharp,
              //           color: isAudioMuted ? Colors.white : Colors.black,
              //         ),
              //       ),
              //     ),
              //     const Spacer(flex: 16),
              //     GestureDetector(
              //       onTap: () {
              //         _onVideoMutedChanged(!isVideoMuted);
              //       },
              //       child: AnimatedContainer(
              //         duration: Duration(milliseconds: 300),
              //         decoration: BoxDecoration(
              //             color: isVideoMuted
              //                 ? Color(0xffD64467)
              //                 : Color(0xffffffff),
              //             borderRadius: BorderRadius.circular(16),
              //             boxShadow: [
              //               BoxShadow(
              //                   blurRadius: 10,
              //                   color: Colors.black.withOpacity(0.06),
              //                   offset: Offset(0, 4)),
              //             ]),
              //         width: 72,
              //         height: 72,
              //         child: Icon(
              //           isVideoMuted
              //               ? Icons.videocam_off_sharp
              //               : Icons.videocam,
              //           color: isVideoMuted ? Colors.white : Colors.black,
              //         ),
              //       ),
              //     ),
              //     const Spacer(flex: 16),
              //     GestureDetector(
              //       onTap: () {
              //         _joinMeeting(); // Join meet on tap
              //       },
              //       child: AnimatedContainer(
              //           duration: Duration(milliseconds: 300),
              //           decoration: BoxDecoration(
              //               color: kPrimary,
              //               borderRadius: BorderRadius.circular(16),
              //               boxShadow: [
              //                 BoxShadow(
              //                     blurRadius: 10,
              //                     color: Colors.black.withOpacity(0.06),
              //                     offset: Offset(0, 4)),
              //               ]),
              //           width: 174,
              //           height: 72,
              //           child: Center(
              //             child: Text(
              //               isLeft ? "RECONNECT" : "JOIN MEET",
              //               style: TextStyle(
              //                 fontWeight: FontWeight.w600,
              //                 fontSize: 18,
              //                 color: Colors.white,
              //               ),
              //               textAlign: TextAlign.center,
              //             ),
              //           )),
              //     ),
              //     const Spacer(flex: 32),
              //   ],
              // ),
              // const Spacer(flex: 38),
            ],
          ),
        ),
      ),
    );
  }
// Can use this, to add one more button which makes the meet Audio only.
  // _onAudioOnlyChanged(bool? value) {
  //   setState(() {
  //     isAudioOnly = value!;
  //   });
  // }

  _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value!;
    });
  }

  _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value!;
    });
  }

// Defining Join meeting function
  _joinMeeting() async {
    // Using default serverUrl that is https://meet.jit.si/
    String? serverUrl =
        (serverText.text.trim().isEmpty ? null : serverText.text);

    try {
      // Enable or disable any feature flag here
      // If feature flag are not provided, default values will be used
      // Full list of feature flags (and defaults) available in the README
      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
      };

      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
      featureFlags[FeatureFlagEnum.ADD_PEOPLE_ENABLED] = false;
      featureFlags[FeatureFlagEnum.INVITE_ENABLED] = false;

      //uncomment to modify video resolution
      //featureFlag.resolution = FeatureFlagVideoResolution.MD_RESOLUTION;

      // Define meetings options here
      var options = JitsiMeetingOptions(room: roomText.text)
        ..serverURL = serverUrl
        ..subject = subjectText.text
        ..userDisplayName = nameText.text
        ..userEmail = emailText.text
        // ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlags.addAll(featureFlags)
        ..userAvatarURL = Get.find<AuthController>().profileImage['formats']
            ['thumbnail']['url'];
      // ..featureFlag = featureFlag;

      debugPrint("JitsiMeetingOptions: $options");
      // Joining meet
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(onConferenceWillJoin: (message) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: (message) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: (message) {
          debugPrint("${options.room} terminated with message: $message");
        }, onPictureInPictureWillEnter: (message) {
          debugPrint("${options.room} entered PIP mode with message: $message");
        }, onPictureInPictureTerminated: (message) {
          debugPrint("${options.room} exited PIP mode with message: $message");
        }),
        // by default, plugin default constraints are used
        //roomNameConstraints: new Map(), // to disable all constraints
        //roomNameConstraints: customContraints, // to use your own constraint(s)
      );
      // I added a 50 minutes time limit, you can remove it if you want.
      Future.delayed(const Duration(minutes: 50))
          .then((value) => JitsiMeet.closeMeeting());
    } catch (error) {
      debugPrint("error: $error");
    }
  }
}
