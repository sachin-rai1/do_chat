import 'dart:developer';

import 'package:chat_application/UI/auth/ProfileScreen.dart';
import 'package:chat_application/Widgets/chat_user_card.dart';
import 'package:chat_application/api/api.dart';
import 'package:chat_application/helper/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../Model/UserModel.dart';
import '../helper/constants.dart';

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

    SystemChannels.lifecycle.setMessageHandler((message) {
      log("Message : $message");

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('paused')) {
          APIs.updateActiveStatus(false);
        }
        if (message.toString().contains('resumed')) {
          APIs.updateActiveStatus(true);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (isSearching) {
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
              title: isSearching
                  ? TextField(
                      onChanged: (val) {
                        _searchlist.clear();

                        for (var i in list) {
                          if (i.name!
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email!
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _searchlist.add(i);
                          }
                          setState(() {
                            _searchlist;
                          });
                        }
                      },
                      style: const TextStyle(fontSize: 16, letterSpacing: 0.5),
                      autofocus: true,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "Name , Email"),
                    )
                  : const Text("Do Chat"),
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
                onPressed: () {
                  _addChatUserDialog();
                },
                child: const Icon(Icons.add_comment_rounded),
              ),
            ),
            body: StreamBuilder(
              stream: APIs.getMyUserId(),

              ///get id of only known user
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  return StreamBuilder(
                      stream: APIs.getAllUser(
                          snapshot.data!.docs.map((e) => e.id).toList()),
                      builder: (context, snapshot) {
                        final data = snapshot.data?.docs;
                        list = data
                                ?.map((e) => UserModel.fromJson(e.data()))
                                .toList() ??
                            [];
                        return (snapshot.connectionState ==
                                ConnectionState.active)
                            ? (list.isNotEmpty)
                                ? ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.only(top: h * 0.01),
                                    itemCount: isSearching
                                        ? _searchlist.length
                                        : list.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return ChatUserCard(
                                          user: isSearching
                                              ? _searchlist[index]
                                              : list[index]);
                                    })
                                : const Center(
                                    child: Text("No Connection Found"))
                            : const Center(
                                child: Text(
                                    "No chat found"),
                              );
                      });
                }
                return const Center(
                  child: Text(
                      "No connection Found Please wait or Try Again later"),
                );
              },
            )),
      ),
    );
  }

  void _addChatUserDialog() {
    String email = "";

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  top: 20, bottom: 10, left: 24, right: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: const [
                  Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  Text("  Add User"),
                ],
              ),
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                  hintText: "eg : abc@gmail.com",
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    Get.back();
                    if (email.isNotEmpty) {
                      APIs.addChatUser(email).then((value) {
                        if (!value) {
                          Dialogs.showSnackBar(
                              context, "User Doesn't Exists", Colors.red);
                        }
                      });
                    }
                  },
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                )
              ],
            ));
  }
}
