import 'dart:developer';

import 'package:chat_application/UI/HomeScreen.dart';
import 'package:chat_application/UI/auth/login_screen.dart';
import 'package:chat_application/api/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.white  , systemNavigationBarColor: Colors.white));

      if (APIs.auth.currentUser != null) {
        log("User :${APIs.auth.currentUser}");
        Get.offAll(HomeScreen());
      } else {
        Get.offAll(LoginScreen());
      }
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
            Positioned(
              top: 20,
              height: h / 3,
              width: w,
              child: Image.asset(
                "assets/icons/appIcon.png",
              ),
            ),
            Positioned(
                left: w / 3,
                bottom: h * 0.15,
                width: w,
                child: Text("Made in India With ♥"))
          ],
        ));
  }
}
