import 'dart:developer';
import 'dart:io';
import 'package:chat_application/api/api.dart';
import 'package:chat_application/helper/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../helper/constants.dart';
import '../home_screen.dart';

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
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isAnimate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    Dialogs.showProgressBar(context);
                    _signInWithGoogle().then((user) async {
                      Navigator.pop(context);

                      if (user != null) {
                        if (await APIs.userExists()) {
                          log("User Data : ${user.user}");
                          Get.off(() => const HomeScreen())?.then((value) => APIs.updateActiveStatus(true));
                        }
                        else{
                          log("User Creating");
                          APIs.createUser().then((value) => Get.off(() => const HomeScreen()));
                        }
                      }
                    });
                  },
                ))
          ],
        ));
  }

  // _handleGoogleBtnClick() {
  //   _signInWithGoogle();
  // }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup("google.com");
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log("_signInWithGoogle(): $e");
      Dialogs.showSnackBar(
          context, "Something Went Wrong \nTry again in SomeTime" , Colors.red);
      return null;
    }
  }
}
