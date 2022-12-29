import 'dart:developer';

import 'package:chat_application/UI/auth/ProfileScreen.dart';
import 'package:chat_application/UI/auth/login_screen.dart';
import 'package:chat_application/Widgets/chat_user_card.dart';
import 'package:chat_application/api/api.dart';
import 'package:chat_application/helper/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Model/UserModel.dart';
import '../helper/Constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserModel> list = [];
  final List<UserModel> _searchlist = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if(isSearching){
            setState(() {
              isSearching = !isSearching;
            });
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const Icon(CupertinoIcons.home),
            title:isSearching?  TextField(
              onChanged: (val){
                _searchlist.clear();

                for(var i in list){
                  if(i.name!.toLowerCase().contains(val.toLowerCase()) || i.email!.toLowerCase().contains(val.toLowerCase())){
                    _searchlist.add(i);
                  }
                  setState(() {
                    _searchlist;
                  });
                }
              },
              style: const TextStyle(fontSize: 16 , letterSpacing: 0.5),
              autofocus: true,
              decoration: const InputDecoration(
                border: InputBorder.none ,
                hintText: "Name , Email"

              ),
            ): const Text("Do Chat"),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                    });
                  },
                  icon: isSearching
                      ? const Icon(CupertinoIcons.clear_circled_solid)
                      : const Icon(Icons.search)),
              IconButton(
                  onPressed: () {
                    Get.to(() => ProfileScreen(
                          user: APIs.me,
                        ));
                  },
                  icon: const Icon(Icons.more_vert)),
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
              stream: APIs.getAllUser(),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                list =
                    data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];

                return (snapshot.connectionState == ConnectionState.active)
                    ? (list.isNotEmpty)
                        ? ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(top: h * 0.01),
                            itemCount:isSearching?_searchlist.length:list.length,
                            itemBuilder: (BuildContext context, index) {
                              return ChatUserCard(user:isSearching?_searchlist[index]:list[index]);
                            })
                        : const Center(child: Text("No Connection Found"))
                    : const Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}
