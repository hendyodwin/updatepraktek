import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praktek_app/constants/colors.dart';
import 'package:praktek_app/root.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final List<Map> imgList = [
      {
        "image": 'assets/images/image-1.png',
        "title": "Easy Access",
        "description":
            "Dapatkan akses lebih dari 1000 dokter terpercaya di Indonesia."
      },
      {
        "image": 'assets/images/image-2.png',
        "title": "Easy Booking",
        "description":
            "Pilih dan booking konsultasi dengan Dokter Spesialis Berpengalaman."
      },
      {
        "image": 'assets/images/Image-3.png',
        "title": "Flexible Consultation",
        "description":
            "Konsultasi kesehatan dengan dokter spesialis kami kapanpun dan dimanapun."
      }
    ];
    return Scaffold(body: Builder(builder: (context) {
      final double height = MediaQuery.of(context).size.height;
      return Stack(
        children: [
          CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
                height: height,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }
                // autoPlay: false,
                ),
            items: imgList
                .map((item) => Stack(
                      children: [
                        Container(
                          height: height * 0.8,
                          child: Center(
                              child: Image.asset(
                            item['image'],
                            fit: BoxFit.fitHeight,
                            height: height,
                          )),
                        ),
                        Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Container(
                            height: Get.height * 0.4,
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(32)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    item['description'],
                                    style: TextStyle(
                                        height: 1.3,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ))
                .toList(),
          ),
          Align(
            alignment: FractionalOffset.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 60),
              child: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: _current == entry.key ? 32 : 12.0,
                        height: 12.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: _current == entry.key
                            ? BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                shape: BoxShape.rectangle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? kPrimary
                                        : kPrimary)
                                    .withOpacity(
                                        _current == entry.key ? 1 : 0.6))
                            : BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? kPrimary
                                        : kPrimary)
                                    .withOpacity(
                                        _current == entry.key ? 1 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 32.0, bottom: 60),
              child: InkWell(
                onTap: () {
                  Get.offAll(Root());
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: kPrimary,
                      ),
                      color: kPrimary,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Center(
                    child: Text(
                      'Mulai',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }));
  }
}
