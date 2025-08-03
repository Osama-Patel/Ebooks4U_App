import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:learnera/constant/colors.dart';
import 'package:learnera/constant/images.dart';
import 'package:learnera/constant/text.dart';

import 'package:learnera/pages/login_screen.dart';

class OnbordingData {
  final String img;
  final String title;
  final String subtitle;
  OnbordingData(this.img, this.title, this.subtitle);
}

List<OnbordingData> onbording = [
  OnbordingData(
    Appimg().onbor1,
    Apptxt().title1,
    Apptxt().sub1,
  ),
  OnbordingData(
    Appimg().onbor2,
    Apptxt().title2,
    Apptxt().sub2,
  ),
  OnbordingData(
    Appimg().onbor3,
    Apptxt().title3,
    Apptxt().sub3,
  ),
];

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {
  int currentIndex = 0;
  PageController? _pageController;
  // final auth = FirebaseAuth.instance;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  // void onboardingController() {
  //   if (auth.currentUser != null) {
  //     Get.offAll(HomeScreen());
  //   } else {
  //     Get.offAll(OnbordingScreen());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      currentIndex = value;
                    });
                  },
                  itemCount: onbording.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 550,
                      ),
                      SvgPicture.asset(
                        onbording[index].img,
                      ),
                      Text(
                        onbording[index].title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 60),
                      Text(
                        onbording[index].subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onbording.length,
                  (index) => Container(
                    margin: const EdgeInsets.only(left: 10),
                    height: MediaQuery.of(context).size.height / 120,
                    width: currentIndex == index
                        ? MediaQuery.of(context).size.width / 17
                        : MediaQuery.of(context).size.width / 40,
                    decoration: BoxDecoration(
                        color: currentIndex == index
                            ? Appcolor().primarycolor
                            : Appcolor().grycolor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 17,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
                child: Row(
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Appcolor().primarycolor),
                        splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: () {
                        _pageController!.jumpToPage(2);
                      },
                      child: Text(
                        currentIndex == 2 ? Apptxt().blntxt : Apptxt().skptxt,
                        style: TextStyle(
                            fontSize: 19, color: Appcolor().primarycolor),
                      ),
                    ),
                    const Spacer(),
                    // ignore: sized_box_for_whitespace
                    Container(
                      height: MediaQuery.of(context).size.height / 19,
                      width: currentIndex == 2
                          ? MediaQuery.of(context).size.width / 2.60
                          : MediaQuery.of(context).size.width / 4,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            backgroundColor: MaterialStateProperty.all(
                                Appcolor().primarycolor),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        onPressed: () {
                          if (currentIndex == 2) {
                            Get.to(const LoginScreen());
                          } else {
                            _pageController!.nextPage(
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.bounceIn);
                          }
                        },
                        child: Text(
                          currentIndex == 2 ? Apptxt().gttxt : Apptxt().nxttxt,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
