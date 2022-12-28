import 'dart:developer';

import 'package:chat_application/UI/auth/login_screen.dart';
import 'package:chat_application/Widgets/chat_user_card.dart';
import 'package:chat_application/api/api.dart';
import 'package:chat_application/helper/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../helper/Constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title: const Text("Do Chat"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
            Get.off(const LoginScreen());
          },
          child: const Icon(Icons.add_comment_rounded),
        ),
      ),
      body: StreamBuilder(
          stream: APIs.fireStore.collection('users').snapshots(),
          builder: (context, snapshot) {
            final list = [];

            if (snapshot.hasData) {
              final data = snapshot.data?.docs;
              for (var i in data!) {
                log("Data ${i.data()}");
                list.add(i.data()['name']);
              }
            }
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: h * 0.01),
                itemCount: list.length,
                itemBuilder: (BuildContext context, index) {
                  return ChatUserCard();
                });
          }),
    );
  }
}
