import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/controller/praktek_education_edit.dart';
import 'package:praktek_app/screens/praktek_education_add.dart';
import 'package:timelines/timelines.dart';

class PraktekEducation extends StatelessWidget {
  const PraktekEducation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PraktekEducationEditController controller =
        Get.put(PraktekEducationEditController());
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
            'Pendidikan',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Obx(
                () => controller.doctor.length > 0 &&
                        controller
                                .doctor['attributes']['doctor_cv_educations']
                                    ['data']
                                .length >
                            0
                    ? FixedTimeline.tileBuilder(
                        theme: TimelineThemeData(
                            color: kText2,
                            nodePosition: 0.0,
                            connectorTheme: ConnectorThemeData(space: 51)),
                        builder: TimelineTileBuilder.connectedFromStyle(
                          connectionDirection: ConnectionDirection.before,
                          connectorStyleBuilder: (context, index) {
                            return (index == 1 ||
                                    index ==
                                        controller
                                            .doctor['attributes']
                                                ['doctor_cv_educations']['data']
                                            .length)
                                ? ConnectorStyle.dashedLine
                                : ConnectorStyle.solidLine;
                          },
                          indicatorStyleBuilder: (context, index) =>
                              IndicatorStyle.dot,
                          contentsBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: InkWell(
                              onLongPress: () {
                                controller.removeEducation(
                                    controller.doctor['attributes']
                                            ['doctor_cv_educations']['data']
                                        [index]['id']);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.doctor['attributes']
                                            ['doctor_cv_educations']['data']
                                            [index]['attributes']['year']
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(controller.doctor['attributes']
                                          ['doctor_cv_educations']['data']
                                      [index]['attributes']['name']),
                                ],
                              ),
                            ),
                          ),
                          itemCount: controller
                              .doctor['attributes']['doctor_cv_educations']
                                  ['data']
                              .length,
                        ),
                      )
                    : Container(),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => PraktekEducationAdd());
                },
                child: Container(
                  width: Get.width,
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kPrimary,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Icon(
                    Icons.add,
                    color: kPrimary,
                  ),
                ),
              ),
              Container(),
            ],
          ),
        ));
  }
}
