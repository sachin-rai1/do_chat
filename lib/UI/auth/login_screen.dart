
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isAnimate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Welcome To Do Chat"),
        ),
        body: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(seconds: 1),
              top: 20,
              height: h / 3,
              width: w,
              right: isAnimate ? 0 : w,
              child: Image.asset(
                "assets/icons/appIcon.png",
              ),
            ),
            AnimatedPositioned(
                duration: const Duration(seconds: 5),
                bottom: h * 0.15,
                left: w * 0.05,
                width: w * 0.9,
                height: h * 0.05,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.green,
                  ),
                  icon: Image.asset(
                    height: h * 0.03,
                    "assets/icons/google.jpg",
                  ),
                  label: RichText(
                      text: const TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          children: [
                        TextSpan(text: "Log In"),
                        TextSpan(
                            text: " Google",
                            style: TextStyle(fontWeight: FontWeight.w500))
                      ])),
                  onPressed: () {
                    Get.to(HomeScreen());
                  },
                ))
          ],
        ));
  }
}
